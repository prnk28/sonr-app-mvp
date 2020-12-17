import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/peer_bubble.dart';
import 'package:sonar_app/modules/peer/peer_bubble_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonar_app/service/sonr_service.dart';

import 'compass_view.dart';
import 'zone_painter.dart';

class TransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SonrService sonr = Get.find();

    // Initialize Widget List
    var peerBubbles = List<PeerBubble>().obs;

    // Listen to Peer Data
    sonr.peers.listen((data) {
      // @ Create Bubbles that arent added
      data.forEach((id, peer) {
        peerBubbles.add(PeerBubble(Get.put(PeerBubbleController(peer))));
      });
      print(data.length);
      peerBubbles.refresh();
    });

    return SonrTheme(Scaffold(
        appBar: SonrExitAppBar(
          context,
          "/home",
          title: sonr.code,
        ),
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: Obx(() {
          return SafeArea(
              child: Stack(
            children: <Widget>[
              // @ Range Lines
              ZoneView(),

              // @ Peer Bubbles

              Stack(children: peerBubbles),

              // @ Compass View
              CompassView(),
            ],
          ));
        })));
  }
}
