import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/lobby_view.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'transfer_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'compass_view.dart';
import 'zone_painter.dart';

class TransferScreen extends GetView<CompassController> {
  // @ Initialize
  @override
  Widget build(BuildContext context) {
    return SonrTheme(Scaffold(
        appBar: SonrExitAppBar(
          context,
          "/home",
          title: Get.find<SonrService>().code.value,
        ),
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            // @ Range Lines
            ZoneView(),

            // @ Lobby View
            LobbyView(),

            // @ Compass View
            CompassView(),
          ],
        ))));
  }
}
