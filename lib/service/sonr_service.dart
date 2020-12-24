import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/data/user_model.dart';
import 'package:sonar_app/modules/card/card_controller.dart';
import 'package:sonar_app/modules/card/card_invite.dart';
import 'package:sonar_app/modules/card/card_view.dart';
import 'package:sonar_app/modules/transfer/peer_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'sql_service.dart';

export 'package:sonr_core/sonr_core.dart';

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
  final lobby = Map<String, Peer>().obs;
  final code = "".obs;

  // @ Set References
  Node _node;
  bool _connected = false;
  bool _processed = false;

  // @ Set Transfer Dependencies
  Payload_Type _payloadType;

  // @ Set Receive Dependencies
  final progress = 0.0.obs;

  // ^ Updates Node^ //
  SonrService() {
    FlutterCompass.events.listen((dir) {
      // Get Current Direction and Update Cubit
      if (_connected) {
        _node.update(dir.headingForCameraMode);
      }
      direction(dir.headingForCameraMode);
    });
  }

  // ^ Initialize Service Method ^ //
  Future<SonrService> init(Position pos, User user) async {
    // Get OLC
    code(OLC.encode(pos.latitude, pos.longitude, codeLength: 8));

    // Await Initialization -> Set Node
    _connect(user);

    // Return Service
    return this;
  }

  // ^ Connect to Node Method
  _connect(User user) async {
    // Create Worker
    _node = await SonrCore.initialize(code.value, user.username, user.contact);

    // Assign Node Callbacks
    _node.assignCallback(CallbackEvent.Refreshed, _handleRefresh);
    _node.assignCallback(CallbackEvent.Invited, _handleInvite);
    _node.assignCallback(CallbackEvent.Progressed, _handleProgress);
    _node.assignCallback(CallbackEvent.Received, _handleReceived);
    _node.assignCallback(CallbackEvent.Queued, _handleQueued);
    _node.assignCallback(CallbackEvent.Responded, _handleResponded);
    _node.assignCallback(CallbackEvent.Transmitted, _handleTransmitted);
    _node.assignCallback(CallbackEvent.Error, _handleSonrError);

    // Set Connected
    _connected = true;

    // Push to Home Screen
    Get.offNamed("/home");
  }

  // ***********************
  // ******* Events ********
  // ***********************
  // ^ Queue-File Event ^
  void queue(Payload_Type payType, {File file}) async {
    // Set Payload Type
    _payloadType = payType;

    // Queue File
    if (payType == Payload_Type.FILE) {
      _node.queue(file.path);
    } else {
      _processed = true;
    }

    // Go to Transfer
    Get.offNamed("/transfer");
  }

  // ^ Invite-Peer Event ^
  void invite(Peer p) async {
    // Check Status
    if (_processed) {
      await _node.invite(p, _payloadType);
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
    Get.find<SQLService>().saveContact(c);
  }

  // **************************
  // ******* Callbacks ********
  // **************************
  // ^ Handle Lobby Update ^ //
  void _handleRefresh(dynamic data) {
    if (data is Lobby) {
      // Update Peers List
      lobby(data.peers);
    }
  }

  // ^ File has Succesfully Queued ^ //
  void _handleQueued(dynamic data) async {
    if (data is Metadata) {
      // Update data
      _processed = true;
    }
  }

  // ^ Node Has Been Invited ^ //
  void _handleInvite(dynamic data) async {
    // Check Type
    if (data is AuthInvite) {
      // Inform Listener
      Get.find<CardController>().setInvited();
      HapticFeedback.heavyImpact();
      Get.dialog(CardInvite(data), barrierColor: K_DIALOG_COLOR);
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleResponded(dynamic data) async {
    print(data.toString());
    if (data is AuthReply) {
      // Check if Sent Back Contact
      if (data.payload.type == Payload_Type.CONTACT) {
        HapticFeedback.vibrate();
        Get.find<PeerController>().playCompleted();
        Get.dialog(CardView.fromTransferContact(data.payload.contact));
      } else {
        // For File
        if (data.decision) {
          Get.find<PeerController>().playAccepted();
          HapticFeedback.lightImpact();
        } else {
          Get.find<PeerController>().playDenied();
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
      Get.find<PeerController>().playCompleted();
      HapticFeedback.vibrate();
    }
  }

  // ^ Mark as Received File ^ //
  void _handleReceived(dynamic data) {
    if (data is Metadata) {
      // Reset Data
      progress(0.0);

      // Save Card
      Get.find<SQLService>().saveFile(data);
      Get.find<CardController>().received(data);
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
