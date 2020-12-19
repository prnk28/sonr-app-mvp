import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/peer_widget.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/models/models.dart';

import 'peer_controller.dart';

enum CircleState {
  Empty,
  Active,
  Busy,
}

class LobbyController extends GetxController {
  // Properties
  final isEmpty = true.obs;
  bool _isEmpty = true;
  RxList<PeerBubble> stackItems = new List<PeerBubble>().obs;

  // ^ Constructer ^ //
  updateItem(String id, Peer peer) {
    // @ Update State if already unchecked
    if (_isEmpty) {
      isEmpty(_isEmpty = false);
    }

    // @ Create Bubbles
    // Validate not Duplicate
    if (!stackItems.any((pb) => pb.peer.id == id)) {
      stackItems.add(PeerBubble(peer));
      stackItems.refresh();
      print("Added Bubble");
    }
    // Update an Existing Peer
    else {
      //var bubble = stackItems.where((pb) => pb.controller.id == id);
      // _updateExistingPeer(bubble.first, peer);
    }
    print("Total Bubbbles = " + stackItems.length.toString());
  }
}
