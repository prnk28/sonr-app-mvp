import 'dart:io';
import 'package:sonar_app/model/model.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;
import 'sonr.dart';

class TransferController extends GetxController {
  // @ Set Local Properties
  bool _isProcessed = false;

  // @ Set Peer Dependencies
  AuthMessage auth;
  Peer peer;

  // @ Set Data Dependencies
  final file = Rx<File>();
  final metadata = Rx<Metadata>();

  // ** Update Properties of TransferController ** //
  void updateTransfer({Metadata metadata, AuthMessage message}) {
    // Validate Matadata
    if (metadata != null) {
      _isProcessed = true;
      this.metadata(metadata);
    }

    // Validate AuthMessage
    if (message != null) {
      // Set Message
      this.auth = message;
      this.peer = peer;

      // Check Status
      if (message.event == AuthMessage_Event.ACCEPT) {
        // Get Controllers
        ConnController conn = Get.find();

        // Start Transfer
        conn.node.transfer();
        update(["Accepted"]);
      } else if (message.event == AuthMessage_Event.DECLINE) {
        update(["Denied"]);
      }
    }
  }

  // ^ Resets Peer Info Event ^
  void setCompleted() async {
    // Reset Peer/Auth
    this.peer = null;
    this.auth = null;
    update(["Completed"]);
  }

  // ^ Queue-File Event ^
  void queueFile(File file) async {
    // Get Controllers
    ConnController conn = Get.find();

    // @ Check Connection
    if (conn.connected) {
      // Queue File
      this.file(file);
      conn.node.queue(file.path);
    } else {
      throw SonrError("queueFile() - " + " Not Connected");
    }
  }

  // ^ Invite-Peer Event ^
  void invitePeer(Peer p) async {
    // Get Controllers
    ConnController conn = Get.find();
    print(p.toString());

    // @ Check Connection
    if (conn.connected) {
      // @ Check File Status
      if (_isProcessed) {
        // Send Invite
        await conn.node.invite(p);

        // Update Data
        this.peer = p;
      } else {
        throw SonrError("InvitePeer() - " + "File not processed.");
      }
    } else {
      throw SonrError("invitePeer() - " + "Not Connected");
    }
  }
}
