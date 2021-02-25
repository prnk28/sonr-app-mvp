import 'peer_controller.dart';
import 'package:sonr_app/service/service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:rive/rive.dart';
import 'package:sonr_app/data/data.dart';

// ^ PeerBubble Utilizes Peer Controller ^ //
class PeerBubble extends StatelessWidget {
  final Peer peer;
  final int index;
  PeerBubble(this.peer, this.index);

  @override
  Widget build(BuildContext context) {
    return GetX<PeerController>(
        init: PeerController(peer, index),
        builder: (controller) {
          return AnimatedPositioned(
              top: controller.expanded.value ? 25.0 : controller.offset.value.dy,
              left: controller.expanded.value ? 100.0 : controller.offset.value.dx,
              duration: 150.milliseconds,
              child: GestureDetector(
                  onTap: () => controller.invite(),
                  onLongPress: () => controller.toggleExpand(),
                  onDoubleTap: () => controller.toggleExpand(),
                  child: AnimatedContainer(
                    width: controller.expanded.value ? 200 : 90,
                    height: controller.expanded.value ? 220 : 90,
                    decoration: controller.expanded.value ? BoxDecoration() : SonrStyle.bubbleDecoration,
                    duration: 200.milliseconds,
                    child: controller.expanded.value ? _PeerExpandedView(controller) : _PeerDefaultView(controller),
                  )));
        });
  }
}

// ^ PeerBubble Receives Peer Controller and Builds View ^ //
class _PeerDefaultView extends StatelessWidget {
  final PeerController controller;
  const _PeerDefaultView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
        tween: controller.contentAnimation.value.item1,
        duration: controller.contentAnimation.value.item2,
        delay: controller.contentAnimation.value.item3,
        builder: (context, child, value) {
          return Obx(() {
            return AnimatedOpacity(
              opacity: value,
              duration: controller.contentAnimation.value.item2,
              child: Stack(alignment: Alignment.center, children: [
                controller.artboard.value == null
                    ? Container()
                    : Rive(
                        artboard: controller.artboard.value,
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                      ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Padding(padding: EdgeInsets.all(8)),
                  controller.peer.platform.icon(IconType.Gradient, size: 24),
                  controller.peer.initials(),
                  Padding(padding: EdgeInsets.all(8)),
                ])
              ]),
            );
          });
        });
  }
}

class _PeerExpandedView extends StatelessWidget {
  final PeerController controller;
  const _PeerExpandedView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
        tween: 0.0.tweenTo(1.0),
        duration: 100.milliseconds,
        delay: 200.milliseconds,
        builder: (context, child, value) {
          return AnimatedOpacity(
              opacity: value,
              duration: 100.milliseconds,
              child: Neumorphic(
                style: SonrStyle.overlay,
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                      alignment: Alignment.topRight,
                      child: SonrButton.flat(
                          onPressed: () {
                            controller.closeExpand();
                          },
                          icon: SonrIcon.close)),
                  controller.peer.platform.icon(IconType.Gradient, size: 32),
                  controller.peer.initials(),
                  // Padding(padding: EdgeInsets.all(8)),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: SonrButton.stadium(onPressed: controller.invite, icon: SonrIcon.accept, text: SonrText.semibold("Invite")))
                ]),
              ));
        });
  }
}
