import 'peer_controller.dart';
import 'package:sonr_app/service/service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:rive/rive.dart';

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
              top: controller.offset.value.dy,
              left: controller.offset.value.dx,
              duration: 150.milliseconds,
              child: GestureDetector(
                  onTap: () => controller.select(),
                  child: AnimatedContainer(
                    width: controller.bubbleSize.value.width,
                    height: controller.bubbleSize.value.height,
                    decoration: SonrStyle.bubbleDecoration,
                    duration: 200.milliseconds,
                    child: _PeerView(controller),
                  )));
        });
  }
}

// ^ PeerBubble Receives Peer Controller and Builds View ^ //
class _PeerView extends StatelessWidget {
  final PeerController controller;
  const _PeerView(this.controller, {Key key}) : super(key: key);

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
              child: controller.expanded.value ? _buildExpandedView() : _buildDefaultView(),
            );
          });
        });
  }

  _buildDefaultView() {
    return Stack(alignment: Alignment.center, children: [
      controller.artboard.value == null
          ? const SizedBox()
          : Rive(
              artboard: controller.artboard.value,
              alignment: Alignment.center,
              fit: BoxFit.contain,
            ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(padding: EdgeInsets.all(8)),
        controller.peer.platform.icon(IconType.Gradient, size: 24),
        SonrText.initials(controller.peer),
        Padding(padding: EdgeInsets.all(8)),
      ])
    ]);
  }

  _buildExpandedView() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
      controller.peer.platform.icon(IconType.Gradient, size: 32),
      SonrText.initials(controller.peer),
      Padding(padding: EdgeInsets.all(8)),
      Row(children: [
        SonrButton.flat(onPressed: controller.select, text: SonrText.semibold("Close", color: Colors.redAccent)),
        SonrButton.rectangle(onPressed: controller.invite, icon: SonrIcon.accept, text: SonrText.semibold("Invite"))
      ])
    ]);
  }
}
