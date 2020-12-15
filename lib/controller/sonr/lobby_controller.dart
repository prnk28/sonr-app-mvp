import 'package:sonr_core/sonr_core.dart';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/controller/sonr/conn_controller.dart';
//import 'package:flutter/foundation.dart';

class LobbyController extends GetxController {
  final code = "".obs;
  final size = 0.obs;
  final peers = Rx<List<Peer>>();

  // ^ Assign Callbacks ^ //
  void assign() {
    sonrNode.assignCallback(CallbackEvent.Refreshed, handleRefresh);
  }

  void handleRefresh(dynamic data) {
    // Check Type
    if (data is Lobby) {
      // Update Peers Code
      code(data.code);
      size(data.peers.length);

      // Update Peers List
      var peersList = data.peers.values.toList(growable: false);
      peers(peersList);
    } else {
      print("handleRefreshed() - " + "Invalid Return type");
    }
  }
}
