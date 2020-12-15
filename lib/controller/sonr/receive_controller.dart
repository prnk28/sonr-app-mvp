import 'package:sonar_app/controller/sonr/conn_controller.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;

class ReceiveController extends GetxController {
  // @ Set Peer Dependencies
  AuthInvite invite;
  bool invited = false;
  bool accepted = false;
  bool completed = false;

  // @ Set Data Dependencies
  var file = Rx<Metadata>();
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
      this.accepted = true;
      update(["ReceiveSheet"]);
    } else {
      // Reset Peer/Auth
      this.invite = null;
    }
    // Send Response
    await sonrNode.respond(decision);
  }

  // **************************
  // ******* Callbacks ********
  // **************************
  // ^ Node Has Been Invited ^ //
  void _handleInvite(dynamic data) async {
    print("Invite" + data.toString());
    // Check Type
    if (data is AuthInvite) {
      // Update Values
      this.invited = true;
      this.invite = data;

      // Inform Listener
      update(["Listener"]);
    }
  }

  // ^ Transfer Has Updated Progress ^ //
  void _handleProgress(dynamic data) async {
    if (data is double) {
      // Update Data
      this.progress(data);
    }
  }

  // ** Mark as Received File ** //
  void _handleReceived(dynamic data) {
    if (data is Metadata) {
      // Set Data
      this.file(data);
      this.completed = true;

      // Reset Peer/Auth
      this.invite = null;
      update(["Listener"]);
    } else {
      print("handleProgressed() - " + "Invalid Return type");
    }
  }
}
