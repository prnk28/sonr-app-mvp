import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/modules/transfer/peer_controller.dart';
import 'package:sonr_core/sonr_core.dart';
import 'lobby.dart';
import 'media.dart';
import 'sql.dart';
import 'user.dart';
export 'package:sonr_core/sonr_core.dart';

class SonrService extends GetxService with TransferQueue {
  // @ Set Properties
  final _isReady = false.obs;
  final _progress = 0.0.obs;
  final _properties = Peer_Properties().obs;
  final _status = Rx<Status>();

  // @ Static Accessors
  static SonrService get to => Get.find<SonrService>();
  static RxBool get isReady => Get.find<SonrService>()._isReady;
  static RxDouble get progress => Get.find<SonrService>()._progress;
  static Rx<Status> get status => Get.find<SonrService>()._status;

  // @ Set References
  Node _node;

  // ^ Updates Node^ //
  SonrService() {
    Timer.periodic(200.milliseconds, (timer) {
      if (DeviceService.isMobile) {
        DeviceService.direction.value ??
            _node.update(direction: Tuple(DeviceService.direction.value.headingForCameraMode, DeviceService.direction.value.heading));
      }
    });
  }

  // ^ Initialize Service Method ^ //
  Future<SonrService> init() async {
    // Initialize
    var pos = await Get.find<DeviceService>().currentLocation();
    _properties(Peer_Properties(hasPointToShare: UserService.hasPointToShare.value));

    // Create Node
    _node = await SonrCore.initialize(pos.latitude, pos.longitude, UserService.username, UserService.current.contact);
    _node.onStatus = _handleStatus;
    _node.onRefreshed = Get.find<LobbyService>().handleRefresh;
    _node.onInvited = _handleInvited;
    _node.onReplied = _handleResponded;
    _node.onProgressed = _handleProgress;
    _node.onReceived = _handleReceived;
    _node.onTransmitted = _handleTransmitted;
    _node.onError = _handleError;
    return this;
  }

  // ^ Connect to Service Method ^ //
  Future<void> connect({Contact contact}) async {
    _node.connect();
    if (contact != null) {
      _node.update(direction: Tuple(DeviceService.direction.value.headingForCameraMode, DeviceService.direction.value.heading));
    }
  }

  // ^ Join a New Group ^
  static Future<RemoteInfo> createRemote() async {
    var data = await to._node.createRemote();
    return data;
  }

  // ^ Join a New Group ^
  static joinRemote(List<String> words) async {
    // Extract Data
    var display = "${words[0]} ${words[1]} ${words[2]}";
    var topic = "${words[0]}-${words[1]}-${words[2]}";

    // Perform Routine
    await to._node.joinRemote(RemoteInfo(isJoin: true, topic: topic, display: display, words: words));
  }

  // ^ Sets Properties for Node ^
  static void setFlatMode(bool isFlatMode) async {
    if (to._properties.value.isFlatMode != isFlatMode) {
      to._properties(Peer_Properties(hasPointToShare: UserService.hasPointToShare.value, isFlatMode: isFlatMode));
      await to._node.update(properties: to._properties.value);
    }
  }

  // ^ Sets Contact for Node ^
  static void setProfile(Contact contact) async {
    await to._node.update(contact: contact);
  }

  // ^ Set Payload for Contact ^ //
  static queueContact({bool isFlat = false}) async {
    // - Check Connected -
    to.addToQueue(TransferQueueItem.contact(isFlat: isFlat));
  }

  // ^ Set Payload for URL Link ^ //
  static queueMedia(MediaFile media) async {
    // - Check Connected -
    to.addToQueue(TransferQueueItem.media(media));
  }

  // ^ Set Payload for URL Link ^ //
  static queueUrl(String url) async {
    // - Check Connected -
    to.addToQueue(TransferQueueItem.url(url));
  }

