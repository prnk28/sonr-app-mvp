import 'dart:async';
import 'dart:io';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/data/user_model.dart';
import 'package:sonar_app/modules/card/card_controller.dart';
import 'package:sonar_app/modules/card/card_invite.dart';
import 'package:sonar_app/modules/card/card_popup.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:vibration/vibration.dart';
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
  Complete, // Completed Transfer
}

class SonrService extends GetxService {
  // @ Set Properteries
  final status = SonrStatus.Offline.obs;
  final direction = 0.0.obs;
  final lobby = Map<String, Peer>().obs;
  final code = "".obs;

  // @ Set References
  Node _node;
  bool _connected = false;

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
    status(SonrStatus.Ready);

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
    status(SonrStatus.Processing);

    // Queue File
    if (payType == Payload_Type.FILE) {
      _node.queue(file.path);
    }
    // Go straight to transfer
    else if (payType == Payload_Type.CONTACT) {
      status(SonrStatus.Searching);
    }

    // Go to Transfer
    Get.offNamed("/transfer");
  }

  // ^ Invite-Peer Event ^
  void invite(Peer p) async {
    // Check Status
    if (status.value == SonrStatus.Searching) {
      await _node.invite(p, _payloadType);
      status(SonrStatus.Pending);
    }
  }

  // ^ Respond-Peer Event ^
  void respond(bool decision) async {
    // Send Response
    await _node.respond(decision);

    // Update Status
    if (decision) {
      status(SonrStatus.Ready);
    } else {
      status(SonrStatus.Busy);
    }
  }

  // ^ Save and Reset Status ^
  void finishContact(Contact c) async {
    // Save Card
    Get.find<SQLService>().saveContact(c);
    if (status.value != SonrStatus.Searching) {
      status(SonrStatus.Ready);
    }
  }

  // ^ Save and Reset Status ^
  void finishFile(Metadata m) async {
    // Save Card
    Get.find<SQLService>().saveFile(m);
    status(SonrStatus.Ready);
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
      status(SonrStatus.Searching);
    }
  }

  // ^ Node Has Been Invited ^ //
  void _handleInvite(dynamic data) async {
    // Check Type
    if (data is AuthInvite) {
      // Inform Listener
      status(SonrStatus.Pending);
      Vibration.vibrate(duration: 250);
      Get.dialog(CardInvite(data));
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleResponded(dynamic data) async {
    print(data.toString());
    if (data is AuthReply) {
      // Check if Sent Back Contact
      if (data.payload.type == Payload_Type.CONTACT) {
        Get.dialog(CardPopup.fromTransferContact(data.payload.contact));
        status(SonrStatus.Complete);
      } else {
        // For File
        if (data.decision) {
          // Update Status
          status(SonrStatus.Busy);
          Vibration.vibrate(duration: 50);
          Vibration.vibrate(duration: 100);
        } else {
          // User Denied
          status(SonrStatus.Searching);
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
      status(SonrStatus.Complete);
    }
  }

  // ^ Mark as Received File ^ //
  void _handleReceived(dynamic data) {
    if (data is Metadata) {
      // Reset Data
      progress(0.0);
      status(SonrStatus.Complete);
      Get.find<CardController>().setFile(data);
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
