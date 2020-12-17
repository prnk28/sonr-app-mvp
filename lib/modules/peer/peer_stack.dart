// ^ Widget that Builds Stack of Peers ^ //
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/peer_bubble.dart';
import 'package:sonar_app/modules/peer/peer_bubble_controller.dart';
import 'package:sonar_app/service/sonr_service.dart';

class PeerStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize Widget List
    final SonrService sonr = Get.find();

    // @ Bubble View
    return Obx(() {
      List<PeerBubble> stackItems = new List<PeerBubble>();
      // @ Verify Not Null
      if (sonr.peers().length > 0) {
        // @ Create Bubbles that arent added
        sonr.peers().forEach((id, peer) {
          // Create Bubble
          stackItems.add(PeerBubble(Get.put(PeerBubbleController(peer))));
        });
      }
      return Stack(children: stackItems);
    });
  }
}
