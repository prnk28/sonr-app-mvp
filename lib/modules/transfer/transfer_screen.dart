import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'transfer_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'compass_view.dart';
import 'zone_painter.dart';

class TransferScreen extends GetView<TransferController> {
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
            Stack(
              children: [
                _buildEmpty(),
                _buildLobby(),
              ],
            ),

            // @ Compass View
            CompassView(),
          ],
        ))));
  }

// ^ Build Empty Lobby With Text and Animation ^ //
  Widget _buildEmpty() {
    return Obx(() {
      // @ Animate in
      if (controller.items.length == 0) {
        return PlayAnimation<double>(
            tween: (0.0).tweenTo(1.0),
            duration: 500.milliseconds,
            delay: 250.milliseconds,
            builder: (context, child, value) {
              return AnimatedOpacity(
                  opacity: value,
                  duration: 500.milliseconds,
                  child: Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 360),
                      child: Center(
                          child: normalText("No Peers found.",
                              size: 38, setColor: Colors.black87))));
            });
      }
      // @ Animate out
      else {
        return PlayAnimation<double>(
            tween: (1.0).tweenTo(0.0),
            duration: 500.milliseconds,
            builder: (context, child, value) {
              return AnimatedOpacity(
                  opacity: value,
                  duration: 500.milliseconds,
                  child: Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 360),
                      child: Center(
                          child: normalText("No Peers found.",
                              size: 38, setColor: Colors.black87))));
            });
      }
    });
  }

  // ^ Build Lobby With and Wait for Animation to Complete ^ //
  Widget _buildLobby() {
    return Obx(() {
      // @ Animate in
      if (controller.items.length > 0) {
        return PlayAnimation<double>(
            tween: (0.0).tweenTo(1.0),
            duration: 500.milliseconds,
            delay: 500.milliseconds,
            builder: (context, child, value) {
              return Obx(() => Stack(children: controller.items));
            });
      }
      // @ Animate out
      else {
        return PlayAnimation<double>(
            tween: (1.0).tweenTo(0.0),
            duration: 500.milliseconds,
            builder: (context, child, value) {
              return Obx(() => Stack(children: controller.items));
            });
      }
    });
  }
}
