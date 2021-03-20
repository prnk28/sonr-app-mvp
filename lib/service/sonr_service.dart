import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/modules/transfer/peer_controller.dart';
import 'package:sonr_core/sonr_core.dart';
import 'media_service.dart';
import 'sql_service.dart';
import 'user_service.dart';
export 'package:sonr_core/sonr_core.dart';

class SonrService extends GetxService with TransferQueue {
  // @ Set Properties
  final _groups = Map<String, Group>().obs;
  final _peers = Map<String, Peer>().obs;
  final _lobbySize = 0.obs;
  final _progress = 0.0.obs;
  static RxMap<String, Group> get groups => Get.find<SonrService>()._groups;
  static RxMap<String, Peer> get peers => Get.find<SonrService>()._peers;
  static RxInt get lobbySize => Get.find<SonrService>()._lobbySize;
  static SonrService get to => Get.find<SonrService>();
  static RxDouble get progress => Get.find<SonrService>()._progress;
  // @ Set References
  Node _node;

  // ^ Updates Node^ //
  SonrService() {
    Timer.periodic(500.milliseconds, (timer) {
      DeviceService.direction.value ?? _node.update(DeviceService.direction.value.headingForCameraMode, DeviceService.direction.value.heading);
    });
  }

  // ^ Initialize Service Method ^ //
  Future<SonrService> init() async {
    // Initialize
    var pos = await Get.find<DeviceService>().currentLocation();

    // Create Node
    _node = await SonrCore.initialize(pos.latitude, pos.longitude, UserService.username, UserService.current.contact);
    _node.onConnected = _handleConnected;
    _node.onReady = _handleReady;
    _node.onRefreshed = _handleRefresh;
    _node.onDirected = _handleDirect;
    _node.onInvited = _handleInvited;
    _node.onReplied = _handleResponded;
    _node.onProgressed = _handleProgress;
    _node.onReceived = _handleReceived;
    _node.onTransmitted = _handleTransmitted;
    _node.onError = _handleError;
    return this;
  }

  // ^ Connect to Service Method ^ //
  Future<void> connect() async {
    _node.connect();
  }

  // ^ Create a New Group ^
  static Future<String> createGroup() async {
    return await to._node.createGroup();
  }

  // ^ Join a New Group ^
  static joinGroup(String name) async {
    return await to._node.joinGroup(name);
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

  // ^ Set Payload for Media ^ //
  static queueMedia(MediaFile media) async {
    // - Check Connected -
    to.addToQueue(TransferQueueItem.media(media));
  }

  // ^ Set Payload for URL Link ^ //
  static queueUrl(String url) async {
    // - Check Connected -
    to.addToQueue(TransferQueueItem.url(url));
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
  // ^ Handle Connected to Bootstrap Nodes ^ //
  void _handleConnected(bool data) {}

  // ^ Handle Bootstrap Result ^ //
  void _handleReady(bool data) {
    // Update Status
    _node.update(DeviceService.direction.value.headingForCameraMode, DeviceService.direction.value.heading);

    // Check for Homescreen Controller
    if (Get.isRegistered<HomeController>() && data) {
      Get.find<HomeController>().readyTitleText(lobbySize.value);
    }
  }

  // ^ Handle Lobby Update ^ //
  void _handleRefresh(Lobby data) {
    _groups(data.groups);
    _peers(data.peers);
    _lobbySize(data.peers.length);
  }

  // ^ Node Has Been Directed from Other Device ^ //
  void _handleDirect(TransferCard data) async {
    HapticFeedback.heavyImpact();
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
