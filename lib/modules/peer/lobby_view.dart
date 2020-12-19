import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/peer/peer_widget.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'lobby_controller.dart';
import 'package:sonar_app/theme/theme.dart';

class LobbyView extends GetView<LobbyController> {
  LobbyView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // // @ Bubble View
    // List<PeerBubble> stackItems = new List<PeerBubble>();
    // // @ Verify Not Null
    // if (Get.find<SonrService>().lobby().length > 0) {
    //   // @ Create Bubbles that arent added
    //   Get.find<SonrService>().lobby().forEach((id, peer) {
    //     // Create Bubble
    //     stackItems.add(PeerBubble(peer));
    //   });
    // }

    // Create From Controller
    return Obx(() {
      // @ Listen to Peers Updates
      Get.find<SonrService>().lobby().forEach((id, peer) {
        //print(id);
        // * Check Map Size * //
        controller.updateItem(id, peer);
        controller.stackItems.refresh();
      });

      // @ Create View
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
    LobbyController controller = Get.find();

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
    LobbyController controller = Get.find();
    // @ Animate in
    if (!controller.isEmpty.value) {
      return PlayAnimation<double>(
          tween: (0.0).tweenTo(1.0),
          duration: 500.milliseconds,
          delay: 500.milliseconds,
          builder: (context, child, value) {
            return Stack(children: List.from(controller.stackItems()));
          });
    }
    // @ Animate out
    else {
      return PlayAnimation<double>(
          tween: (1.0).tweenTo(0.0),
          duration: 500.milliseconds,
          builder: (context, child, value) {
            return Stack(children: List.from(controller.stackItems()));
          });
    }
  }
}
