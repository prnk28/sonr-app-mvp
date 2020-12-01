import 'dart:io';
import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/controller/sonr/conn_controller.dart';

class TransferController extends GetxController {
  // @ Set Local Properties
  bool _isProcessed = false;

  // @ Set Peer Dependencies
  AuthMessage_Event status = AuthMessage_Event.NONE;
  AuthMessage auth;
  Peer peer;
  bool completed = false;

  // @ Set Data Dependencies
  final file = Rx<File>();
  final metadata = Rx<Metadata>();

  // ^ Assign Callbacks and Create Ref for Node ^ //
  void assign() {
    sonrNode.assignCallback(CallbackEvent.Queued, _handleQueued);
    sonrNode.assignCallback(CallbackEvent.Accepted, _handleAccepted);
    sonrNode.assignCallback(CallbackEvent.Denied, _handleDenied);
  }

  // ^ Resets Peer Info Event ^
  void setCompleted() async {
    this.status = AuthMessage_Event.NONE;
    this.completed = true;

    // Reset Peer/Auth
    this.peer = null;
    this.auth = null;
    update(["Bubble"]);
  }

  // ^ Queue-File Event ^
  void queueFile(File file) async {
    // Queue File
    this.file(file);
    sonrNode.queue(file.path);
  }

  // ^ Invite-Peer Event ^
  void invitePeer(Peer p) async {
    // @ Check File Status
    if (_isProcessed) {
      // Update Data
      this.peer = p;
      update(["Bubble"]);

      // Send Invite
      await sonrNode.invite(p);
    } else {
      print("InvitePeer() - " + "File not processed.");
    }
  }

  // **************************
  // ******* Callbacks ********
  // **************************
  // ^ File has Succesfully Queued ^ //
  void _handleQueued(dynamic data) async {
    if (data is Metadata) {
      // Update data
      _isProcessed = true;
      this.metadata(data);
    } else {
      print("handleQueued() - " + "Invalid Return type");
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleAccepted(dynamic data) async {
    // Check Type
    if (data is AuthMessage) {
      // Set Message
      this.auth = data;

      // Report Accepted
      this.status = data.event;
      update(["Bubble"]);

      // Start Transfer
      sonrNode.transfer();
    } else {
      print("handleAccepted() - " + "Invalid Return type");
    }
  }

// ^ Node Has Been Denied ^ //
  void _handleDenied(dynamic data) async {
    // Check Type
    if (data is AuthMessage) {
      // Report Declined
      this.status = data.event;
      update(["Bubble"]);

      // Nullify Current Peer after 1.5s
      Future.delayed(
          Duration(seconds: 1, milliseconds: 500), () => this.peer = null);
      update(["Bubble"]);
    } else {
      print("handleDenied() - " + "Invalid Return type");
    }
  }
}
