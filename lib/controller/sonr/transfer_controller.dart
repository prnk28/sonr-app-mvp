import 'dart:io';
import 'package:sonar_app/model/model.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;
import 'sonr.dart';

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

      // Check Status
      if (message.event == AuthMessage_Event.ACCEPT) {
        // Get Controllers
        ConnController conn = Get.find();

        // Report Accepted
        this.status = message.event;
        update(["Bubble"]);

        // Start Transfer
        conn.node.transfer();
      } else if (message.event == AuthMessage_Event.DECLINE) {
        // Report Declined
        this.status = message.event;
        update(["Bubble"]);

        // Nullify Current Peer after 1.5s
        Future.delayed(
            Duration(seconds: 1, milliseconds: 500), () => this.peer = null);
        update(["Bubble"]);
      }
    }
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

    // @ Check Connection
    if (conn.connected) {
      // @ Check File Status
      if (_isProcessed) {
        // Update Data
        this.peer = p;
        update(["Bubble"]);

        // Send Invite
        await conn.node.invite(p);
      } else {
        throw SonrError("InvitePeer() - " + "File not processed.");
      }
    } else {
      throw SonrError("invitePeer() - " + "Not Connected");
    }
  }
}
