import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/modules/transfer/peer_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'device_service.dart';
import 'sql_service.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart' as intent;

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
  final direction = 0.0.obs;
  final peers = Map<String, Peer>().obs;
  final exited = List<String>().obs;
  final olc = "".obs;
  final progress = 0.0.obs;

  // @ Set References
  bool _connected = false;
  Node _node;
  final payload = Rx<Payload>();
  PeerController _peerController;
  bool _processed = false;
  String _url;

  // ^ Updates Node^ //
  SonrService() {
    FlutterCompass.events.listen((dir) {
      // Update Direction
      direction(dir.heading);

      // Get Current Direction and Update Cubit
      if (_connected) {
        _node.update(dir.headingForCameraMode);
      }
    });
  }

  // ^ Initialize Service Method ^ //
  Future<SonrService> init(
      Position pos, String username, Contact contact) async {
    // Create Worker
    _node = await SonrCore.initialize(
        pos.latitude, pos.longitude, username, contact);

    // Assign Node Callbacks
    _node.assignCallback(CallbackEvent.Connected, _handleConnected);
    _node.assignCallback(CallbackEvent.Refreshed, _handleRefresh);
    _node.assignCallback(CallbackEvent.Invited, _handleInvite);
    _node.assignCallback(CallbackEvent.Progressed, _handleProgress);
    _node.assignCallback(CallbackEvent.Received, _handleReceived);
    _node.assignCallback(CallbackEvent.Queued, _handleQueued);
    _node.assignCallback(CallbackEvent.Responded, _handleResponded);
    _node.assignCallback(CallbackEvent.Transmitted, _handleTransmitted);
    _node.assignCallback(CallbackEvent.Error, _handleSonrError);

    _connected = true;

    // Return Service
    return this;
  }

  // ***********************
  // ******* Events ********
  // ***********************
  // ^ Process-File Event ^
  void process(Payload type,
      {File file,
      String url,
      bool isExtern = false,
      int duration = 0,
      String thumbPath = ""}) async {
    // Set Payload Type
    payload(type);

    // File Payload
    if (payload.value == Payload.FILE) {
      assert(file != null);

      _node.processFile(isExtern, file.path,
          thumbPath: thumbPath, duration: duration);
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
    if (payload.value == Payload.FILE) {
      // Check Status
      if (_processed) {
        await _node.inviteFile(c.peer);
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

  // ^ Save and Reset Status ^
  void saveContact(Contact c) async {
    // Save Card
    Get.find<SQLService>().storeContact(c);
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

  // ^ File has Succesfully Queued ^ //
  void _handleQueued(dynamic data) async {
    if (data is Preview) {
      // Update data
      _processed = true;
    }
  }

  // ^ Node Has Been Invited ^ //
  void _handleInvite(dynamic data) async {
    // Check Type
    if (data is AuthInvite) {
      Get.find<SonrCardController>().state(CardState.Invitation);
      HapticFeedback.heavyImpact();

      // Check Payload Type
      switch (data.payload) {
        case Payload.CONTACT:
          Get.dialog(SonrCard.fromInviteContact(data.contact),
              barrierColor: K_DIALOG_COLOR);
          break;
        case Payload.FILE:
          Get.dialog(SonrCard.fromInviteFile(data),
              barrierColor: K_DIALOG_COLOR);
          break;
        case Payload.URL:
          Get.dialog(SonrCard.fromInviteUrl(data.url, data.from.firstName),
              barrierColor: K_DIALOG_COLOR);
          break;
      }
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleResponded(dynamic data) async {
    if (data is AuthReply) {
      // Check if Sent Back Contact
      if (data.payload == Payload.CONTACT) {
        HapticFeedback.vibrate();
        Get.dialog(SonrCard.fromReplyContact(data.contact));
      } else {
        // For File
        if (data.decision) {
          _peerController.playAccepted();
          HapticFeedback.lightImpact();
        } else {
          _peerController.playDenied();
          HapticFeedback.mediumImpact();
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
    if (data is Metadata) {
      // Reset Data
      progress(0.0);
      print(data.toString());

      // Save Card
      Get.find<SQLService>().storeFile(data);
      Get.find<DeviceService>().saveMedia(data);
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
