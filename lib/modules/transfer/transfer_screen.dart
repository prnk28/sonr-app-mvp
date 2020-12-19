import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/peer_widget.dart';
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
          title: Get.find<SonrService>().code,
        ),
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            // @ Range Lines
            ZoneView(),

            // @ Lobby View
            Obx(() {
              // Create View
              return Stack(
                children: [
                  _buildEmpty(),
                  _buildLobby(),
                ],
              );
            }),

            // @ Compass View
            CompassView(),
          ],
        ))));
  }

// ^ Build Empty Lobby With Text and Animation ^ //
  Widget _buildEmpty() {
    // @ Animate in
    if (controller.lobby.value.state == LobbyState.Empty) {
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
  }

  // ^ Build Lobby With and Wait for Animation to Complete ^ //
  Widget _buildLobby() {
    // @ Animate in
    if (controller.lobby.value.state == LobbyState.Active) {
      return PlayAnimation<double>(
          tween: (0.0).tweenTo(1.0),
          duration: 500.milliseconds,
          delay: 500.milliseconds,
          builder: (context, child, value) {
            return Stack(children: controller.lobby.value.items);
          });
    }
    // @ Animate out
    else {
      return PlayAnimation<double>(
          tween: (1.0).tweenTo(0.0),
          duration: 500.milliseconds,
          builder: (context, child, value) {
            return Stack(children: controller.lobby.value.items);
          });
    }
  }
}
