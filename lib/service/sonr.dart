import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/modules/transfer/peer_controller.dart';
import 'package:sonr_core/sonr_core.dart';
import 'media.dart';
import 'sql.dart';
import 'user.dart';
export 'package:sonr_core/sonr_core.dart';

class SonrService extends GetxService with TransferQueue {
  // @ Set Properties
  final _isReady = false.obs;
  final _peers = Map<String, Peer>().obs;
  final _lobbySize = 0.obs;
  final _progress = 0.0.obs;
  final _status = Rx<Status>();
  static RxBool get isReady => Get.find<SonrService>()._isReady;
  static RxMap<String, Peer> get peers => Get.find<SonrService>()._peers;
  static RxInt get lobbySize => Get.find<SonrService>()._lobbySize;
  static SonrService get to => Get.find<SonrService>();
  static RxDouble get progress => Get.find<SonrService>()._progress;
  static Rx<Status> get status => Get.find<SonrService>()._status;

  // @ Set References
  Node _node;

  // ^ Updates Node^ //
  SonrService() {
    Timer.periodic(500.milliseconds, (timer) {
      if (DeviceService.isMobile) {
        DeviceService.direction.value ?? _node.update(DeviceService.direction.value.headingForCameraMode, DeviceService.direction.value.heading);
      }
    });
  }

  // ^ Initialize Service Method ^ //
  Future<SonrService> init() async {
    // Initialize
    var pos = await Get.find<DeviceService>().currentLocation();

    // Create Node
    _node = await SonrCore.initialize(pos.latitude, pos.longitude, UserService.username, UserService.current.contact);
    _node.onStatus = _handleStatus;
    _node.onRefreshed = _handleRefresh;
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
    if (contact != null) {
      await _node.setContact(contact);
    }
    _node.connect();
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

  // ^ Sets Contact for Node ^
  static void setContact(Contact contact) async {
    // - Check Connected -
    await to._node.setContact(contact);
    //SonrSnack.error("Not Connected to the Sonr Network");
  }

  // ^ Set Payload for Contact ^ //
  static queueContact() async {
    // - Check Connected -
    to.addToQueue(TransferQueueItem.contact());
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
  static invite(PeerController c) async {
    // Set Peer Controller
    to.currentInvited(c);

    // File Payload
    if (to.payload == Payload.MEDIA) {
      assert(to.currentTransfer.media != null);
      await to._node.inviteFile(c.peer, to.currentTransfer.media);
    }

    // Contact Payload
    else if (to.payload == Payload.CONTACT) {
      await to._node.inviteContact(c.peer);
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
  static inviteFromList(Peer p) async {
    // Set Peer Controller
    to.currentInvitedFromList(p);

    // File Payload
    if (to.payload == Payload.MEDIA) {
      assert(to.currentTransfer.media != null);
      await to._node.inviteFile(p, to.currentTransfer.media);
    }

    // Contact Payload
    else if (to.payload == Payload.CONTACT) {
      await to._node.inviteContact(p);
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
      _node.update(DeviceService.direction.value.headingForCameraMode, DeviceService.direction.value.heading);
      Get.find<HomeController>().readyTitleText(lobbySize.value);
    }
  }

  // ^ Handle Lobby Update ^ //
  void _handleRefresh(Lobby data) {
    _peers(data.peers);
    _lobbySize(data.peers.length);
  }

  // ^ Node Has Been Invited ^ //
  void _handleInvited(AuthInvite data) async {
    if (SonrOverlay.isNotOpen) {
      HapticFeedback.heavyImpact();
      SonrOverlay.invite(data);
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleResponded(AuthReply data) async {
    // Check if Sent Back Contact
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
