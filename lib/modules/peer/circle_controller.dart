import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/peer_controller.dart';
import 'package:sonar_app/modules/peer/peer_widget.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/models/models.dart';

enum CircleState {
  Empty,
  Active,
  Busy,
}

class CircleController extends GetxController {
  // Properties
  final isEmpty = true.obs;
  bool _isEmpty = true;
  RxList<PeerBubble> stackItems = new List<PeerBubble>().obs;

  // References
  SonrService _sonr = Get.find();

  // ^ Constructer ^ //
  CircleController() {
    // @ Listen to Peers Updates
    _sonr.peers.listen((map) {
      // * Check Map Size * //
      if (map.length > 0) {
        // @ Update State if already unchecked
        if (_isEmpty) {
          _isEmpty = false;
          isEmpty(false);
        }

        // @ Create Bubbles
        map.forEach((id, peer) {
          // Validate not Duplicate
          if (!stackItems.any((pb) => pb.controller.id == id)) {
            stackItems.add(PeerBubble(Get.put(PeerController(id, peer))));
            stackItems.refresh();
            print("Added Bubble");
          }
          // Update an Existing Peer
          else {
            var bubble = stackItems.where((pb) => pb.controller.id == id);
            _updateExistingPeer(bubble.first, peer);
          }
        });
        print("Total Bubbbles = " + stackItems.length.toString());
      } else {
        // @ Update State if already unchecked
        if (_isEmpty) {
          _isEmpty = true;
          isEmpty(true);
        }
      }
    });
  }

  // ^ Update Offset of Existing Bubble ^ //
  _updateExistingPeer(PeerBubble bubble, Peer value) {
    var newOffset = bubble.controller.calculateOffset(value.difference);
    bubble.controller.offset(newOffset);
  }
}