  // ^ Direct Message a Peer ^
  static message(Peer peer, String content) {
    to._node.message(peer, content);
  }

  // ^ Invite-Peer Event ^
  static inviteWithController(PeerController c) async {
    // Set Peer Controller
    to.currentInvited(c);

    // File Payload
    if (to.payload == Payload.MEDIA) {
      assert(to.currentTransfer.media != null);
      await to._node.inviteFile(c.peer, to.currentTransfer.media);
    }

    // Contact Payload
    else if (to.payload == Payload.CONTACT) {
      await to._node.inviteContact(c.peer, isFlat: to.currentTransfer.isFlat);
    }

    // Link Payload
    else if (to.payload == Payload.URL) {
      assert(to.currentTransfer.url != null);
      await to._node.inviteLink(c.peer, to.currentTransfer.url);
    }

    // No Payload
    else {
      SonrSnack.error("No media, contact, or link provided");
    }
  }

  // ^ Invite-Peer Event ^
  static inviteWithPeer(Peer p) async {
    // Set Peer Controller
    to.currentInvitedFromList(p);

    // File Payload
    if (to.payload == Payload.MEDIA) {
      assert(to.currentTransfer.media != null);
      await to._node.inviteFile(p, to.currentTransfer.media);
    }

    // Contact Payload
    else if (to.payload == Payload.CONTACT) {
      await to._node.inviteContact(p, isFlat: to.currentTransfer.isFlat);
    }

    // Link Payload
    else if (to.payload == Payload.URL) {
      assert(to.currentTransfer.url != null);
      await to._node.inviteLink(p, to.currentTransfer.url);
    }

    // No Payload
    else {
      SonrSnack.error("No media, contact, or link provided");
    }
  }

  // ^ Respond-Peer Event ^
  static respond(bool decision) async {
    await to._node.respond(decision);
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
    if (Get.isRegistered<HomeController>() && data.value == Status.AVAILABLE) {
      // Update Status
      _isReady(true);
      _status(data.value);

      // Handle Available
      _node.update(direction: Tuple(DeviceService.direction.value.headingForCameraMode, DeviceService.direction.value.heading));
    }
  }

  // ^ Node Has Been Invited ^ //
  void _handleInvited(AuthInvite data) async {
    if (SonrOverlay.isNotOpen) {
      HapticFeedback.heavyImpact();
      // Check for Flat
      if(data.isFlat && data.payload == Payload.CONTACT){

      }
      SonrOverlay.invite(data);
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleResponded(AuthReply data) async {
    // Check if Sent Back Contact
    print(data.toString());

    if (data.type == AuthReply_Type.FlatContact) {
      HapticFeedback.heavyImpact();
      FlatMode.incoming(data.card);
    }

    if (data.type == AuthReply_Type.Contact) {
      HapticFeedback.vibrate();
      SonrOverlay.reply(data);
    }
    // For Cancel
    else if (data.type == AuthReply_Type.Cancel) {
      HapticFeedback.vibrate();
      currentDecided(false);
    } else {
      // For File
      currentDecided(data.decision);
    }
  }

  // ^ Transfer Has Updated Progress ^ //
  void _handleProgress(double data) async {
    _progress(data);
  }

  // ^ Resets Peer Info Event ^
  void _handleTransmitted(Peer data) async {
    currentCompleted();
  }

  // ^ Mark as Received File ^ //
  Future<void> _handleReceived(TransferCard data) async {
    HapticFeedback.heavyImpact();

    // Save Card to Gallery
    MediaService.saveTransfer(data).then((value) {
      data.hasExported = value;
      if (!received.isCompleted) {
        received.complete(data);
      }
      Get.find<SQLService>().storeCard(data);
    });
  }

  // ^ An Error Has Occurred ^ //
  void _handleError(ErrorMessage data) async {
    print(data.method + "() - " + data.message);
    SonrSnack.error("Internal Error Occurred");
  }
}
