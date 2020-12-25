import 'package:get/get.dart';
import 'peer_widget.dart';
import 'package:sonr_core/models/models.dart';

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
  createItem(String id, Peer peer) {
    // @ Update State if already unchecked
    if (_isEmpty) {
      isEmpty(_isEmpty = false);
    }

    // @ Create Bubbles
    // Validate not Duplicate
    if (!stackItems.any((pb) => pb.controller.peer.id == id)) {
      stackItems.add(PeerBubble(peer, stackItems.length - 1));
      stackItems.refresh();
      //print("Added Bubble");
    }
    //print("Total Bubbbles = " + stackItems.length.toString());
    stackItems.refresh();
  }
}
