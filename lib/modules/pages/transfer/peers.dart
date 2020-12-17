// ^ Widget that Builds Stack of Peers ^ //
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/controllers/peer_controller.dart';
import 'package:sonar_app/modules/pages/transfer/peer_bubble.dart';
import 'package:sonar_app/service/sonr_service.dart';

const STACK_CONSTANT = 1;

class PeerStack extends StatelessWidget {
  final SonrService sonr = Get.find();
  @override
  Widget build(BuildContext context) {
    // Initialize Widget List
    List<PeerBubble> stackWidgets = new List<PeerBubble>();

    // @ Bubble View
    return Obx(() {
      // @ Verify Not Null
      if (sonr.peers.length > 0) {
        // Init Stack Vars
        int total = sonr.peers.length + STACK_CONSTANT;
        double mean = 1.0 / total;
        int current = 0;

        // @ Create Bubbles that arent added
        sonr.peers().forEach((id, peer) {
          // Create Bubble
          stackWidgets.add(PeerBubble(Get.put(PeerController(peer))));
          current++;
        });
      }
      return Stack(children: stackWidgets);
    });
  }
}
