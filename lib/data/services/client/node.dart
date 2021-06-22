import 'dart:async';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/style.dart';
import 'lobby.dart';
import 'package:sonr_app/data/services/services.dart';
export 'package:sonr_plugin/sonr_plugin.dart';

class Sonr extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<Sonr>();
  static Sonr get to => Get.find<Sonr>();
  static bool get isReady => isRegistered && to._status.value.isConnected;
  static Node get node => to._node;

  // @ Set Properties
  final _status = Rx<Status>(Status.IDLE);

  // @ Static Accessors
  static Rx<Status> get status => to._status;

  // @ Set References
  late Node _node;

  // * ------------------- Constructers ----------------------------
  /// @ Initialize Service Method
  Future<Sonr> init() async {
    // Create Node
    _node = await SonrCore.initialize(RequestBuilder.initialize);

    // Set Handlers
    _node.onStatus = _handleStatus;
    _node.onError = _handleError;
    _node.onEvent = LobbyService.to.handleEvent;
    _node.onInvite = ReceiverService.to.handleInvite;
    _node.onReply = SenderService.to.handleReply;
    _node.onProgress = ReceiverService.to.handleProgress;
    _node.onReceived = ReceiverService.to.handleReceived;
    _node.onTransmitted = SenderService.to.handleTransmitted;
    return this;
  }

  /// @ Connect to Service Method
  Future<bool> connect() async {
    // Check for User
    if (ContactService.hasUser.value) {
      // Connect Node
      node.connect(await RequestBuilder.connection);

      // Send Initial Position Update
      node.update(RequestBuilder.updatePosition);
      return true;
    } else {
      return false;
    }
  }

  // * ------------------- Methods ----------------------------
  /// @ Sign Provided Data with Private Key
  static Future<AuthResponse> sign(AuthRequest request) async {
    return await to._node.sign(request);
  }

  /// @ Store Property in Memory Store
  static Future<StoreResponse> store(StoreRequest request) async {
    return await to._node.store(request);
  }

  /// @ Verify Provided Data with Private Key
  static Future<VerifyResponse> verify(VerifyRequest request) async {
    return await to._node.verify(request);
  }

  /// @ Retreive URLLink Metadata
  static Future<URLLink> getURL(String url) async {
    return await SonrCore.getUrlLink(url);
  }

  /// @ Send Position Update for Node
  static void update(Position position) {
    if (status.value.isConnected && isRegistered) {
      to._node.update(Request.newUpdatePosition(position));
    }
  }

  /// @ Sets Contact for Node
  static void setProfile(Contact contact) async {
    if (status.value.isConnected && isRegistered) {
      to._node.update(Request.newUpdateContact(contact));
    }
  }

  /// @ Invite Peer with Built Request
  static void sendFlat(Peer? peer) async {
    if (status.value.isConnected && isRegistered) {
      to._node.invite(InviteRequest(to: peer!)..setContact(ContactService.contact.value, isFlat: true));
    }
  }

  // * ------------------- Callbacks ----------------------------
  /// @ Handle Bootstrap Result
  void _handleStatus(StatusUpdate data) {
    // Check for Homescreen Controller
    if (data.value == Status.AVAILABLE) {
      DeviceService.playSound(type: Sounds.Connected);

      // Handle Available
      node.update(Request.newUpdatePosition(DeviceService.position.value));
    }

    // Update Status
    _status(data.value);

    // Logging
    Logger.info("Node(Callback) Status: " + data.value.toString());
  }

  /// @ An Error Has Occurred
  void _handleError(ErrorMessage data) async {
    if (data.severity != ErrorMessage_Severity.LOG) {
      AppRoute.snack(SnackArgs.error("", error: data));
    } else {}

    // Logging
    Logger.sError(data);
  }
}
