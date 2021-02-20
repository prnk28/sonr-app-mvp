import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/modules/transfer/peer_controller.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/widgets/overlay.dart';
import 'package:sonr_core/sonr_core.dart';
import 'media_service.dart';
import 'sql_service.dart';
import 'user_service.dart';
export 'package:sonr_core/sonr_core.dart';

class SonrService extends GetxService {
  // @ Set Properties
  final _connected = false.obs;
  final olc = "".obs;
  final peers = Map<String, Peer>().obs;
  final progress = 0.0.obs;
  final payload = Rx<Payload>();

  static RxBool get connected => Get.find<SonrService>()._connected;

  // @ Set References
  Node _node;
  String _url;
  PeerController _peerController;
  InviteRequest_FileInfo _file;

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
      _node.assignCallback(CallbackEvent.Connected, _handleConnected);
      _node.assignCallback(CallbackEvent.Refreshed, _handleRefresh);
      _node.assignCallback(CallbackEvent.Directed, _handleDirect);
      _node.assignCallback(CallbackEvent.Invited, _handleInvite);
      _node.assignCallback(CallbackEvent.Progressed, _handleProgress);
      _node.assignCallback(CallbackEvent.Received, _handleReceived);
      _node.assignCallback(CallbackEvent.Responded, _handleResponded);
      _node.assignCallback(CallbackEvent.Transmitted, _handleTransmitted);
      _node.assignCallback(CallbackEvent.Error, _handleSonrError);

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
      contr._node.assignCallback(CallbackEvent.Connected, contr._handleConnected);
      contr._node.assignCallback(CallbackEvent.Refreshed, contr._handleRefresh);
      contr._node.assignCallback(CallbackEvent.Directed, contr._handleDirect);
      contr._node.assignCallback(CallbackEvent.Invited, contr._handleInvite);
      contr._node.assignCallback(CallbackEvent.Progressed, contr._handleProgress);
      contr._node.assignCallback(CallbackEvent.Received, contr._handleReceived);
      contr._node.assignCallback(CallbackEvent.Responded, contr._handleResponded);
      contr._node.assignCallback(CallbackEvent.Transmitted, contr._handleTransmitted);
      contr._node.assignCallback(CallbackEvent.Error, contr._handleSonrError);

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
      snr.payload(Payload.CONTACT);
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
      snr.payload(Payload.MEDIA);

      // Media Payload
      snr._file = InviteRequest_FileInfo();
      snr._file.path = path;
      snr._file.hasThumbnail = hasThumbnail;
      snr._file.duration = duration;
      snr._file.thumbpath = thumbPath;
      snr._file.thumbdata = thumbnailData;
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
      snr.payload(Payload.URL);

      // URL Link Payload
      snr._url = url;
    } else {
      SonrSnack.error("Not Connected to the Sonr Network");
    }
  }

  // ^ Invite-Peer Event ^
  static invite(PeerController c) async {
    // Get Data
    var snr = Get.find<SonrService>();

    if (snr._connected.value) {
      // Set For Animation
      snr._peerController = c;

      // File Payload
      if (snr.payload.value == Payload.MEDIA) {
        assert(snr._file != null);
        await snr._node.inviteFile(c.peer, snr._file);
      }

      // Contact Payload
      else if (snr.payload.value == Payload.CONTACT) {
        await snr._node.inviteContact(c.peer);
      }

      // Link Payload
      else if (snr.payload.value == Payload.URL) {
        assert(snr._url != null);
        await snr._node.inviteLink(c.peer, snr._url);
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

  // **************************
  // ******* Callbacks ********
  // **************************
  // ^ Handle Connected to Bootstrap Nodes ^ //
  void _handleConnected(dynamic data) {
    print(data);
    // Update Direction
    _node.update(DeviceService.direction.value.headingForCameraMode);
  }

  // ^ Handle Lobby Update ^ //
  void _handleRefresh(dynamic data) {
    if (data is Lobby) {
      // Update Lobby Data
      olc(data.olc);
      peers(data.peers);
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
        if (data.decision) {
          _peerController.playAccepted();
          HapticFeedback.lightImpact();
        } else {
          // Play Animation
          _peerController.playDenied();
          HapticFeedback.mediumImpact();

          // Reset References
          _url = null;
          payload.nil();
          _peerController = null;
        }
      }
    }
  }

  // ^ Transfer Has Updated Progress ^ //
  void _handleProgress(dynamic data) async {
    if (data is double) {
      // Update Data
      this.progress(data);
    }
  }

  // ^ Resets Peer Info Event ^
  void _handleTransmitted(dynamic data) async {
    // Reset Peer/Auth
    if (data is Peer) {
      // Provide Feedback
      HapticFeedback.heavyImpact();
      _peerController.playCompleted();

      // Reset References
      _url = null;
      _peerController = null;
      payload.nil();
    }
  }

  // ^ Mark as Received File ^ //
  Future<void> _handleReceived(dynamic data) async {
    if (data is TransferCard) {
      // Feedback
      HapticFeedback.heavyImpact();

      // Save Card to Gallery
      data.hasExported = await MediaService.saveTransfer(data);

      // Store In SQL
      Get.find<SQLService>().storeCard(data);

      // Reset Parameters
      Future.delayed(500.milliseconds, () {
        progress(0.0);
      });
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
