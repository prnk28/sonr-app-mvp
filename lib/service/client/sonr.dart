import 'dart:async';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/env.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart' as sonr;
import 'lobby.dart';
import '../user/user.dart';
import 'session.dart';
export 'package:sonr_plugin/sonr_plugin.dart';

class SonrService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<SonrService>();
  static SonrService get to => Get.find<SonrService>();

  // @ Set Properties
  final _properties = Peer_Properties().obs;
  final _status = Rx<Status>(Status.IDLE);

  // @ Static Accessors
  static Rx<Status> get status => to._status;

  // @ Set References
  late Node _node;
  bool _isAuth = false;
  final _apiKeys = APIKeys(
    handshakeKey: Env.hs_key,
    handshakeSecret: Env.hs_secret,
    textileKey: Env.hub_key,
    textileSecret: Env.hub_secret,
    ipApiKey: Env.ip_key,
    rapidApiHost: Env.rapid_host,
    rapidApiKey: Env.rapid_key,
  );

  // * ------------------- Constructers ----------------------------
  /// @ Initialize Service Method
  Future<SonrService> init() async {
    // Initialize
    _properties(Peer_Properties(enabledPointShare: UserService.pointShareEnabled));

    _isAuth = !UserService.hasUser.value;

    // Check for Connect Requirements
    await initNode(ConnectionRequest(
      type: ConnectionRequest_Type.CONNECT,
      contact: UserService.hasUser.value ? UserService.contact.value : null,
      device: DeviceService.device,
      location: DeviceService.location,
      apiKeys: _apiKeys,
    ));

    return this;
  }

  /// @ Initializes Node Instance
  Future<void> initNode(ConnectionRequest request) async {
    // Create Node
    _node = await SonrCore.initialize(request);
    _node.onStatus = _handleStatus;
    _node.onRefreshed = LobbyService.to.handleRefresh;
    _node.onInvited = SessionService.to.handleInvite;
    _node.onReplied = SessionService.to.handleReply;
    _node.onProgressed = SessionService.to.handleProgress;
    _node.onReceived = SessionService.to.handleReceived;
    _node.onTransmitted = SessionService.to.handleTransmitted;
    _node.onError = _handleError;
  }

  /// @ Connect to Service Method
  Future<void> connect() async {
    // Reconnect if Previously Auth
    if (_isAuth) {
      await initNode(ConnectionRequest(
        type: ConnectionRequest_Type.CONNECT,
        contact: UserService.hasUser.value ? UserService.contact.value : null,
        device: DeviceService.device,
        location: DeviceService.location,
        apiKeys: _apiKeys,
      ));

      // Revert Auth Value
      _isAuth = false;
    }

    // Connect Node
    _node.connect();

    // Update for Mobile
    if (DeviceService.isMobile) {
      _node.update(Request.newUpdatePosition(MobileService.position.value));
    }
  }

  // * ------------------- Methods ----------------------------
  /// @ Method to Pass Discovered BLE Peers
  // static void discover(List<BLEDevice> devices) {
  //   if (isReady) {
  //     // Call Method
  //     to._node.discover(devices.toDiscoverRequest());
  //   }
  // }

  static Future<SignResponse> sign(SignRequest request) async {
    return await to._node.sign(request);
  }

  static Future<StoreResponse> store(StoreRequest request) async {
    return await to._node.store(request);
  }

  static Future<VerifyResponse> verify(VerifyRequest request) async {
    return await to._node.verify(request);
  }

  /// @ Retreive URLLink Metadata
  static Future<URLLink> getURL(String url) async {
    var link = await SonrCore.getUrlLink(url);
    return link ?? URLLink(url: url);
  }

  /// @ Request Local Network Access on iOS
  static void requestLocalNetwork() async {
    to._node.requestLocalNetwork();
  }

  /// @ Send Position Update for Node
  static void update(Position position) {
    if (status.value.hasConnection) {
      to._node.update(Request.newUpdatePosition(position));
    }
  }

  static Future<String?> pickFile() async {
    if (status.value.hasConnection && DeviceService.isDesktop) {
      return await to._node.pickFile();
    }
    return null;
  }

  /// @ Sets Properties for Node
  static void setFlatMode(bool isFlatMode) async {
    if (status.value.hasConnection) {
      if (to._properties.value.isFlatMode != isFlatMode) {
        to._properties(Peer_Properties(enabledPointShare: UserService.pointShareEnabled, isFlatMode: isFlatMode));
        to._node.update(Request.newUpdateProperties(to._properties.value));
      }
    }
  }

  /// @ Sets Contact for Node
  static void setProfile(Contact contact) async {
    if (status.value.hasConnection) {
      to._node.update(Request.newUpdateContact(contact));
    }
  }

  /// @ Invite Peer with Built Request
  static Session? invite(InviteRequest request) {
    if (status.value.hasConnection) {
      // Send Invite
      to._node.invite(request);
      SessionService.setOutgoing(request);
      return SessionService.session;
    }
  }

  /// @ Respond-Peer Event
  static void respond(InviteResponse request) async {
    if (status.value.hasConnection) {
      to._node.respond(request);
    }
  }

  /// @ Invite Peer with Built Request
  static void sendFlat(Peer? peer) async {
    if (status.value.hasConnection) {
      to._node.invite(InviteRequest(to: peer!)..setContact(UserService.contact.value, isFlat: true));
    }
  }

  // * ------------------- Callbacks ----------------------------
  /// @ Handle Bootstrap Result
  void _handleStatus(StatusUpdate data) {
    // Check for Homescreen Controller
    if (data.value == Status.AVAILABLE) {
      DeviceService.playSound(type: UISoundType.Connected);

      // Handle Available
      if (DeviceService.isMobile) {
        _node.update(Request.newUpdatePosition(MobileService.position.value));
      }
    }
    // Set MultiAddr
    else if (data.value == Status.CONNECTED) {
      // BLEService.initMultiAddr(data.multiaddr);
    }

    // Update Status
    _status(data.value);

    // Logging
    Logger.info("Node(Callback) Status: " + data.value.toString());
  }

  /// @ An Error Has Occurred
  void _handleError(ErrorMessage data) async {
    if (data.severity != ErrorMessage_Severity.LOG) {
      Snack.error("", error: data);
    } else {
      // Reset Views
      if (SonrOverlay.isOpen) {
        SonrOverlay.closeAll();
      }

      // Reset Payload
      TransferService.resetPayload();

      // Reset Session
      SessionService.reset();
    }

    // Logging
    Logger.sError(data);
  }
}
