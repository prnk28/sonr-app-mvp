import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/modules/transfer/peer_controller.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/widgets/overlay.dart';
import 'package:sonr_core/sonr_core.dart';
import 'media_service.dart';
import 'sql_service.dart';
import 'user_service.dart';
export 'package:sonr_core/sonr_core.dart';

class SonrService extends GetxService with TransferQueue {
  // @ Set Properties
  final _connected = false.obs;
  final _peers = Map<String, Peer>().obs;
  final _lobbySize = 0.obs;
  static RxMap<String, Peer> get peers => Get.find<SonrService>()._peers;
  static RxInt get lobbySize => Get.find<SonrService>()._lobbySize;
  static RxBool get connected => Get.find<SonrService>()._connected;

  // @ Set References
  Node _node;

  // ^ Updates Node^ //
  SonrService() {
    DeviceService.direction.listen((dir) {
      if (_connected.value) {
        // Update Direction
        _node.update(dir.headingForCameraMode);
      }
    });
  }

  // ^ Initialize Service Method ^ //
  Future<SonrService> init() async {
    // Get Data
    var pos = DeviceService.position.value;
    var user = UserService.current;

    // Validate Data
    if (pos != null) {
      // Create Worker
      _node = await SonrCore.initialize(
          pos.latitude,
          pos.longitude,
          user.hasProfile() ? user.profile.username : "@${user.contact.firstName.substring(0, 1)}${user.contact.lastName.substring(1)}",
          user.contact);

      // Assign Node Callbacks
      _node.assignCallbacks(
          connected: _handleConnected,
          refreshed: _handleRefresh,
          directed: _handleDirect,
          invited: _handleInvite,
          replied: _handleResponded,
          progressed: _handleProgress,
          received: _handleReceived,
          transmitted: _handleTransmitted,
          error: _handleSonrError);

      _connected(true);
      return this;
    }
    _connected(false);
    return this;
  }

  // ***********************
  // ******* Events ********
  // ***********************
  // ^ Connect to Sonr Network ^
  static connect() async {
    // Get Data
    var pos = DeviceService.position.value;
    var user = UserService.current;
    var contr = Get.find<SonrService>();

    // Validate Data
    if (pos != null && !user.hasField(1)) {
      // Create Worker
      contr._node = await SonrCore.initialize(pos.latitude, pos.longitude, "", user.contact);

      // Assign Node Callbacks
      contr._node.assignCallbacks(
          connected: contr._handleConnected,
          refreshed: contr._handleRefresh,
          directed: contr._handleDirect,
          invited: contr._handleInvite,
          replied: contr._handleResponded,
          progressed: contr._handleProgress,
          received: contr._handleReceived,
          transmitted: contr._handleTransmitted,
          error: contr._handleSonrError);

      // Set Connected
      contr._connected(true);
    } else {
      contr._connected(false);
    }
  }

  // ^ Sets Contact for Node ^
  static void setContact(Contact contact) async {
    // Get Data
    var snr = Get.find<SonrService>();
    // - Check Connected -
    if (snr._connected.value) {
      await snr._node.setContact(contact);
    } else {
      SonrSnack.error("Not Connected to the Sonr Network");
    }
  }

  // ^ Set Payload for Contact ^ //
  static queueContact() async {
    // Get Data
    var snr = Get.find<SonrService>();

    // - Check Connected -
    if (snr._connected.value) {
      // Set Payload Type
      snr.addToQueue(TransferQueueItem.contact());
    } else {
      SonrSnack.error("Not Connected to the Sonr Network");
    }
  }

  // ^ Set Payload for Media ^ //
  static queueMedia(String path, {bool hasThumbnail = false, int duration = -1, String thumbPath = "", Uint8List thumbnailData}) async {
    // Get Data
    var snr = Get.find<SonrService>();
    // - Check Connected -
    if (snr._connected.value) {
      // Set Payload Type
      snr.addToQueue(TransferQueueItem.media(path, hasThumbnail, duration, thumbPath, thumbnailData));
    } else {
      SonrSnack.error("Not Connected to the Sonr Network");
    }
  }

