import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import '../user/cards.dart';
import 'lobby.dart';
import '../user/user.dart';
export 'package:sonr_plugin/sonr_plugin.dart';

extension StatusUtils on Status {
  bool get isNotConnected => this == Status.IDLE;
  bool get isConnecting => this == Status.IDLE || this == Status.CONNECTED;
  bool get isConnected => this != Status.IDLE;
  bool get isReady => this == Status.BOOTSTRAPPED;
}

class SonrService extends GetxService {
  // Accessors
  static bool get isInitialized => to._node != null;
  static bool get isRegistered => Get.isRegistered<SonrService>();
  static SonrService get to => Get.find<SonrService>();

  // @ Set Properties
  final _isReady = false.obs;
  final _progress = 0.0.obs;
  final _properties = Peer_Properties().obs;
  final _status = Rx<Status>(Status.IDLE);

  // @ Static Accessors
  static RxDouble get progress => to._progress;
  static Rx<Status> get status => to._status;

  // @ Set References
  Node? _node;
  var _received = Completer<TransferCard>();
  Completer<TransferCard> get received => _received;

  // Registered Callbacks
  Function(AuthInvite)? _remoteCallback;
  Function(TransferStatus)? _transferCallback;

  // ^ Updates Node^ //
  SonrService() {
    Timer.periodic(250.milliseconds, (timer) {
      if (DeviceService.isMobile && SonrRouting.areServicesRegistered && isRegistered) {
        // Publish Position
        if (to._isReady.value) {
          _node!.update(position: MobileService.position.value);
        }
      }
    });
  }

  // @ Register Handler for Remote Invite
  void registerRemoteInvite(Function(AuthInvite) invite) {
    _remoteCallback = invite;
  }

  // @ Register Handler for Transfer Updates
  void registerTransferUpdates(Function(TransferStatus) reply) {
    _transferCallback = reply;
  }

  // ^ Initialize Service Method ^ //
  Future<SonrService> init() async {
    // Initialize
    _properties(Peer_Properties(hasPointToShare: UserService.pointShareEnabled));

    // Check for Connect Requirements
    if (DeviceService.isReadyToConnect) {
      // Create Request
      var connReq = await RequestUtility.newRequest(
        geoLocation: DeviceService.isMobile ? await MobileService.currentLocation() : null,
        ipLocation: await DeviceService.findIPLocation(),
        contact: UserService.contact.value,
      );

      // Create Node
      _node = await SonrCore.initialize(connReq);
      _node!.onStatus = _handleStatus;
      _node!.onRefreshed = Get.find<LobbyService>().handleRefresh;
      _node!.onInvited = _handleInvited;
      _node!.onReplied = _handleResponded;
      _node!.onProgressed = _handleProgress;
      _node!.onReceived = _handleReceived;
      _node!.onTransmitted = _handleTransmitted;
      _node!.onError = _handleError;
      return this;
    } else {
      return this;
    }
  }

  // ^ Connect to Service Method ^ //
  Future<void> connect() async {
    if (_node == null) {
      // Create Request
      var connReq = await RequestUtility.newRequest(
        geoLocation: DeviceService.isMobile ? await MobileService.currentLocation() : null,
        ipLocation: await DeviceService.findIPLocation(),
        contact: UserService.contact.value,
      );

      // Create Node
      _node = await SonrCore.initialize(connReq);
      _node!.onStatus = _handleStatus;
      _node!.onRefreshed = Get.find<LobbyService>().handleRefresh;
      _node!.onInvited = _handleInvited;
      _node!.onReplied = _handleResponded;
      _node!.onProgressed = _handleProgress;
      _node!.onReceived = _handleReceived;
      _node!.onTransmitted = _handleTransmitted;
      _node!.onError = _handleError;

      // Connect Node
      _node!.connect();

      // Update for Mobile
      if (DeviceService.isMobile) {
        _node!.update(position: MobileService.position.value);
      }
    } else {
      if (_status.value == Status.IDLE) {
        // Connect Node
        _node!.connect();

        // Update for Mobile
        if (DeviceService.isMobile) {
          _node!.update(position: MobileService.position.value);
        }
      }
    }
  }

  // ^ Connect to Service Method ^ //
  Future<void> connectNewUser(Contact? contact) async {
    // Create Request
    var connReq = await RequestUtility.newRequest(
      geoLocation: DeviceService.isMobile ? await MobileService.currentLocation() : null,
      ipLocation: await DeviceService.findIPLocation(),
      contact: UserService.contact.value,
    );

    // Create Node
    _node = await SonrCore.initialize(connReq);
    _node!.onStatus = _handleStatus;
    _node!.onRefreshed = Get.find<LobbyService>().handleRefresh;
    _node!.onInvited = _handleInvited;
    _node!.onReplied = _handleResponded;
    _node!.onProgressed = _handleProgress;
    _node!.onReceived = _handleReceived;
    _node!.onTransmitted = _handleTransmitted;
    _node!.onError = _handleError;

    // Connect Node
    if (_status.value == Status.IDLE) {
      // Connect Node
      _node!.connect();

      // Update for Mobile
      if (DeviceService.isMobile) {
        _node!.update(position: MobileService.position.value);
      }
    }
  }

  // ^ Retreive Node Location Info ^ //
  static Future<Location?> locationInfo() async {
    if (to._node != null) {
      return await to._node!.location();
    }
  }

