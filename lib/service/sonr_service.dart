import 'dart:io';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/modules/widgets/popups/card.dart';
import 'package:sonar_app/modules/widgets/sheets/contact.dart';
import 'package:sonar_app/modules/widgets/sheets/file.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:vibration/vibration.dart';

class SonrService extends GetxService {
  // @ Set Properteries
  final status = Status.Offline.obs;
  Node _node;
  String code = "";

  // @ Set Lobby Dependencies
  final size = 0.obs;
  final peers = Rx<List<Peer>>();

  // @ Set Transfer Dependencies
  AuthReply reply;
  Payload_Type payloadType;

  // @ Set Receive Dependencies
  AuthInvite invite;
  var file = Rx<Metadata>();
  var progress = 0.0.obs;

  // ^ Updates Node^ //
  SonrService() {
    FlutterCompass.events.listen((newDegrees) {
      // Get Current Direction and Update Cubit
      if (status() == Status.Ready || status() == Status.Searching) {
        _node.update(newDegrees.headingForCameraMode);
      }
    });
  }

  // ^ Connect Node Method ^ //
  Future<SonrService> init(Position pos, User user) async {
    // Get OLC
    code = OLC.encode(pos.latitude, pos.longitude, codeLength: 8);

    // Await Initialization
    _node = await SonrCore.initialize(
      code,
      user.username,
      user.contact,
    );

    // Assign Node Callbacks
    _node.assignCallback(CallbackEvent.Refreshed, _handleRefresh);
    _node.assignCallback(CallbackEvent.Invited, _handleInvite);
    _node.assignCallback(CallbackEvent.Progressed, _handleProgress);
    _node.assignCallback(CallbackEvent.Received, _handleReceived);
    _node.assignCallback(CallbackEvent.Queued, _handleQueued);
    _node.assignCallback(CallbackEvent.Responded, _handleResponded);
    _node.assignCallback(CallbackEvent.Transmitted, _handleTransmitted);
    _node.assignCallback(CallbackEvent.Error, _handleSonrError);

    // Return and Set Connected
    status(_node.status);
    return this;
  }

  // **************************
  // ******* Events ********
  // **************************
  // ^ Queue-File Event ^
  void queue(Payload_Type payType, {File file}) async {
    // Queue File
    if (payType == Payload_Type.FILE) {
      _node.queue(file.path);
    }
    // Set Payload Type
    payloadType = payType;
    status(_node.status);
  }

  // ^ Invite-Peer Event ^
  void invitePeer(Peer p) async {
    // Send Invite for File
    if (payloadType == Payload_Type.FILE) {
      await _node.invite(p, payloadType);
    }
    // Send Invite for Contact
    else if (payloadType == Payload_Type.CONTACT) {
      await _node.invite(p, payloadType);
    }
    status(_node.status);
  }

  // ^ Respond-Peer Event ^
  void respondPeer(bool decision) async {
    // Reset Peer/Auth
    if (!decision) {
      this.invite = null;
    }

    // Send Response
    await _node.respond(decision);

    // Update Status
    status(_node.status);
  }

  // ^ Resets Status ^
  void finish() {
    // @ Check if Sender/Receiver
    if (reply != null || invite != null) {
      _node.finish();
      reply = null;
      invite = null;

      file(null);
      progress(0.0);
      status(_node.status);
    }
  }

  // **************************
  // ******* Callbacks ********
  // **************************
  // ^ Handle Lobby Update ^ //
  void _handleRefresh(dynamic data) {
    if (data is Lobby) {
      // Update Peers Code
      size(data.peers.length);

      // Update Peers List
      var peersList = data.peers.values.toList(growable: false);
      peers(peersList);
    }
  }

  // ^ File has Succesfully Queued ^ //
  void _handleQueued(dynamic data) async {
    if (data is Metadata) {
      // Update data
      status(_node.status);
      Get.offNamed("/transfer");
    }
  }

  // ^ Node Has Been Invited ^ //
  void _handleInvite(dynamic data) async {
    print("Invite" + data.toString());
    // Check Type
    if (data is AuthInvite) {
      // Update Values
      this.invite = data;

      // Inform Listener
      status(_node.status);
      Vibration.vibrate();

      // Check Data Type for File
      if (data.payload.type == Payload_Type.FILE) {
        Get.bottomSheet(FileInviteView(data));
      }
      // Check Data Type for Contact
      else if (data.payload.type == Payload_Type.CONTACT) {
        Get.bottomSheet(ContactInviteView(data.payload.contact));
      }
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleResponded(dynamic data) async {
    if (data is AuthReply) {
      // Set Message
      this.reply = data;
      status(_node.status);

      if (data.payload.type == Payload_Type.CONTACT) {
        // Report Replied to Bubble for File
        Get.bottomSheet(ContactInviteView(
          reply.payload.contact,
          isReply: true,
        ));
        // update([data.from.id]);
      } else {
        // Report Replied to Bubble for File
        // update([data.from.id]);
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
      status(_node.status);
      //update([data.id]);
    }
  }

  // ^ Mark as Received File ^ //
  void _handleReceived(dynamic data) {
    if (data is Metadata) {
      // Set Data
      this.file(data);
      status(_node.status);
      Get.back();

      // Display Completed Popup
      Future.delayed(Duration(milliseconds: 500));
      Get.dialog(CardPopup());
    }
  }

  // ^ An Error Has Occurred ^ //
  void _handleSonrError(dynamic data) async {
    if (data is ErrorMessage) {
      print(data.method + "() - " + data.message);
    }
  }
}
