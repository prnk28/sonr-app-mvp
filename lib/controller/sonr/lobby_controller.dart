import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/controller/sonr/conn_controller.dart';
import 'package:flutter/foundation.dart';

class LobbyController extends GetxController {
  Map<String, Peer> peers = new Map<String, Peer>();
  String code = "";
  int size = 0;

  // ^ Assign Callbacks ^ //
  void assign() {
    sonrNode.assignCallback(CallbackEvent.Refreshed, handleRefresh);
  }

  void handleRefresh(dynamic data) {
    // Check Type
    if (data is Lobby) {
      // Check if Lobby has Updated
      if (!mapEquals(peers, data.peers)) {
        code = data.code;
        size = data.peers.length;
        peers = data.peers;
        update();
      }
    }
  }
}