  // ^ Retreive URLLink Metadata ^ //
  static Future<URLLink> getURL(String url) async {
    if (to._node != null) {
      var link = await to._node!.getURL(url);
      return link ?? URLLink(link: url);
    }
    return URLLink(link: url);
  }

  // ^ Request Local Network Access on iOS ^
  static void requestLocalNetwork() async {
    to._node!.requestLocalNetwork();
  }

  // ^ Create a New Remote ^
  static Future<RemoteInfo?> createRemote() async {
    if (to._node != null) {
      return await to._node!.createRemote();
    }
  }

  // ^ Join an Existing Remote ^
  static Future<RemoteInfo> joinRemote(List<String> words) async {
    // Extract Data
    var display = "${words[0]} ${words[1]} ${words[2]}";
    var topic = "${words[0]}-${words[1]}-${words[2]}";

    // Perform Routine
    var remote = RemoteInfo(isJoin: true, topic: topic, display: display, words: words);

    if (to._node != null) {
      to._node!.joinRemote(remote);
    }
    return remote;
  }

  // ^ Leave a Remote Group ^
  static void leaveRemote(RemoteInfo info) async {
    // Perform Routine
    if (to._node != null) {
      to._node!.leaveRemote(info);
    }
  }

  // ^ Sets Properties for Node ^
  static void setFlatMode(bool isFlatMode) async {
    if (to._properties.value.isFlatMode != isFlatMode) {
      to._properties(Peer_Properties(hasPointToShare: UserService.pointShareEnabled, isFlatMode: isFlatMode));

      if (to._node != null) {
        to._node!.update(properties: to._properties.value);
      }
    }
  }

  // ^ Sets Contact for Node ^
  static void setProfile(Contact contact) async {
    if (to._node != null) {
      to._node!.update(contact: contact);
    }
  }

  // ^ Direct Message a Peer ^
  static void message(Peer peer, String content) {
    if (to._node != null) {
      to._node!.message(peer, content);
    }
  }

  // ^ Invite Peer with Built Request ^ //
  static void invite(InviteRequest request) async {
    // Send Invite
    if (to._node != null) {
      to._node!.invite(request);
    }
  }

  // ^ Respond-Peer Event ^
  static void respond(bool decision, {RemoteInfo? info}) async {
    if (to._node != null) {
      to._node!.respond(decision, info: info);
    }
  }

  // ^ Invite Peer with Built Request ^ //
  static void sendFlat(Peer? peer) async {
    // Send Invite
    InviteRequest request = InviteRequest(payload: Payload.FLAT_CONTACT, to: peer, isRemote: false, contact: UserService.contact.value);

    if (to._node != null) {
      to._node!.invite(request);
    }
  }

  // ^ Async Function notifies transfer complete ^ //
  static Future<TransferCard> completed() async {
    return to.received.future;
  }

  // **************************
  // ******* Callbacks ********
  // **************************
  // ^ Handle Bootstrap Result ^ //
  void _handleStatus(StatusUpdate data) {
    print(data.value.toString());
    // Check for Homescreen Controller
    if (data.value == Status.BOOTSTRAPPED) {
      // Update Status
      _isReady(true);
      _status(data.value);
      DeviceService.playSound(type: UISoundType.Connected);

      // Handle Available
      if (DeviceService.isMobile) {
        _node!.update(position: MobileService.position.value);
      }
    }
  }

  // ^ Node Has Been Invited ^ //
  void _handleInvited(AuthInvite data) async {
    // Check for Overlay
    if (data.hasRemote() && _remoteCallback != null) {
      _remoteCallback!(data);
    }

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

  // ^ Node Has Been Accepted ^ //
  void _handleResponded(AuthReply data) async {
    // Handle Contact Response
    if (data.type == AuthReply_Type.FlatContact) {
      await HapticFeedback.heavyImpact();
      FlatMode.response(data.card.contact);
    } else if (data.type == AuthReply_Type.Contact) {
      await HapticFeedback.vibrate();
      SonrOverlay.reply(data);
    }

    // For Cancel
    else if (data.type == AuthReply_Type.Cancel) {
      await HapticFeedback.vibrate();
    } else {
      // Check for Callback
      if (_transferCallback != null) {
        _transferCallback!(TransferStatusUtil.statusFromReply(data));
      }
    }
  }

  // ^ Transfer Has Updated Progress ^ //
  void _handleProgress(double data) async {
    _progress(data);
  }

  // ^ Completes Transmission Sequence ^
  void _handleTransmitted(TransferCard data) async {
    print(data.toString());
    // Check for Callback
    if (_transferCallback != null) {
      _transferCallback!(TransferStatus.Completed);
      _transferCallback = null;
    }

    // Feedback
    DeviceService.playSound(type: UISoundType.Transmitted);
    await HapticFeedback.heavyImpact();

    // Log Activity
    CardService.sharedCard(data);
  }

  // ^ Mark as Received File ^ //
  Future<void> _handleReceived(TransferCard data) async {
    print(data.toString());
    // Save Card to Gallery
    await CardService.addCard(data);
    to.received.complete(data);

    // Close any Existing Overlays
    if (SonrOverlay.isOpen) {
      SonrOverlay.closeAll();
    }

    // Present Feedback
    await HapticFeedback.heavyImpact();
    DeviceService.playSound(type: UISoundType.Received);
  }

  // ^ An Error Has Occurred ^ //
  void _handleError(ErrorMessage data) async {
    print(data.toString());
    if (data.severity != ErrorMessage_Severity.LOG) {
      SonrSnack.error("", error: data);
    }
  }
}

// ^ Transfer Status Enum ^ //
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
