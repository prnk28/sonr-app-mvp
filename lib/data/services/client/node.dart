import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/style/style.dart';
import 'lobby.dart';
import 'package:sonr_app/data/services/services.dart';
export 'package:sonr_plugin/sonr_plugin.dart';

class NodeService extends GetxService with WidgetsBindingObserver {
  // Accessors
  static bool get isRegistered => Get.isRegistered<NodeService>();
  static NodeService get to => Get.find<NodeService>();
  static bool get isReady => _checkReady();
  static Node get instance => to._instance;
  static Rx<Status> get status => to._status;
  static Rx<AppState> get lifecycle => to._lifecycle;

  // Properties
  final _lifecycle = AppState.Started.obs;
  final _status = Rx<Status>(Status.DEFAULT);

  // References
  late Node _instance;
  late StreamSubscription<ConnectivityResult> _connectionStream;
  late RoomSubscription _roomEventStream;
  late ProgressSubscription _progressEventStream;
  late StatusSubscription _statusEventStream;
  late MailSubscription _mailEventStream;
  late InviteSubscription _inviteEventStream;
  late ReplySubscription _replyEventStream;
  late TransmittedSubscription _transmittedEventStream;
  late ReceivedSubscription _receivedEventStream;
  late ErrorSubscription _errorEventStream;

  // ^ Constructer ^ //
  Future<NodeService> init() async {
    // Bind Observers
    WidgetsBinding.instance!.addObserver(this);

    // Create Node
    _instance = await SonrCore.initialize(RequestBuilder.initialize);

    // Set Callbacks
    _instance.onConnected = _handleConnected;
    _inviteEventStream = _instance.onInvite(ReceiverService.to.handleInvite);
    _replyEventStream = _instance.onReply(SenderService.to.handleReply);
    _transmittedEventStream = _instance.onTransmitted(SenderService.to.handleTransmitted);
    _receivedEventStream = _instance.onReceived(ReceiverService.to.handleReceived);
    _errorEventStream = _instance.onError(_handleError);
    _roomEventStream = _instance.onRoom(LobbyService.to.handleEvent);
    _progressEventStream = _instance.onProgress(ReceiverService.to.handleProgress);
    _statusEventStream = _instance.onStatus(_handleStatus);
    _mailEventStream = _instance.onMail(ReceiverService.to.handleMail);
    return this;
  }

  @override
  onClose() {
    _connectionStream.cancel();
    _roomEventStream.cancel();
    _mailEventStream.cancel();
    _progressEventStream.cancel();
    _statusEventStream.cancel();
    _inviteEventStream.cancel();
    _replyEventStream.cancel();
    _transmittedEventStream.cancel();
    _receivedEventStream.cancel();
    _errorEventStream.cancel();
    super.onClose();
  }

  // * ------------------- Methods ----------------------------
  /// #### Connect to Service Method
  Future<bool> connect() async {
    // Check for User
    if (ContactService.status.value.hasUser && DeviceService.hasInternet) {
      // End Host if Connected
      if (status.value.isConnected) {
        instance.stop();
      }

      // Connect Node
      instance.connect(await RequestBuilder.connection);

      // Send Initial Position Update
      instance.update(RequestBuilder.updatePosition);
      _handleSNameMigration();
      return true;
    } else {
      return false;
    }
  }

  /// #### Sign Provided Data with Private Key
  static Future<AuthResponse> sign(AuthRequest request) async {
    return await to._instance.sign(request);
  }

  /// #### Verify Provided Data with Private Key
  static Future<VerifyResponse> verify(VerifyRequest request) async {
    return await to._instance.verify(request);
  }

  /// #### Retreive URLLink Metadata
  static Future<URLLink> getURL(String url) async {
    return await to._instance.url(url);
  }

  /// #### Send Position Update for Node
  static void update(Position position) {
    if (status.value.isConnected && isRegistered) {
      to._instance.update(API.newUpdatePosition(position));
    }
  }

  /// #### Sets Contact for Node
  static void setProfile(Contact contact) async {
    if (status.value.isConnected && isRegistered) {
      to._instance.update(API.newUpdateContact(contact));
    }
  }

  /// #### Invite Peer with Built Request
  static void sendFlat(Member? member) async {
    if (status.value.isConnected && isRegistered) {
      to._instance.invite(InviteRequest(to: member!)..setContact(ContactService.contact.value, type: InviteRequest_Type.DIRECT));
    }
  }

  // * ------------------- Callbacks ----------------------------
  /// #### Handle Connection Result
  void _handleConnected(ConnectionResponse data) {
    // Log Result
    Logger.info(data.toString());
    print("Textile Threads");
    data.threads.forEach((key, value) {
      print(key);
      print(value.toString());
    });
  }

  /// #### Handle Bootstrap Result
  void _handleStatus(StatusEvent data) {
    // Check for Homescreen Controller
    if (data.value == Status.AVAILABLE) {
      Sound.Connected.play();

      // Handle Available
      instance.update(API.newUpdatePosition(DeviceService.position.value));
    }

    // Update Status
    _status(data.value);

    // Logging
    Logger.info("Node(Callback) Status: " + data.value.toString());
  }

  /// #### An Error Has Occurred
  void _handleError(ErrorEvent data) async {
    // Check Severity
    if (data.severity != ErrorEvent_Severity.LOG) {
      AppRoute.snack(SnackArgs.error("", error: data));
    }
  }

  // * ------------------- Helpers ----------------------------
  // Verifies if Node is Ready to communicate
  static bool _checkReady() {
    return isRegistered && to._status.value.isConnected && ContactService.status.value.hasUser;
  }

  Future<void> _handleSNameMigration() async {
    // Update Keypair Migration
    if (!Logger.hasMigratedKeyPair.val) {
      Logger.hasMigratedKeyPair.val = true;
    }

    // Migrate SName
    if (!Logger.hasMigratedSName.val) {
      // Retreive Public Key
      final response = await instance.verify(API.newVerifyRead());

      // Validate SName
      if (response.publicKey.length > 0) {
        // Create New Record and Update Status
        Logger.setMigration(DNSRecord.newName(
          name: ContactService.sName.toLowerCase(),
          publicKey: response.publicKey,
        ));
      }
    }
  }

  // * ------------------- Observers ----------------------------
  // ^ Extension: Updates Lifecycle ^ //
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Update RX Property
    this._lifecycle(AppLifecycle.toAppState(state));

    // Check Updated State
    switch (this._lifecycle.value) {
      case AppState.Resumed:
        this._instance.resume();
        break;
      case AppState.Paused:
        this._instance.pause();
        break;
      case AppState.Stopped:
        this._instance.stop();
        break;
      case AppState.Started:
        break;
    }
  }
}