  // ^ Set Payload for URL Link ^ //
  static queueUrl(String url) async {
    // Get Data
    var snr = Get.find<SonrService>();

    // - Check Connected -
    if (snr._connected.value) {
      // Set Payload Type
      snr.addToQueue(TransferQueueItem.url(url));
    } else {
      SonrSnack.error("Not Connected to the Sonr Network");
    }
  }

  // ^ Invite-Peer Event ^
  static invite(PeerController c) async {
    // Get Data
    var snr = Get.find<SonrService>();

    if (snr._connected.value) {
      // Set Peer Controller
      snr.currentInvited(c);

      // File Payload
      if (snr.payload == Payload.MEDIA) {
        assert(snr.currentTransfer.media != null);
        await snr._node.inviteFile(c.peer, snr.currentTransfer.media);
      }

      // Contact Payload
      else if (snr.payload == Payload.CONTACT) {
        await snr._node.inviteContact(c.peer);
      }

      // Link Payload
      else if (snr.payload == Payload.URL) {
        assert(snr.currentTransfer.url != null);
        await snr._node.inviteLink(c.peer, snr.currentTransfer.url);
      }

      // No Payload
      else {
        SonrSnack.error("No media, contact, or link provided");
      }
    } else {
      SonrSnack.error("Not Connected to the Sonr Network");
    }
  }

  // ^ Respond-Peer Event ^
  static respond(bool decision) async {
    // Get Data
    var snr = Get.find<SonrService>();

    if (snr._connected.value) {
      // Send Response
      await snr._node.respond(decision);
    } else {
      SonrSnack.error("Not Connected to the Sonr Network");
    }
  }

  // ^ Async Function notifies transfer complete ^ //
  static Future<TransferCard> completed() async {
    // Get Data
    var snr = Get.find<SonrService>();
    if (!snr._connected.value) {
      SonrSnack.error("Not Connected to the Sonr Network");
      snr.received.completeError("Error Transferring File");
    }
    return snr.received.future;
  }

  // **************************
  // ******* Callbacks ********
  // **************************
  // ^ Handle Connected to Bootstrap Nodes ^ //
  void _handleConnected() {
    // Update Direction
    _node.update(DeviceService.direction.value.headingForCameraMode);
  }

  // ^ Handle Lobby Update ^ //
  void _handleRefresh(dynamic data) {
    if (data is Lobby) {
      // Update Lobby Data
      _peers(data.peers);
      _lobbySize(data.peers.length);
    }
  }

  // ^ Node Has Been Directed from Other Device ^ //
  void _handleDirect(dynamic data) async {
    // Check Type
    if (data is TransferCard) {
      HapticFeedback.heavyImpact();
    }
  }

  // ^ Node Has Been Invited ^ //
  void _handleInvite(dynamic data) async {
    // Check Type
    if (data is AuthInvite) {
      if (!Get.isDialogOpen) {
        HapticFeedback.heavyImpact();
        SonrOverlay.invite(data);
      }
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleResponded(dynamic data) async {
    if (data is AuthReply) {
      // Check if Sent Back Contact
      if (data.payload == Payload.CONTACT) {
        HapticFeedback.vibrate();
        SonrOverlay.reply(data);
      } else {
        // For File
        currentDecided(data.decision);
      }
    }
  }

  // ^ Transfer Has Updated Progress ^ //
  void _handleProgress(dynamic data) async {
    if (data is double) {
      // Update Data
      currentProgressed(data);
    }
  }

  // ^ Resets Peer Info Event ^
  void _handleTransmitted(dynamic data) async {
    // Reset Peer/Auth
    if (data is Peer) {
      // Provide Feedback
      currentCompleted();
    }
  }

  // ^ Mark as Received File ^ //
  Future<void> _handleReceived(dynamic data) async {
    if (data is TransferCard) {
      // Feedback
      HapticFeedback.heavyImpact();

      // Save Card to Gallery
      data.hasExported = await MediaService.saveTransfer(data);
      received.complete(data);

      // Store In SQL
      Get.find<SQLService>().storeCard(data);
    }
  }

  // ^ An Error Has Occurred ^ //
  void _handleSonrError(dynamic data) async {
    Get.reset();
    if (data is ErrorMessage) {
      print(data.method + "() - " + data.message);
    }
  }
}
