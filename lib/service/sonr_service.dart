import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart' as Pkg;
import 'package:get/get.dart' hide Node;
import 'package:sonr_app/data/model_user.dart';
import 'package:sonr_app/modules/transfer/peer_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart' hide User;
import 'device_service.dart';
import 'sql_service.dart';

// @ Enum to Handle Status
enum SonrStatus {
  Offline,
  Ready, // Available
  Processing, // Queuing File
  Searching, // Searching -> Post Processing
  Pending, // Pending Authorization
  Busy, // In Transfer
}

class SonrService extends GetxService {
  // @ Set Properties
  final connected = false.obs;
  final direction = 0.0.obs;
  final peers = Map<String, Peer>().obs;
  final olc = "".obs;
  final progress = 0.0.obs;
  final payload = Rx<Payload>();

  // @ Set References
  Node _node;
  PeerController _peerController;
  bool _processed = false;
  String _url;
  InviteRequest_FileInfo _file;

  // ^ Updates Node^ //
  SonrService() {
    FlutterCompass.events.listen((dir) {
      // Update Direction
      direction(dir.heading);

      // Get Current Direction and Update Cubit
      if (connected.value) {
        _node.update(dir.headingForCameraMode);
      }
    });
  }

  // ^ Initialize Service Method ^ //
  Future<SonrService> init(Pkg.Position pos, User user) async {
    // Create Worker
    _node = await SonrCore.initialize(pos.latitude, pos.longitude, user.username, user.contact);

    // Assign Node Callbacks
    _node.assignCallback(CallbackEvent.Connected, _handleConnected);
    _node.assignCallback(CallbackEvent.Refreshed, _handleRefresh);
    _node.assignCallback(CallbackEvent.Invited, _handleInvite);
    _node.assignCallback(CallbackEvent.Progressed, _handleProgress);
    _node.assignCallback(CallbackEvent.Received, _handleReceived);
    _node.assignCallback(CallbackEvent.Responded, _handleResponded);
    _node.assignCallback(CallbackEvent.Transmitted, _handleTransmitted);
    _node.assignCallback(CallbackEvent.Error, _handleSonrError);

    connected(true);

    // Return Service
    return this;
  }

  // ***********************
  // ******* Events ********
  // ***********************
  // ^ Process-File Event ^
  void setPayload(Payload type, {String path, String url, bool hasThumbnail = false, int duration = -1, String thumbPath = ""}) async {
    // Set Payload Type
    payload(type);
    print(type.toString());

    // File Payload
    if (payload.value == Payload.MEDIA) {
      assert(path != null);
      _file = InviteRequest_FileInfo();
      _file.path = path;
      _file.hasThumbnail = hasThumbnail;
      _file.duration = duration;
      _file.thumbpath = thumbPath;
    }

    // Link Payload
    else if (payload.value == Payload.URL) {
      assert(url != null);
      _url = url;
    }
  }

  // ^ Invite-Peer Event ^
  void invite(PeerController c) async {
    // Set For Animation
    _peerController = c;

    // File Payload
    if (payload.value == Payload.MEDIA) {
      // Check Status
      if (_processed) {
        await _node.inviteFile(c.peer, _file);
      }
    }

    // Contact Payload
    else if (payload.value == Payload.CONTACT) {
      await _node.inviteContact(c.peer);
    }

    // Link Payload
    else if (payload.value == Payload.URL) {
      assert(_url != null);
      await _node.inviteLink(c.peer, _url);
    }

    // No Payload
    else {
      SonrSnack.error("No media, contact, or link provided");
    }
  }

  // ^ Respond-Peer Event ^
  void respond(bool decision) async {
    // Send Response
    await _node.respond(decision);
  }

  // **************************
  // ******* Callbacks ********
  // **************************
  // ^ Handle Connected to Bootstrap Nodes ^ //
  void _handleConnected(dynamic data) {
    // Set Connected, Send first Update
    _node.update(direction.value);
  }

  // ^ Handle Lobby Update ^ //
  void _handleRefresh(dynamic data) {
    if (data is Lobby) {
      // Update Peers List
      peers(data.peers);
    }
  }

  // ^ Node Has Been Invited ^ //
  void _handleInvite(dynamic data) async {
    // Check Type
    if (data is AuthInvite) {
      print(data.toProto3Json());
      Get.find<SonrCardController>().state(CardState.Invitation);
      HapticFeedback.heavyImpact();
      Get.dialog(SonrCard.fromInvite(data), barrierColor: K_DIALOG_COLOR);
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleResponded(dynamic data) async {
    if (data is AuthReply) {
      // Check if Sent Back Contact
      if (data.payload == Payload.CONTACT) {
        HapticFeedback.vibrate();
        Get.dialog(SonrCard.fromReply(data));
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
          payload(null);
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
      HapticFeedback.vibrate();
      _peerController.playCompleted();

      // Reset References
      _url = null;
      payload(null);
      _peerController = null;
    }
  }

  // ^ Mark as Received File ^ //
  void _handleReceived(dynamic data) {
    if (data is TransferCard) {
      // Reset Data
      progress(0.0);
      print(data.toString());

      // Save Card
      // Get.find<SQLService>().storeFile(data);
      Get.find<DeviceService>().saveMediaFromCard(data);
      Get.find<SonrCardController>().received(data);
      HapticFeedback.vibrate();
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
