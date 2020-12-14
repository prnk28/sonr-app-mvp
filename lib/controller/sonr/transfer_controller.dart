import 'dart:io';
import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/controller/sonr/conn_controller.dart';

class TransferController extends GetxController {
  // @ Set Local Properties
  bool _isProcessed = false;

  // @ Set Peer Dependencies
  AuthReply reply;
  Peer peer;
  bool completed = false;

  // @ Set Data Dependencies
  final file = Rx<File>();
  final metadata = Rx<Metadata>();

  // ^ Assign Callbacks and Create Ref for Node ^ //
  void assign() {
    sonrNode.assignCallback(CallbackEvent.Queued, _handleQueued);
    sonrNode.assignCallback(CallbackEvent.Responded, _handleResponded);
    sonrNode.assignCallback(CallbackEvent.Transmitted, _handleTransmitted);
  }

  // ^ Queue-File Event ^
  void queueFile(File file) async {
    // Queue File
    this.file(file);
    sonrNode.queue(file.path);
  }

  // ^ Invite-Peer Event ^
  void invitePeer(Peer p, Payload_Type pl) async {
    // @ Check File Status
    if (_isProcessed) {
      // Update Data
      this.peer = p;
      update(["Listener"]);

      // Send Invite
      await sonrNode.invite(p, pl);
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
  void _handleResponded(dynamic data) async {
    // Check Type
    if (data is AuthReply) {
      if (data.payload.type == Payload_Type.NONE) {
        // Set Message
        this.reply = data;

        // Report Replied
        update(["Listener"]);
      }
    } else {
      print("handleAccepted() - " + "Invalid Return type");
    }
  }

  // ^ Resets Peer Info Event ^
  void _handleTransmitted(dynamic data) async {
    this.completed = true;

    // Reset Peer/Auth
    this.peer = null;
    this.reply = null;
    update(["Listener"]);
  }
}
