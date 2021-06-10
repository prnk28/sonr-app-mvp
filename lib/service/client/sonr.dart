import 'dart:async';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/env.dart';
import 'package:sonr_app/service/device/auth.dart';
// import 'package:sonr_app/service/device/ble.dart';
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
  bool _initialized = false;

  // * ------------------- Constructers ----------------------------
  /// @ Initialize Service Method
  Future<SonrService> init() async {
    // Initialize
    _properties(Peer_Properties(enabledPointShare: UserService.pointShareEnabled));

    // Check for Connect Requirements
    if (DeviceService.isReadyToConnect) {
      await initNode();
      return this;
    } else {
      return this;
    }
  }

  /// @ Initializes Node Instance
  Future<void> initNode() async {
    // Create Node
    _node = await SonrCore.initialize(_buildConnRequest());
    _node.onStatus = _handleStatus;
    _node.onRefreshed = LobbyService.to.handleRefresh;
    _node.onInvited = SessionService.to.handleInvite;
    _node.onReplied = SessionService.to.handleReply;
    _node.onProgressed = SessionService.to.handleProgress;
    _node.onReceived = SessionService.to.handleReceived;
    _node.onTransmitted = SessionService.to.handleTransmitted;
    _node.onError = _handleError;
    _initialized = true;
  }

  /// @ Connect to Service Method
  Future<void> connect() async {
    // Check Initialized
    if (!_initialized) {
      await initNode();
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

  /// @ Retreive URLLink Metadata
  static Future<URLLink> getURL(String url) async {
    var link = await to._node.getURL(url);
    return link ?? URLLink(url: url);
  }

  /// @ Request Local Network Access on iOS
  static void requestLocalNetwork() async {
    to._node.requestLocalNetwork();
  }

  /// @ Create a New Remote
  static Future<RemoteCreateResponse?> createRemote({
    required SonrFile file,
    required String fingerprint,
    required String words,
  }) async {
    if (status.value.hasConnection) {
      return await to._node.remoteCreateRequest(RemoteCreateRequest(file: file, fingerprint: fingerprint, sName: UserService.sName, words: words));
    }
  }

  /// @ Join an Existing Remote
  static Future<RemoteJoinResponse?> joinRemote(String link) async {
    if (status.value.hasConnection) {
      // Perform Routine
      var response = await to._node.remoteJoinRequest(RemoteJoinRequest(topic: link));
      return response;
    }
  }

  /// @ Send Position Update for Node
  static void update(Position position) {
    if (status.value.hasConnection) {
      to._node.update(Request.newUpdatePosition(position));
    }
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
  static Session? invite(AuthInvite request) {
    if (status.value.hasConnection) {
      // Send Invite
      to._node.invite(request);
      SessionService.setOutgoing(request);
      return SessionService.session;
    }
  }

  /// @ Respond-Peer Event
  static void respond(AuthReply request) async {
    if (status.value.hasConnection) {
      to._node.respond(request);
    }
  }

  /// @ Invite Peer with Built Request
  static void sendFlat(Peer? peer) async {
    if (status.value.hasConnection) {
      to._node.invite(AuthInvite(to: peer!)..setContact(UserService.contact.value, isFlat: true));
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

  // * ------------------- Helpers ----------------------------
  // Builds Connection Request
  ConnectionRequest _buildConnRequest() {
    return ConnectionRequest(
        contact: UserService.contact.value,
        crypto: AuthService.isRegistered ? AuthService.userCrypto : null,
        device: DeviceService.device,
        devices: UserService.user.devices,
        settings: UserService.user.settings,
        location: DeviceService.location,
        clientKeys: ConnectionRequest_ClientKeys(
            hsKey: Env.hs_key,
            hsSecret: Env.hs_secret,
            ipKey: Env.ip_key,
            rapidApiHost: Env.rapid_host,
            rapidApiKey: Env.rapid_key,
            hubKey: Env.hub_key,
            hubSecret: Env.hub_secret));
  }
}
