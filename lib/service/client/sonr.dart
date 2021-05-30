import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/env.dart';
import 'package:sonr_app/service/device/auth.dart';
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
  // final _isReady = false.obs;
  final _progress = 0.0.obs;
  final _properties = Peer_Properties().obs;
  final _status = Rx<Status>(Status.IDLE);

  // @ Static Accessors
  static RxDouble get progress => to._progress;
  static Rx<Status> get status => to._status;

  // @ Set References
  late Node _node;
  var _received = Completer<Transfer>();
  Completer<Transfer> get received => _received;
  bool _initialized = false;

  // Registered Callbacks
  Function(TransferStatus)? _transferCallback;

  /// @ Updates Node^ //
  SonrService() {
    Timer.periodic(250.milliseconds, (timer) {
      if (DeviceService.isMobile && SonrRouting.areServicesRegistered && isRegistered) {
        // Publish Position
        if (to._status.value.isBootstrapped) {
          _node.update(Request.newUpdatePosition(MobileService.position.value));
        }
      }
    });
  }

  // @ Register Handler for Transfer Updates
  void registerTransferUpdates(Function(TransferStatus) reply) {
    _transferCallback = reply;
  }

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
    }

    // Check not Connected
    if (_status.value.isNotConnected) {
      // Connect Node
      _node.connect();

      // Update for Mobile
      if (DeviceService.isMobile) {
        _node.update(Request.newUpdatePosition(MobileService.position.value));
      }
    }
  }

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
    return await to._node.remoteCreateRequest(RemoteCreateRequest(file: file, fingerprint: fingerprint, sName: UserService.sName, words: words));
  }

  /// @ Join an Existing Remote
  static Future<RemoteJoinResponse?> joinRemote(String link) async {
    // Perform Routine
    var response = await to._node.remoteJoinRequest(RemoteJoinRequest(topic: link));
    return response;
  }

  /// @ Sets Properties for Node
  static void setFlatMode(bool isFlatMode) async {
    if (to._properties.value.isFlatMode != isFlatMode) {
      to._properties(Peer_Properties(enabledPointShare: UserService.pointShareEnabled, isFlatMode: isFlatMode));
      to._node.update(Request.newUpdateProperties(to._properties.value));
    }
  }

  /// @ Sets Contact for Node
  static void setProfile(Contact contact) async {
    to._node.update(Request.newUpdateContact(contact));
  }

  /// @ Invite Peer with Built Request
  static void invite(AuthInvite request) async {
    // Send Invite
    to._node.invite(request);
  }

  /// @ Respond-Peer Event
  static void respond(AuthReply request) async {
    to._node.respond(request);
  }

  /// @ Invite Peer with Built Request
  static void sendFlat(Peer? peer) async {
    // Send Invite
    to._node.invite(AuthInvite(to: peer!)..setContact(UserService.contact.value, isFlat: true));
  }

  /// @ Async Function notifies transfer complete
  static Future<Transfer> completed() async {
    return to.received.future;
  }

  // **************************
  // ******* Callbacks ********
  // **************************
  /// @ Handle Bootstrap Result
  void _handleStatus(StatusUpdate data) {
    print(data.value.toString());
    // Check for Homescreen Controller
    if (data.value == Status.BOOTSTRAPPED) {
      // Update Status
      _status(data.value);
      DeviceService.playSound(type: UISoundType.Connected);

      // Handle Available
      if (DeviceService.isMobile) {
        _node.update(Request.newUpdatePosition(MobileService.position.value));
      }
    }
  }

  /// @ Node Has Been Invited
  void _handleInvited(AuthInvite data) async {
    // Handle Feedback
    DeviceService.playSound(type: UISoundType.Swipe);
    DeviceService.feedback();

    // Check for Flat
    if (data.isFlat && data.payload == Payload.CONTACT) {
      FlatMode.invite(data.contact);
    } else {
      SonrOverlay.invite(data);
    }
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
      // Check for Callback
      if (_transferCallback != null) {
        _transferCallback!(TransferStatusUtil.statusFromReply(reply));
      }
    }
  }

  /// @ Transfer Has Updated Progress
  void _handleProgress(double data) async {
    print(data);
    _progress(data);
  }

  /// @ Completes Transmission Sequence
  void _handleTransmitted(Transfer data) async {
    // Check for Callback
    if (_transferCallback != null) {
      _transferCallback!(TransferStatus.Completed);
      _transferCallback = null;
    }

    // Feedback
    DeviceService.playSound(type: UISoundType.Transmitted);
    await HapticFeedback.heavyImpact();

    // Log Activity
    CardService.addActivityShared(payload: data.payload, file: data.file);
  }

  /// @ Mark as Received File
  Future<void> _handleReceived(Transfer data) async {
    // Save Card to Gallery
    if (DeviceService.isMobile) {
      await CardService.addCard(data);
    } else {
      if (data.payload.isTransfer) {
        await DeviceService.saveTransfer(data.file);
      }
    }

    to.received.complete(data);

    // Close any Existing Overlays
    if (SonrOverlay.isOpen) {
      SonrOverlay.closeAll();
    }

    // Present Feedback
    await HapticFeedback.heavyImpact();
    DeviceService.playSound(type: UISoundType.Received);
  }

  /// @ An Error Has Occurred
  void _handleError(ErrorMessage data) async {
    print(data.toString());
    if (data.severity != ErrorMessage_Severity.LOG) {
      SonrSnack.error("", error: data);
    }
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

/// @ Transfer Status Enum
enum TransferStatus { Accepted, Denied, Completed }

extension TransferStatusUtil on TransferStatus {
  static TransferStatus statusFromReply(AuthReply reply) {
    if (reply.decision) {
      return TransferStatus.Accepted;
    } else {
      return TransferStatus.Denied;
    }
  }
}
