import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/peer_controller.dart';
import 'package:sonar_app/modules/peer/peer_widget.dart';
import 'package:sonar_app/service/sonr_service.dart';

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
        print(map);
        // Update State if already unchecked
        if (_isEmpty) {
          _isEmpty = false;
          isEmpty(false);
          // update(["PeerCircleText", "PeerCircleStack"]);
        }

        // Create Bubbles
        map.forEach((id, peer) {
          // Validate not Duplicate
          if (!stackItems.any((pb) => pb.controller.id == id)) {
            stackItems.add(PeerBubble(Get.put(PeerController(id, peer))));
            stackItems.refresh();
            print("Added Bubble");

            // Inform Widgets
            // update(["PeerCircleText", "PeerCircleStack"]);
          }
        });
        print("Total Bubbbles = " + stackItems.length.toString());
      } else {
        // Update State if already unchecked
        if (_isEmpty) {
          _isEmpty = true;
          isEmpty(true);
          // update(["PeerCircleText", "PeerCircleStack"]);
        }
      }
    });
  }
}
