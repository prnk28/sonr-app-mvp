import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/controllers/peer_controller.dart';
import 'package:sonar_app/modules/pages/transfer/peer_bubble.dart';
import 'package:sonar_app/modules/widgets/design/neumorphic.dart';
import 'package:sonar_app/modules/widgets/painter/zones.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/models/models.dart';

import 'compass.dart';

const STACK_CONSTANT = 1;

class TransferScreen extends StatelessWidget {
  final SonrService sonr = Get.find();

  @override
  Widget build(BuildContext context) {
    return SonrTheme(Scaffold(
        appBar: SonrExitAppBar(
          context,
          Icons.close,
          () {
            Get.offAllNamed("/home");
          },
          title: sonr.code,
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

            // @ Peer Bubbles
            Obx(() => Stack(children: _createBubbles())),

            // @ Compass View
            CompassView(),
          ],
        ))));
  }

  // ** Create Bubble Widgets from Peer Data ** //
  List<Widget> _createBubbles() {
    return new List<Widget>.generate(sonr.peers.length, (int index) {
      // Determine Spawn Direction

      // Create Bubble
      return PeerBubble(Get.put(
          PeerController(sonr.peers[index], sonr.peers[index].difference)));
    });
  }
}
