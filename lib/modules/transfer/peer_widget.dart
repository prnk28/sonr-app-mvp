import 'peer_controller.dart';
import 'dart:ui';
import 'package:sonr_app/service/service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:rive/rive.dart';

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
                  onTap: () => controller.invite(),
                  child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(167, 179, 190, 1.0),
                          offset: Offset(0, 2),
                          blurRadius: 6,
                          spreadRadius: 0.5,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(248, 252, 255, 0.5),
                          offset: Offset(-2, 0),
                          blurRadius: 6,
                          spreadRadius: 0.5,
                        ),
                      ]),
                      child: Stack(alignment: Alignment.center, children: [
                        controller.artboard.value == null
                            ? const SizedBox()
                            : Rive(
                                artboard: controller.artboard.value,
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                              ),
                        PlayAnimation<double>(
                            tween: controller.contentAnimation.value.item1,
                            duration: controller.contentAnimation.value.item2,
                            delay: controller.contentAnimation.value.item3,
                            builder: (context, child, value) {
                              return AnimatedOpacity(
                                  opacity: value,
                                  duration: controller.contentAnimation.value.item2,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(padding: EdgeInsets.all(8)),
                                        SonrIcon.device(IconType.Gradient, controller.peer, size: 24),
                                        SonrText.initials(controller.peer),
                                        Padding(padding: EdgeInsets.all(8)),
                                      ]));
                            }),
                      ]))));
        });
  }
}

class _PeerView extends StatelessWidget {
  final PeerController controller;
  const _PeerView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
