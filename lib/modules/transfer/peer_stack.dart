// ^ Widget that Builds Stack of Peers ^ //
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/peer_controller.dart';
import 'package:sonar_app/modules/peer/peer_bubble.dart';
import 'package:sonar_app/service/sonr_service.dart';

const STACK_CONSTANT = 1;

class PeerStack extends StatelessWidget {
  final SonrService sonr = Get.find();
  @override
  Widget build(BuildContext context) {
    // @ Bubble View
    return Obx(() {
      // Initialize Widget List
      List<PeerBubble> stackWidgets = new List<PeerBubble>();

      // @ Verify Not Null
      if (sonr.peers.length > 0) {
        // Init Stack Vars
        // Check length of widgets list
        //if (stackWidgets.length > 0) {
        // @ Create Bubbles that arent added
        sonr.peers().forEach((id, peer) {
          // if (stackWidgets.any((b) => b.controller.peer.id == id)) {
          //   print("Peer already in list");
          // } else {
          stackWidgets.add(PeerBubble(Get.put(PeerController(peer))));
          // }
        });
        //} else {}
      }
      return Stack(children: stackWidgets);
    });
  }
}
