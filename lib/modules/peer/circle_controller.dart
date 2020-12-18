import 'package:get/get.dart';
import 'peer_controller.dart';
import 'peer_widget.dart';
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
    _sonr.peers.listen((map) {
      // @ Have to keep this to run for some unknown reason
      print(map);

      // * Check Map Size * //
      if (map.length > 0) {
        // Update State
        if (_isEmpty) {
          _isEmpty = false;
          isEmpty(false);
        }

        // Update Stack Items
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
            bubble.first.controller.setOffset(peer);
          }
        });
        print("Total Bubbbles = " + stackItems.length.toString());
      }
      // * Check Map Size * //
      else {
        // Update State
        if (!_isEmpty) {
          _isEmpty = true;
          isEmpty(true);

          // Clear StackItems List
          stackItems.clear();
          stackItems.refresh();
        }
      }
    });
  }

  // ^ Updates data from listener ^ //
  _updateItems(Map<String, Peer> data) {}
}
