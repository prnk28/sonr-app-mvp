import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/env.dart';
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
  final _isReady = false.obs;
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

  // Registered Callbacks
  Function(TransferStatus)? _transferCallback;

  /// @ Updates Node^ //
  SonrService() {
    Timer.periodic(250.milliseconds, (timer) {
      if (DeviceService.isMobile && SonrRouting.areServicesRegistered && isRegistered) {
        // Publish Position
        if (to._isReady.value) {
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
      return this;
    } else {
      return this;
    }
  }

  /// @ Connect to Service Method
  Future<void> connect() async {
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

    // Connect Node
    _node.connect();

    // Update for Mobile
    if (DeviceService.isMobile) {
      _node.update(Request.newUpdatePosition(MobileService.position.value));
    }

    await putUser();
  }

  /// @ Get User from Storage
  static Future<User?> getUser({String? id}) async {
    // Provided
    if (id != null) {
      var data = await SonrCore.userStorjRequest(StorjRequest(storjApiKey: Env.storj_key, storjRootPassword: Env.storj_root_password, userID: id));
      if (data != null) {
        return data.user;
      } else {
        print("User data doesnt exist");
        return null;
      }
    }

    // Reference
    var data = await SonrCore.userStorjRequest(
        StorjRequest(storjApiKey: Env.storj_key, storjRootPassword: Env.storj_root_password, userID: UserService.user.value.id));
    if (data != null) {
      print(data.toString());
      return data.user;
    } else {
      print("User data doesnt exist");
      return null;
    }
  }

  /// @ Place User into Storage
  static Future<bool> putUser({User? user}) async {
    // Provided
    if (user != null) {
      var resp = await SonrCore.userStorjRequest(StorjRequest(storjApiKey: Env.storj_key, storjRootPassword: Env.storj_root_password, user: user));
      print("User Put Status: $resp");
      return resp!.success;
    }

    // Reference
    var resp = await SonrCore.userStorjRequest(
        StorjRequest(storjApiKey: Env.storj_key, storjRootPassword: Env.storj_root_password, user: UserService.user.value));
    print("User Put Status: $resp");
    return resp!.success;
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
  static Future<RemoteResponse?> createRemote() async {
    return await to._node.remoteRequest(RemoteRequest(createData: RemoteRequest_Create()));
  }

  /// @ Join an Existing Remote
  static Future<RemoteResponse> joinRemote(List<String> words) async {
    // Extract Data
    var display = "${words[0]} ${words[1]} ${words[2]}";
    var topic = "${words[0]}-${words[1]}-${words[2]}";

    // Perform Routine
    var remote = RemoteResponse(isJoin: true, topic: topic, display: display, words: words);
    await to._node.remoteRequest(RemoteRequest(joinData: RemoteRequest_Join(words: words)));
    return remote;
  }

  /// @ Leave a Remote Group
  static void leaveRemote(RemoteResponse info) async {
    await to._node.remoteRequest(RemoteRequest(leaveData: RemoteRequest_Leave(isJoin: info.isJoin, topic: info.topic)));
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
      _isReady(true);
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
        crypto: UserService.user.value.crypto,
        device: DeviceService.device,
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
