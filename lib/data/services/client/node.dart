import 'dart:async';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/style.dart';
import 'local.dart';
import 'package:sonr_app/data/services/services.dart';
export 'package:sonr_plugin/sonr_plugin.dart';

class NodeService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<NodeService>();
  static NodeService get to => Get.find<NodeService>();
  static bool get isReady => isRegistered && to._status.value.isConnected;

  // @ Set Properties
  final _status = Rx<Status>(Status.IDLE);

  // @ Static Accessors
  static Rx<Status> get status => to._status;

  // @ Set References
  late Node node;

  // * ------------------- Constructers ----------------------------
  /// @ Initialize Service Method
  Future<NodeService> init() async {
    // Create Node
    node = await SonrCore.initialize(RequestBuilder.initialize);

    // Set Handlers
    node.onStatus = _handleStatus;
    node.onError = _handleError;
    node.onRefreshed = LocalService.to.handleRefresh;
    node.onInvited = ReceiverService.to.handleInvite;
    node.onReplied = SenderService.to.handleReply;
    node.onProgressed = ReceiverService.to.handleProgress;
    node.onReceived = ReceiverService.to.handleReceived;
    node.onTransmitted = SenderService.to.handleTransmitted;
    return this;
  }

  /// @ Connect to Service Method
  Future<bool> connect() async {
    // Check for User
    if (ContactService.hasUser.value) {
      // Connect Node
      node.connect(await RequestBuilder.connection);

      // Send Initial Position Update
      node.update(RequestBuilder.positionUpdate);
      return true;
    } else {
      return false;
    }
  }

  // * ------------------- Methods ----------------------------
  /// @ Sign Provided Data with Private Key
  static Future<AuthResponse> sign(AuthRequest request) async {
    return await to.node.sign(request);
  }

  /// @ Store Property in Memory Store
  static Future<StoreResponse> store(StoreRequest request) async {
    return await to.node.store(request);
  }

  /// @ Verify Provided Data with Private Key
  static Future<VerifyResponse> verify(VerifyRequest request) async {
    return await to.node.verify(request);
  }

  /// @ Retreive URLLink Metadata
  static Future<URLLink> getURL(String url) async {
    var link = await SonrCore.getUrlLink(url);
    return link ?? URLLink(url: url);
  }

  /// @ Send Position Update for Node
  static void update(Position position) {
    if (status.value.isConnected && isRegistered) {
      to.node.update(Request.newUpdatePosition(position));
    }
  }

  /// @ Sets Contact for Node
  static void setProfile(Contact contact) async {
    if (status.value.isConnected && isRegistered) {
      to.node.update(Request.newUpdateContact(contact));
    }
  }

  /// @ Invite Peer with Built Request
  static void sendFlat(Peer? peer) async {
    if (status.value.isConnected && isRegistered) {
      to.node.invite(InviteRequest(to: peer!)..setContact(ContactService.contact.value, isFlat: true));
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
