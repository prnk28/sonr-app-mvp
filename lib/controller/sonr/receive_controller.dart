import 'dart:io';
import 'package:sonar_app/model/model.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;
import 'sonr.dart';

class ReceiveController extends GetxController {
  // @ Set Peer Dependencies
  AuthMessage_Event status = AuthMessage_Event.NONE;
  AuthMessage auth;
  Peer peer;
  bool completed = false;

  // @ Set Data Dependencies
  final file = Rx<File>();
  final metadata = Rx<Metadata>();
  final progress = Rx<ProgressUpdate>();

  // ** Update Properties of TransferController ** //
  void updateReceive({AuthMessage message, ProgressUpdate progress}) {
    // Validate AuthMessage
    if (message != null) {
      this.auth = message;
      this.peer = message.from;
      this.metadata(message.metadata);
      this.status = message.event;
      update(["Listener"]);
    }

    // Validate Progress
    if (progress != null) {
      this.progress(progress);
    }
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
    update(["Completed"]);
  }

  // ^ Respond-Peer Event ^
  void respondPeer(bool decision) async {
    // Get Controllers
    ConnController conn = Get.find();

    // @ Check Connection
    if (conn.connected) {
      // Update Status by Decision
      if (decision) {
        this.status = AuthMessage_Event.ACCEPT;
        update();
      } else {
        this.status = AuthMessage_Event.DECLINE;

        // Reset Peer/Auth
        this.peer = null;
        this.auth = null;
        update();
      }

      // Send Response
      await conn.node.respond(decision);
    } else {
      throw SonrError("respondPeer() - " + "Not Connected");
    }
  }
}
