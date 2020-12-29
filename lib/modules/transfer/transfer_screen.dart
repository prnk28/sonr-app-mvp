import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'compass_view.dart';
import 'transfer_controller.dart';

class TransferScreen extends StatelessWidget {
  // @ Initialize
  @override
  Widget build(BuildContext context) {
    return SonrTheme(
        child: Scaffold(
            appBar: SonrAppBar.leading(
                Get.find<SonrService>().olc.value,
                SonrButton.appBar(
                    SonrIcon.close, () => Get.offNamed("/home/transfer"))),
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

                // @ Lobby View
                LobbyView(),

                // @ Compass View
                CompassView(),
              ],
            ))));
  }
}

class LobbyView extends GetView<TransferController> {
  LobbyView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ Item Refs
      Widget lobbyText;
      Widget peerStack;

      // @ Listen to Peers Updates
      Get.find<SonrService>().lobby().forEach((id, peer) {
        // print(id);
        // * Check Map Size * //
        controller.addPeerBubble(id, peer);
      });

      // @ Lobby is Inactive
      if (controller.isEmpty()) {
        // Present Text
        lobbyText = PlayAnimation<double>(
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
                          child: SonrText.normal("No Peers found.",
                              size: 38, color: Colors.black87))));
            });

        // Hide Text
        peerStack = Container();
      }
      // @ Lobby is Active
      else {
        // Hide Text
        lobbyText = PlayAnimation<double>(
            tween: (1.0).tweenTo(0.0),
            duration: 500.milliseconds,
            builder: (context, child, value) {
              return AnimatedOpacity(
                  opacity: value,
                  duration: 500.milliseconds,
                  child: Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 360),
                      child: Center(
                          child: SonrText.normal("No Peers found.",
                              size: 38, color: Colors.black87))));
            });

        // Present Stack
        peerStack = Stack(children: List.from(controller.stackItems));
      }

      // @ Create View
      return Stack(
        children: [
          lobbyText,
          peerStack,
        ],
      );
    });
  }
}
