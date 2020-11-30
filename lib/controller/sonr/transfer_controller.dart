import 'dart:io';
import 'package:sonar_app/model/model.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;
import 'sonr.dart';

class TransferController extends GetxController {
  // @ Set Local Properties
  bool _isProcessed = false;

  // @ Set Peer Dependencies
  AuthStatus status;
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

      // Check Status
      if (message.event == AuthMessage_Event.ACCEPT) {
        // Get Controllers
        ConnController conn = Get.find();
        this.status = AuthStatus.Accepted;

        // Start Transfer
        conn.node.transfer();
        update(["Bubble"]);
      } else if (message.event == AuthMessage_Event.DECLINE) {
        // Report Declined
        this.status = AuthStatus.Declined;
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
    print(p.toString());

    // @ Check Connection
    if (conn.connected) {
      // @ Check File Status
      if (_isProcessed) {
        // Send Invite
        await conn.node.invite(p);

        // Update Data
        this.peer = p;

        this.status = AuthStatus.Invited;
        update();
      } else {
        throw SonrError("InvitePeer() - " + "File not processed.");
      }
    } else {
      throw SonrError("invitePeer() - " + "Not Connected");
    }
  }
}
