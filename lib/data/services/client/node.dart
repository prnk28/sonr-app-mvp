import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/style.dart';
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
  static Rx<ConnectivityResult> get connectivity => to._connectivity;
  static Rx<AppLifecycleState> get lifecycle => to._lifecycle;

  // Properties
  final _connectivity = ConnectivityResult.none.obs;
  final _lifecycle = AppLifecycleState.resumed.obs;
  final _status = Rx<Status>(Status.IDLE);

  // References
  late Node _instance;

  // ^ Constructer ^ //
  Future<NodeService> init() async {
    // Bind Observers
    WidgetsBinding.instance!.addObserver(this);
    _connectivity.bindStream(Connectivity().onConnectivityChanged);

    // Create Node
    _instance = await SonrCore.initialize(RequestBuilder.initialize);
    _instance.onConnected = _handleConnected;
    _instance.onStatus = _handleStatus;
    _instance.onError = _handleError;
    _instance.onEvent = LobbyService.to.handleEvent;
    _instance.onInvite = ReceiverService.to.handleInvite;
    _instance.onReply = SenderService.to.handleReply;
    _instance.onProgress = ReceiverService.to.handleProgress;
    _instance.onReceived = ReceiverService.to.handleReceived;
    _instance.onTransmitted = SenderService.to.handleTransmitted;
    return this;
  }

  // * ------------------- Methods ----------------------------
  /// @ Connect to Service Method
  Future<bool> connect() async {
    // Check for User
    if (ContactService.status.value.hasUser) {
      // Connect Node
      instance.connect(await RequestBuilder.connection);

      // Send Initial Position Update
      instance.update(RequestBuilder.updatePosition);
      return true;
    } else {
      return false;
    }
  }

  /// @ Sign Provided Data with Private Key
  static Future<AuthResponse> sign(AuthRequest request) async {
    return await to._instance.sign(request);
  }

  /// @ Store Property in Memory Store
  static Future<StoreResponse> store(StoreRequest request) async {
    return await to._instance.store(request);
  }

  /// @ Verify Provided Data with Private Key
  static Future<VerifyResponse> verify(VerifyRequest request) async {
    return await to._instance.verify(request);
  }

  /// @ Retreive URLLink Metadata
  static Future<URLLink> getURL(String url) async {
    return await SonrCore.getUrlLink(url);
  }

  /// @ Send Position Update for Node
  static void update(Position position) {
    if (status.value.isConnected && isRegistered) {
      to._instance.update(Request.newUpdatePosition(position));
    }
  }

  /// @ Sets Contact for Node
  static void setProfile(Contact contact) async {
    if (status.value.isConnected && isRegistered) {
      to._instance.update(Request.newUpdateContact(contact));
    }
  }

  /// @ Invite Peer with Built Request
  static void sendFlat(Peer? peer) async {
    if (status.value.isConnected && isRegistered) {
      to._instance.invite(InviteRequest(to: peer!)..setContact(ContactService.contact.value, isFlat: true));
    }
  }

  // * ------------------- Callbacks ----------------------------
  /// @ Handle Connection Result
  void _handleConnected(ConnectionResponse data) {
    Logger.info(data.toString());
  }

  /// @ Handle Bootstrap Result
  void _handleStatus(StatusUpdate data) {
    // Check for Homescreen Controller
    if (data.value == Status.AVAILABLE) {
      DeviceService.playSound(type: Sounds.Connected);

      // Handle Available
      instance.update(Request.newUpdatePosition(DeviceService.position.value));
    }

    // Update Status
    _status(data.value);

    // Logging
    Logger.info("Node(Callback) Status: " + data.value.toString());
  }

  /// @ An Error Has Occurred
  void _handleError(ErrorMessage data) async {
    // Check for Peer Error
    if (data.type == ErrorMessage_Type.PEER_NOT_FOUND_INVITE) {
      final removeEvent = LobbyEvent(id: data.data, subject: LobbyEvent_Subject.EXIT);
      LobbyService.to.handleEvent(removeEvent);
    }

    // Check Severity
    if (data.severity != ErrorMessage_Severity.LOG) {
      AppRoute.snack(SnackArgs.error("", error: data));
    }

    // Logging
    Logger.sError(data);
  }

  // * ------------------- Helpers ----------------------------
  static bool _checkReady() {
    return isRegistered && to._status.value.isConnected;
  }

  // * ------------------- Observers ----------------------------
  // ^ Extension: Updates Lifecycle ^ //
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    this._lifecycle(state);
  }
}
