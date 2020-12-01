import 'dart:io';
import 'package:sonar_app/controller/sonr/conn_controller.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;

class ReceiveController extends GetxController {
  // @ Set Peer Dependencies
  AuthMessage_Event status = AuthMessage_Event.NONE;
  AuthMessage auth;
  Peer peer;
  bool completed = false;

  // @ Set Data Dependencies
  var file = Rx<File>();
  var metadata = Rx<Metadata>();
  var progress = 0.0.obs;

  // ^ Assign Callbacks and Create Ref for Node ^ //
  void assign() {
    sonrNode.assignCallback(CallbackEvent.Invited, _handleInvite);
    sonrNode.assignCallback(CallbackEvent.Progressed, _handleProgress);
  }

  // ** Mark as Received File ** //
  void setCompleted(Metadata metadata) {
    // Set Data
    this.metadata(metadata);
    this.file(File(metadata.path));
    this.status = AuthMessage_Event.NONE;
    this.completed = true;

    // Reset Peer/Auth
    this.peer = null;
    this.auth = null;
    update(["Listener"]);
  }

  // ^ Respond-Peer Event ^
  void respondPeer(bool decision) async {
    // Update Status by Decision
    if (decision) {
      this.status = AuthMessage_Event.ACCEPT;
      update(["ReceiveSheet"]);
    } else {
      // Reset Peer/Auth
      this.peer = null;
      this.auth = null;
    }

    // Send Response
    await sonrNode.respond(decision);
  }

  // **************************
  // ******* Callbacks ********
  // **************************
  // ^ Node Has Been Invited ^ //
  void _handleInvite(dynamic data) async {
    // Check Type
    if (data is AuthMessage) {
      // Update Values
      this.auth = data;
      this.peer = data.from;
      this.metadata(data.metadata);
      this.status = data.event;

      // Inform Listener
      update(["Listener"]);
    } else {
      print("handleInvited() - " + "Invalid Return type");
    }
  }

  // ^ Transfer Has Updated Progress ^ //
  void _handleProgress(dynamic data) async {
    if (data is ProgressUpdate) {
      // Update Data
      this.progress(data.percent);
    } else {
      print("handleProgressed() - " + "Invalid Return type");
    }
  }
}
