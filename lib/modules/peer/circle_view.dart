// ^ Widget that Builds Stack of Peers ^ //
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'circle_controller.dart';

class CircleView extends StatelessWidget {
  CircleView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // @ Bubble View
    // List<PeerBubble> stackItems = new List<PeerBubble>();
    // // @ Verify Not Null
    // if (sonr.peers().length > 0) {
    //   // @ Create Bubbles that arent added
    //   sonr.peers().forEach((id, peer) {
    //     // Create Bubble
    //     stackItems.add(PeerBubble(Get.put(PeerController(peer))));
    //   });
    // }

    // Create From Controller
    return Obx(() {
      return Stack(
        children: [
          _buildEmpty(),
          _buildLobby(),
        ],
      );
    });
  }

  // ^ Build Empty Lobby With Text and Animation ^ //
  Widget _buildEmpty() {
    CircleController controller = Get.find();

    // @ Animate in
    if (controller.isEmpty.value) {
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
    CircleController controller = Get.find();
    // @ Animate in
    if (!controller.isEmpty.value) {
      return PlayAnimation<double>(
          tween: (0.0).tweenTo(1.0),
          duration: 500.milliseconds,
          delay: 500.milliseconds,
          builder: (context, child, value) {
            return Stack(children: List.from(controller.stackItems));
          });
    }
    // @ Animate out
    else {
      return PlayAnimation<double>(
          tween: (1.0).tweenTo(0.0),
          duration: 500.milliseconds,
          builder: (context, child, value) {
            return Stack(children: List.from(controller.stackItems));
          });
    }
  }
}
