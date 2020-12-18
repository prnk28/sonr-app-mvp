import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/transfer/peer/circle_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonar_app/service/sonr_service.dart';

import 'peer/circle_view.dart';
import 'compass/compass_view.dart';
import 'compass/zone_painter.dart';

class TransferScreen extends GetView<CircleController> {
  @override
  Widget build(BuildContext context) {
    SonrService sonr = Get.find();
    return SonrTheme(Scaffold(
        appBar: SonrExitAppBar(
          context,
          "/home",
          title: sonr.code,
        ),
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            // @ Range Lines
            ZoneView(),

            // @ Peer Bubbles
            CircleView(),

            // @ Compass View
            CompassView(),
          ],
        ))));
  }
}
