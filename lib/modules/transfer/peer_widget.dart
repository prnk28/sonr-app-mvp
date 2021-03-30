import 'package:rive/rive.dart';
import 'peer_controller.dart';
import 'package:sonr_app/theme/theme.dart';

const double K_BUBBLE_SIZE = 80;

// ^ PeerBubble Utilizes Peer Controller ^ //
class PeerBubble extends StatelessWidget {
  final Peer peer;
  final int index;
  PeerBubble(this.peer, this.index);

  @override
  Widget build(BuildContext context) {
    return GetX<PeerController>(
        assignId: true,
        global: false,
        init: PeerController(peer: peer, index: index),
        builder: (controller) {
          return AnimatedPositioned(
              width: K_BUBBLE_SIZE,
              height: K_BUBBLE_SIZE,
              top: controller.offset.value.dy - (ZonePathProvider.size / 2),
              left: controller.offset.value.dx - (ZonePathProvider.size / 2),
              duration: 150.milliseconds,
              child: Container(
                width: K_BUBBLE_SIZE,
                height: K_BUBBLE_SIZE,
                child: GestureDetector(
                  onTap: () => controller.invite(),
                  onLongPress: () => controller.expandDetails(),
                  child: Stack(alignment: Alignment.center, children: [
                    controller.artboard.value == null
                        ? Container()
                        : Rive(
                            artboard: controller.artboard.value,
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                          ),
                    PlayAnimation<double>(
                        tween: controller.isVisible.value ? (0.0).tweenTo(1.0) : (1.0).tweenTo(0.0),
                        duration: Duration(milliseconds: 250),
                        delay: controller.isVisible.value ? Duration(milliseconds: 250) : Duration(milliseconds: 100),
                        builder: (context, child, value) => AnimatedOpacity(
                              opacity: value,
                              duration: Duration(milliseconds: 250),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Padding(padding: EdgeInsets.all(8)),
                                controller.peer.initials,
                                Padding(padding: EdgeInsets.all(8)),
                              ]),
                            )),
                  ]),
                ),
              ));
        });
  }
}

// ^ PeerSheetView Displays Extended Peer Details ^ //
class PeerSheetView extends StatelessWidget {
  final PeerController controller;
  const PeerSheetView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.height / 3 + 25,
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Stack(children: [
            // Window
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Neumorphic(
                style: SonrStyle.overlay,
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  // Close Button / Position Info
                  Align(
                      heightFactor: 0.9,
                      alignment: Alignment.topRight,
                      child: Container(
                          width: 100,
                          padding: EdgeInsets.all(10),
                          child: Neumorphic(
                            padding: EdgeInsets.all(4),
                            style: SonrStyle.compassStamp,
                            child: Row(children: [
                              SonrIcon.normal(
                                SonrIconData.compass,
                                color: Colors.white,
                                size: 20,
                              ),
                              Obx(() => SonrText.light(
                                    " " + controller.position.value.facing.direction,
                                    color: Colors.white,
                                    size: 20,
                                  ))
                            ]),
                          ))),

                  // Peer Information
                  controller.peer.fullName,
                  controller.peer.platformExpanded,
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 90, vertical: 10),
                      child: SonrButton.rectangle(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          shape: NeumorphicShape.convex,
                          depth: 4,
                          onPressed: () {
                            controller.invite();
                            Get.back();
                          },
                          icon: SonrIcon.invite,
                          text: SonrText.semibold("Invite", size: 24))),
                  Spacer()
                ]),
              ),
            ),

            // Profile Pic
            Align(
              alignment: Alignment.topCenter,
              child: Neumorphic(
                padding: EdgeInsets.all(4),
                style: NeumorphicStyle(
                  shadowLightColor: Colors.black38,
                  boxShape: NeumorphicBoxShape.circle(),
                  depth: 10,
                  color: SonrColor.White,
                ),
                child: Neumorphic(
                  style: NeumorphicStyle(intensity: 0.5, depth: -8, boxShape: NeumorphicBoxShape.circle(), color: SonrColor.White),
                  child: controller.peer.profilePicture,
                ),
              ),
            ),
          ]),
        ));
  }
}

// ^ PeerListItem for Remote View ^ //
class PeerListItem extends StatelessWidget {
  final Peer peer;
  final int index;

  PeerListItem(this.peer, this.index);

  @override
  Widget build(BuildContext context) {
    return GetX<PeerController>(
        assignId: true,
        init: PeerController(peer: peer, index: index, isAnimated: false),
        builder: (controller) {
          return Container(
              child: Row(
            children: [],
          ));
        });
  }
}
