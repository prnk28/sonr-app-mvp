import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/peer_controller.dart';
import 'package:sonar_app/modules/peer/peer_widget.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';

enum CircleState {
  Empty,
  Active,
  Busy,
}

class CircleController extends GetxController {
  // Properties
  var peerStack = Stack();
  var emptyStringVisible = true;
  var peerStackVisible = false;

  // References
  SonrService _sonr = Get.find();
  List<PeerBubble> _stackItems = new List<PeerBubble>();

  // ^ Constructer ^ //
  CircleController() {
    // @ Listen to Peers Updates
    _sonr.peers.listen((map) {
      print(map.toString());
      // * Empty Map Size * //
      if (map.length == 0) {
        emptyStringVisible = true;
        update();
      }
      // * Map has Data * //
      else {
        // Update Widgets
        //if (_sonr.status.value == Status.Searching) {
        // Update State
        emptyStringVisible = false;
        peerStackVisible = true;
        update();
        // Create Bubbles
        map.forEach((id, peer) {
          _stackItems.add(PeerBubble(Get.put(PeerController(peer))));
        });
        print("Added " + _stackItems.length.toString() + " bubbles.");

        // Inform Widgets
        peerStack = Stack(children: _stackItems);
        update();
        //}
      }
    });
  }

  // ^ Update Items ^ //
  // _update(Map<String, Peer> data) {}
}
