import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'peer_controller.dart';
import 'package:sonr_app/theme/theme.dart';

const double K_BUBBLE_SIZE = 80;

// ^ PeerBubble Utilizes Controller and Lottie Files ^ //
class PeerBubble extends StatelessWidget {
  final Peer peer;
  final TransferController transfer;
  PeerBubble(this.peer, this.transfer);

  @override
  Widget build(BuildContext context) {
    return GetX<PeerController>(
        autoRemove: false,
        init: PeerController(transfer, peer: peer),
        builder: (controller) {
          return AnimatedPositioned(
              width: K_BUBBLE_SIZE,
              height: K_BUBBLE_SIZE,
              top: controller.offset.value.dy - (ZonePathProvider.size / 2),
              left: controller.offset.value.dx - (ZonePathProvider.size / 2),
              duration: 150.milliseconds,
              child: ShapeButton.circle(
                  onPressed: controller.invite,
                  onLongPressed: controller.expandDetails,
                  child: Stack(alignment: Alignment.center, children: [
                    OpacityAnimatedWidget(
                        enabled: controller.isVisible.value,
                        values: controller.isVisible.value ? [0, 1] : [1, 0],
                        duration: Duration(milliseconds: 250),
                        delay: controller.isVisible.value ? Duration(milliseconds: 250) : Duration(milliseconds: 100),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                          controller.peer.initials,
                        ]))
                  ])));
        });
  }
}

// ^ PeerSheetView Displays Extended Peer Details ^ //
class PeerDetailsView extends StatelessWidget {
  final PeerController controller;
  const PeerDetailsView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.height / 3 + 25,
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Stack(children: [
            // Window
            NeumorphicBackground(
              borderRadius: BorderRadius.circular(20),
              backendColor: Colors.transparent,
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
                              Obx(() => SonrText(" " + controller.peerVector.value.facing.direction,
                                  weight: FontWeight.w300, size: 20, key: key, color: Colors.white))
                            ]),
                          ))),

                  // Peer Information
                  controller.peer.fullName,
                  controller.peer.platformExpanded,
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 90, vertical: 10),
                      child: ShapeButton.rectangle(
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
                  child: controller.peer.profilePicture(),
                ),
              ),
            ),
          ]),
        ));
  }
}
