import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';
import 'peer_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:rive/rive.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class PeerBubble extends StatelessWidget {
  // Initializes the Peer controller for this Instance
  final PeerController controller;
  PeerBubble(this.controller) {
    // Listen to this Peers Updates
    Get.find<SonrService>().lobby.listen((map) {
      // Validate ID
      map.forEach((id, val) {
        if (id == controller.peer.id) {
          controller.updatePeer(val);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Positioned(
          top: controller.offset.value.dy,
          left: controller.offset.value.dx,
          child: GestureDetector(
              onTap: () => controller.invite(),
              child: PlayAnimation<double>(
                  tween: (0.0).tweenTo(1.0),
                  duration: 500.milliseconds,
                  delay: 1.seconds,
                  builder: (context, child, value) {
                    return Container(
                        width: 90,
                        height: 90,
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(167, 179, 190, value),
                            offset: Offset(0, 2),
                            blurRadius: 6,
                            spreadRadius: 0.5,
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(248, 252, 255, value / 2),
                            offset: Offset(-2, 0),
                            blurRadius: 6,
                            spreadRadius: 0.5,
                          ),
                        ]),
                        child: Stack(alignment: Alignment.center, children: [
                          Rive(
                            artboard: controller.artboard.value,
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                          ),
                          _buildContentVisibility(),
                        ]));
                  })));
    });
  }

  // ^ Method to Change Content Visibility By State ^ //
  Widget _buildContentVisibility() {
    if (controller.shouldChangeVisibility.value) {
      return PlayAnimation<double>(
          tween: (1.0).tweenTo(0.0),
          duration: 20.milliseconds,
          builder: (context, child, value) {
            return AnimatedOpacity(
                opacity: value,
                duration: 20.milliseconds,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  iconFromPeer(controller.peer, size: 20),
                  initialsFromPeer(controller.peer),
                ]));
          });
    } else {
      return PlayAnimation<double>(
          tween: (0.0).tweenTo(1.0),
          duration: 500.milliseconds,
          delay: 1.seconds,
          builder: (context, child, value) {
            return AnimatedOpacity(
                opacity: value,
                duration: 500.milliseconds,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  iconFromPeer(controller.peer, size: 20),
                  initialsFromPeer(controller.peer),
                ]));
          });
    }
  }
}
