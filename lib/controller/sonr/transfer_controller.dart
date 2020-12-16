import 'dart:io';
import 'package:sonar_app/ui/modals/modals.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/controller/sonr/conn_controller.dart';

class TransferController extends GetxController {
  // @ Set Local Properties

  // @ Set Peer Dependencies
  AuthReply reply;
  Payload_Type payloadType;
  Status status;

  // ^ Assign Callbacks and Create Ref for Node ^ //
  void assign() {
    sonrNode.assignCallback(CallbackEvent.Queued, _handleQueued);
    sonrNode.assignCallback(CallbackEvent.Responded, _handleResponded);
    sonrNode.assignCallback(CallbackEvent.Transmitted, _handleTransmitted);
  }

  // ^ Queue-File Event ^
  void queue(Payload_Type payType, {File file}) async {
    // Queue File
    if (payType == Payload_Type.FILE) {
      sonrNode.queue(file.path);
    }
    // Set Payload Type
    payloadType = payType;
    status = sonrNode.status;
  }

  // ^ Invite-Peer Event ^
  void invitePeer(Peer p) async {
    // Send Invite for File
    if (payloadType == Payload_Type.FILE) {
      await sonrNode.invite(p, payloadType);
    }
    // Send Invite for Contact
    else if (payloadType == Payload_Type.CONTACT) {
      await sonrNode.invite(p, payloadType);
    }
    status = sonrNode.status;
    update([p.id]);
  }

  // ^ Resets Status ^
  void finish() {
    status = Status.Ready;
    update([reply.from.id]);
    sonrNode.finish();
    reply = null;
  }

  // **************************
  // ******* Callbacks ********
  // **************************
  // ^ File has Succesfully Queued ^ //
  void _handleQueued(dynamic data) async {
    if (data is Metadata) {
      // Update data
      status = sonrNode.status;
      Get.offNamed("/transfer");
    }
  }

  // ^ Node Has Been Accepted ^ //
  void _handleResponded(dynamic data) async {
    // Check Type
    if (data is AuthReply) {
      // Set Message
      this.reply = data;
      status = sonrNode.status;
      print("Peer Replied: " + reply.toString());

      if (data.payload.type == Payload_Type.CONTACT) {
        // Report Replied to Bubble for File
        Get.bottomSheet(ContactInviteView(
          reply.payload.contact,
          isReply: true,
        ));
        update([data.from.id]);
      } else {
        // Report Replied to Bubble for File
        update([data.from.id]);
      }
    }
  }

  // ^ Resets Peer Info Event ^
  void _handleTransmitted(dynamic data) async {
    // Reset Peer/Auth
    if (data is Peer) {
      status = sonrNode.status;
      update([data.id]);
    }
  }
}
