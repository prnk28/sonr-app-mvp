import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:rive/rive.dart';

class Bubble extends StatelessWidget {
  // Bubble Values
  final double value;
  final Peer peer;

  Bubble(this.value, this.peer);

  // Animation Handling
  final TransferController transferController = Get.find();

  // Flare actor or Rive Artboard
  Widget getChild(BubbleAnimController bubbleController) {
    if (bubbleController.hasCompleted()) {
      return FlareActor("assets/animations/complete.flr",
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "animate");
    } else {
      return Stack(alignment: Alignment.center, children: [
        Rive(
          artboard: bubbleController.artboard,
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          iconFromPeer(peer, size: 20),
          initialsFromPeer(peer),
        ]),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final BubbleAnimController bubbleController =
        Get.put<BubbleAnimController>(BubbleAnimController(peer));
    return GetBuilder<BubbleAnimController>(builder: (_) {
      return Positioned(
          top: calculateOffset(value).dy,
          left: calculateOffset(value).dx,
          child: GestureDetector(
              onTap: () async {
                if (!bubbleController.isInvited()) {
                  // Send Offer to Bubble
                  bubbleController.invite();
                  transferController.invitePeer(peer);
                }
              },
              child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(167, 179, 190, 1.0),
                      offset: Offset(8, 8),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(248, 252, 255, .5),
                      offset: Offset(-8, -8),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                    ),
                  ]),
                  child: getChild(bubbleController))));
    });
  }
}
