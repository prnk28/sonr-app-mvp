import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/env.dart';
import 'package:sonr_app/service/device/auth.dart';
// import 'package:sonr_app/service/device/ble.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart' as sonr;
import '../user/cards.dart';
import 'lobby.dart';
import '../user/user.dart';
export 'package:sonr_plugin/sonr_plugin.dart';

class SonrService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<SonrService>();
  static SonrService get to => Get.find<SonrService>();

  // @ Set Properties
  final _properties = Peer_Properties().obs;
  final _status = Rx<Status>(Status.IDLE);
  final RxSession _session = RxSession();

  // @ Static Accessors
  static Rx<Status> get status => to._status;
  static bool get isReady => to._status.value.isReady;
  static RxSession get session => to._session;
  static Completer<bool> hasInitialized = Completer<bool>();

  // @ Set References
  late Node _node;
  bool _initialized = false;
  bool _connected = false;

  /// @ Initialize Service Method
  Future<SonrService> init() async {
    // Initialize
    _properties(Peer_Properties(enabledPointShare: UserService.pointShareEnabled));

    // Check for Connect Requirements
    if (DeviceService.isReadyToConnect) {
      // Create Node
      _node = await SonrCore.initialize(_buildConnRequest());
      _node.onStatus = _handleStatus;
      _node.onRefreshed = Get.find<LobbyService>().handleRefresh;
      _node.onInvited = _handleInvited;
      _node.onReplied = _handleResponded;
      _node.onProgressed = _handleProgress;
      _node.onReceived = _handleReceived;
      _node.onTransmitted = _handleTransmitted;
      _node.onError = _handleError;
      _initialized = true;
      hasInitialized.complete(true);
      return this;
    } else {
      return this;
    }
  }

  /// @ Connect to Service Method
  Future<void> connect() async {
    // Check Initialized
    if (!_initialized) {
      // Create Node
      _node = await SonrCore.initialize(_buildConnRequest());
      _node.onStatus = _handleStatus;
      _node.onRefreshed = Get.find<LobbyService>().handleRefresh;
      _node.onInvited = _handleInvited;
      _node.onReplied = _handleResponded;
      _node.onProgressed = _handleProgress;
      _node.onReceived = _handleReceived;
      _node.onTransmitted = _handleTransmitted;
      _node.onError = _handleError;
      _initialized = true;
      hasInitialized.complete(true);
    }

    // Check not Connected
    if (!_connected) {
      // Connect Node
      _node.connect();

      // Update for Mobile
      if (DeviceService.isMobile) {
        _node.update(Request.newUpdatePosition(MobileService.position.value));
      }
      _connected = true;
    }
  }

  // /// @ Method to Pass Discovered BLE Peers
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
    if (isReady) {
      return await to._node.remoteCreateRequest(RemoteCreateRequest(file: file, fingerprint: fingerprint, sName: UserService.sName, words: words));
    }
  }

  /// @ Join an Existing Remote
  static Future<RemoteJoinResponse?> joinRemote(String link) async {
    if (isReady) {
      // Perform Routine
      var response = await to._node.remoteJoinRequest(RemoteJoinRequest(topic: link));
      return response;
    }
  }

  /// @ Send Position Update for Node
  static void update(Position position) {
    if (isReady) {
      to._node.update(Request.newUpdatePosition(MobileService.position.value));
    }
  }

  /// @ Sets Properties for Node
  static void setFlatMode(bool isFlatMode) async {
    if (isReady) {
      if (to._properties.value.isFlatMode != isFlatMode) {
        to._properties(Peer_Properties(enabledPointShare: UserService.pointShareEnabled, isFlatMode: isFlatMode));
        to._node.update(Request.newUpdateProperties(to._properties.value));
      }
    }
  }

  /// @ Sets Contact for Node
  static void setProfile(Contact contact) async {
    if (isReady) {
      to._node.update(Request.newUpdateContact(contact));
    }
  }

  /// @ Invite Peer with Built Request
  static RxSession? invite(AuthInvite request) {
    if (isReady) {
      // Send Invite
      to._node.invite(request);
      to._session.outgoing(request);
      return to._session;
    }
  }

  /// @ Respond-Peer Event
  static void respond(AuthReply request) async {
    if (isReady) {
      to._node.respond(request);
      to._session.onReply(request);
    }
  }

  /// @ Invite Peer with Built Request
  static void sendFlat(Peer? peer) async {
    if (isReady) {
      // Send Invite
      to._node.invite(AuthInvite(to: peer!)..setContact(UserService.contact.value, isFlat: true));
    }
  }

  // **************************
  // ******* Callbacks ********
  // **************************
  /// @ Handle Bootstrap Result
  void _handleStatus(StatusUpdate data) {
    // Check for Homescreen Controller
    if (data.value == Status.BOOTSTRAPPED) {
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

  /// @ Node Has Been Invited
  void _handleInvited(AuthInvite data) async {
    // Create Incoming Session
    to._session.incoming(data);

    // Handle Feedback
    DeviceService.playSound(type: UISoundType.Swipe);
    DeviceService.feedback();

    // Check for Flat
    if (data.isFlat && data.payload == Payload.CONTACT) {
      FlatMode.invite(data.contact);
    } else {
      SonrOverlay.invite(data);
    }

    // Logging
    Logger.info("Node(Callback) Invited: " + data.toString());
  }

  /// @ Node Has Been Accepted
  void _handleResponded(AuthReply reply) async {
    // Handle Contact Response
    if (reply.type == AuthReply_Type.FlatContact) {
      await HapticFeedback.heavyImpact();
      FlatMode.response(reply.data.contact);
    } else if (reply.type == AuthReply_Type.Contact) {
      await HapticFeedback.vibrate();
      SonrOverlay.reply(reply);
    }

    // For Cancel
    else if (reply.type == AuthReply_Type.Cancel) {
      await HapticFeedback.vibrate();
    } else {
      _session.onReply(reply);
    }

    // Logging
    Logger.info("Node(Callback) Responded: " + reply.toString());
  }

  /// @ Transfer Has Updated Progress
  void _handleProgress(double data) async {
    _session.onProgress(data);

    // Logging
    Logger.info("Node(Callback) Progress: " + data.toString());
  }

  /// @ Completes Transmission Sequence
  void _handleTransmitted(Transfer data) async {
    // Check for Callback
    _session.onComplete(data);
    TransferService.resetPayload();

    // Feedback
    DeviceService.playSound(type: UISoundType.Transmitted);
    await HapticFeedback.heavyImpact();

    // Logging Activity
    CardService.addActivityShared(payload: data.payload, file: data.file);

    // Logging
    Logger.info("Node(Callback) Transmitted: " + data.toString());
  }

  /// @ Mark as Received File
  Future<void> _handleReceived(Transfer data) async {
    // Check for Callback
    _session.onComplete(data);

    // Save Card to Gallery
    if (data.payload.isTransfer) {
      await DeviceService.saveTransfer(data.file);
    }

    // Update Database
    if (DeviceService.isMobile) {
      await CardService.addCard(data);
      await CardService.addActivityReceived(
        owner: data.owner,
        payload: data.payload,
        file: data.file,
      );
    }

    // Present Feedback
    await HapticFeedback.heavyImpact();
    DeviceService.playSound(type: UISoundType.Received);

    // Logging
    Logger.info("Node(Callback) Received: " + data.toString());
  }

  /// @ An Error Has Occurred
  void _handleError(ErrorMessage data) async {
    if (data.severity != ErrorMessage_Severity.LOG) {
      SonrSnack.error("", error: data);
    } else {
      // Reset Views
      if (SonrOverlay.isOpen) {
        SonrOverlay.closeAll();
      }

      // Reset Payload
      TransferService.resetPayload();

      // Reset Session
      _session.reset();
    }

    // Logging
    Logger.sError(data);
  }

  // ************************
  // ******* Helpers ********
  // ************************
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
        ));
  }
}
