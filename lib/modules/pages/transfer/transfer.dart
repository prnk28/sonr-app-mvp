import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/controllers/peer_controller.dart';
//import 'package:sonar_app/modules/controllers/peer_controller.dart';
import 'package:sonar_app/modules/controllers/transfer_controller.dart';
import 'package:sonar_app/modules/pages/transfer/peer_bubble.dart';
//import 'package:sonar_app/modules/pages/transfer/peer_bubble.dart';
import 'package:sonar_app/modules/widgets/design/neumorphic.dart';
import 'package:sonar_app/modules/widgets/painter/zones.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'compass.dart';

const STACK_CONSTANT = 1;

class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    SonrService sonr = Get.find();
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
            Obx(() {
              var bubbles = List<Widget>();

              // @ Add Values to List
              sonr.peers().forEach((key, value) {
                print(value.toString());
                // Check Existence in existing list, Add if not existing
                bubbles.add(PeerBubble(Get.put(PeerController(value))));
              });
              return Stack(children: controller.bubbles);
            }),

            // @ Compass View
            CompassView(),
          ],
        ))));
  }
}
