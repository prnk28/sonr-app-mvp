import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/controllers/peer_controller.dart';
import 'package:sonar_app/modules/pages/transfer/peer_bubble.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/models/models.dart';

class TransferController extends GetxController {
  // Properties
  var bubbles = List<PeerBubble>().obs;

  // * Constructer * //
  updateBubbles(Map<String, Peer> peers) {
    // @ Add Listener for peers
    print(peers.toString());

    // @ Remove Values from List
    bubbles.forEach((b) {
      // Check Existence in existing list, Remove if not existing
      if (!peers.values.any((e) => e.id == b.controller.peer.id)) {
        print(b.controller.peer.toString() + " is no longer in lobby.");
        bubbles.remove(b);
        update();
      }
    });

    // @ Add Values to List
    peers.forEach((key, value) {
      // Check Existence in existing list, Add if not existing
      if (!bubbles.any((b) => b.controller.peer.id == value.id)) {
        print(value.toString() + " has joined lobby.");
        bubbles.add(PeerBubble(Get.put(PeerController(value))));
      }
    });
  }
}
