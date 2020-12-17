import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/pages/transfer/peer_stack.dart';
import 'package:sonar_app/modules/widgets/design/neumorphic.dart';
import 'package:sonar_app/modules/widgets/painter/zones.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'compass.dart';

const STACK_CONSTANT = 1;

class TransferScreen extends StatelessWidget {
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
            PeerStack(),

            // @ Compass View
            CompassView(),
          ],
        ))));
  }
}
