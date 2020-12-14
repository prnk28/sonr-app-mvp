import 'package:sonar_app/controller/sonr/conn_controller.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;

class ReceiveController extends GetxController {
  // @ Set Peer Dependencies
  Peer peer;
  bool accepted;
  bool completed = false;

  // @ Set Data Dependencies
  var file = Rx<Metadata>();
  var invite = Rx<AuthInvite>();
  var progress = 0.0.obs;

  // ^ Assign Callbacks and Create Ref for Node ^ //
  void assign() {
    sonrNode.assignCallback(CallbackEvent.Invited, _handleInvite);
    sonrNode.assignCallback(CallbackEvent.Progressed, _handleProgress);
    sonrNode.assignCallback(CallbackEvent.Received, _handleReceived);
  }

  // ^ Respond-Peer Event ^
  void respondPeer(bool decision) async {
    // Update Status by Decision
    if (decision) {
      accepted = true;
      update(["ReceiveSheet"]);
    } else {
      // Reset Peer/Auth
      this.peer = null;
      this.invite(null);
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
    if (data is AuthInvite) {
      // Update Values
      this.peer = data.from;
      this.invite(data);

      // Inform Listener
      update(["Listener"]);
    } else {
      print("handleInvited() - " + "Invalid Return type");
    }
  }

  // ^ Transfer Has Updated Progress ^ //
  void _handleProgress(dynamic data) async {
    if (data is double) {
      // Update Data
      this.progress(data);
    } else {
      print("handleProgressed() - " + "Invalid Return type");
    }
  }

  // ** Mark as Received File ** //
  void _handleReceived(dynamic data) {
    if (data is Metadata) {
      // Set Data
      this.file(data);
      this.completed = true;

      // Reset Peer/Auth
      this.peer = null;
      this.invite(null);
      update(["Listener"]);
    } else {
      print("handleProgressed() - " + "Invalid Return type");
    }
  }
}
