import 'package:simple_animations/simple_animations.dart';
import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class Bubble extends StatelessWidget {
  // Bubble Values
  final double value;
  final Peer peer;

  Bubble(this.value, this.peer);

  // Flare actor or Rive Artboard
  Widget getChild(BubbleAnimController controller) {
    if (controller.hasCompleted()) {
      return FlareActor("assets/animations/complete.flr",
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "animate");
    } else {
      return Stack(alignment: Alignment.center, children: [
        GestureDetector(
            onTap: () async {
              if (!controller.isInvited()) {
                // Animation Handling
                final TransferController transferController = Get.find();
                // Send Offer to Bubble
                controller.invite();
                transferController.invitePeer(peer);
              }
            },
            child: Expanded(
                child: Rive(
              artboard: controller.artboard,
            ))),
        PlayAnimation<double>(
            tween: (0.0).tweenTo(1.0),
            delay: Duration(seconds: 1),
            duration: Duration(seconds: 1),
            curve: Curves.easeOut,
            builder: (context, child, value) {
              return AnimatedOpacity(
                opacity: value,
                duration: Duration(seconds: 1),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconFromPeer(peer, size: 20),
                      initialsFromPeer(peer)
                    ]),
              );
            }),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    BubbleAnimController controller =
        Get.put<BubbleAnimController>(BubbleAnimController(peer));

    // Build Widget
    return GetBuilder<BubbleAnimController>(builder: (_) {
      return Positioned(
          top: calculateOffset(value).dy,
          left: calculateOffset(value).dx,
          child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(167, 179, 190, 1.0),
                  offset: Offset(6, 6),
                  blurRadius: 6,
                  spreadRadius: 0.5,
                ),
                BoxShadow(
                  color: Color.fromRGBO(248, 252, 255, .5),
                  offset: Offset(-6, -6),
                  blurRadius: 6,
                  spreadRadius: 0.5,
                ),
              ]),
              child: getChild(controller)));
    });
  }
}
