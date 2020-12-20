import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'lobby_controller.dart';
import 'package:sonar_app/theme/theme.dart';

class LobbyView extends GetView<LobbyController> {
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
        controller.createItem(id, peer);
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
                          child: normalText("No Peers found.",
                              size: 38, setColor: Colors.black87))));
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
                          child: normalText("No Peers found.",
                              size: 38, setColor: Colors.black87))));
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
