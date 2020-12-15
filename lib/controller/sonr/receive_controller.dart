import 'package:sonar_app/controller/sonr/conn_controller.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;

class ReceiveController extends GetxController {
  // @ Set Peer Dependencies
  AuthInvite invite;
  Status status;

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
      status = sonrNode.status;
      update(["ReceiveSheet"]);
    } else {
      // Reset Peer/Auth
      this.invite = null;
    }
    // Send Response
    await sonrNode.respond(decision);
  }

  void finish() {
    sonrNode.finish();
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
      this.invite = data;

      // Inform Listener
      status = sonrNode.status;
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

      // Reset Peer/Auth
      this.invite = null;
      status = sonrNode.status;
      update(["Listener"]);
    } else {
      print("handleProgressed() - " + "Invalid Return type");
    }
  }
}
