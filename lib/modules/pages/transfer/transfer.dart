import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/pages/transfer/peer_bubble.dart';
import 'package:sonar_app/modules/widgets/design/neumorphic.dart';
import 'package:sonar_app/modules/widgets/painter/zones.dart';
import 'package:sonar_app/service/service.dart';
import 'package:sonr_core/sonr_core.dart';

import 'compass.dart';

const STACK_CONSTANT = 1;

class TransferScreen extends StatelessWidget {
  final SonrService sonrService = Get.find();

  @override
  Widget build(BuildContext context) {
    // Return Widget
    return SonrTheme(Scaffold(
        appBar: SonrExitAppBar(
          context,
          Icons.close,
          () {
            Get.offAllNamed("/home");
          },
          title: sonrService.code,
        ),
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            // @ Range Lines
            Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: CustomPaint(
                  size: Size(Get.width, Get.height),
                  painter: ZonePainter(),
                  child: Container(),
                )),
            Obx(() {
              // Initialize Widget List
              List<PeerBubble> stackWidgets = new List<PeerBubble>();

              // @ Verify Not Null
              if (sonrService.size() > 0) {
                // Init Stack Vars
                int total = sonrService.size() + STACK_CONSTANT;
                double mean = 1.0 / total;
                int current = 0;

                // @ Create Bubbles that arent added
                sonrService.peers().forEach((peer) {
                  // Create Bubble
                  stackWidgets.add(PeerBubble(current * mean, peer));
                  current++;
                });
              }
              return Stack(children: stackWidgets);
            }),
            CompassView(),
          ],
        ))));
  }
}

// ^ Calculate Peer Offset from Line ^ //
Offset calculateOffset(double value,
    {Peer_Proximity proximity = Peer_Proximity.IMMEDIATE}) {
  Path path = ZonePainter.getBubblePath(Get.width, proximity);
  PathMetrics pathMetrics = path.computeMetrics();
  PathMetric pathMetric = pathMetrics.elementAt(0);
  value = pathMetric.length * value;
  Tangent pos = pathMetric.getTangentForOffset(value);
  return pos.position;
}
