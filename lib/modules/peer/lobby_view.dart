import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'lobby_controller.dart';
import 'package:sonar_app/theme/theme.dart';

class LobbyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(LobbyController());
    return Obx(() => Stack(
          children: [LobbyEmptyText(), LobbyStack()],
        ));
  }
}

class LobbyEmptyText extends GetView<LobbyController> {
  @override
  Widget build(BuildContext context) {
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
}

class LobbyStack extends GetView<LobbyController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Obx(() {
        // @ Animate in
        if (controller.items.length > 0) {
          return PlayAnimation<double>(
              tween: (0.0).tweenTo(1.0),
              duration: 500.milliseconds,
              delay: 500.milliseconds,
              builder: (context, child, value) {
                return Obx(() => Stack(children: List.from(controller.items)));
              });
        }
        // @ Animate out
        else {
          return PlayAnimation<double>(
              tween: (1.0).tweenTo(0.0),
              duration: 500.milliseconds,
              builder: (context, child, value) {
                return Obx(() => Stack(children: List.from(controller.items)));
              });
        }
      });
    });
  }
}
