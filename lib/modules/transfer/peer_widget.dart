import 'peer_controller.dart';
import 'package:sonr_app/theme/theme.dart';

const double K_BUBBLE_SIZE = 80;

// ^ PeerBubble Utilizes Controller and Lottie Files ^ //
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
              child: ShapeButton.circle(
                  onPressed: controller.invite,
                  onLongPressed: controller.expandDetails,
                  child: Stack(alignment: Alignment.center, children: [
                    _buildPeerInfo(controller),
                  ])));
        });
  }

  // @ Builds Peer Info for Peer
  Widget _buildPeerInfo(PeerController controller) {
    return PlayAnimation<double>(
        tween: controller.isVisible.value ? (0.0).tweenTo(1.0) : (1.0).tweenTo(0.0),
        duration: Duration(milliseconds: 250),
        delay: controller.isVisible.value ? Duration(milliseconds: 250) : Duration(milliseconds: 100),
        builder: (context, child, value) => AnimatedOpacity(
              opacity: value,
              duration: Duration(milliseconds: 250),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                controller.peer.initials,
              ]),
            ));
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
                              Obx(() => SonrText(" " + controller.position.value.facing.direction,
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

// ^ PeerListItem for Remote View ^ //
class PeerListItem extends StatefulWidget {
  final Peer peer;
  final int index;

  PeerListItem(this.peer, this.index);
  @override
  _PeerListItemState createState() => _PeerListItemState();
}

class _PeerListItemState extends State<PeerListItem> {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        margin: EdgeInsetsX.horizontal(8),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          leading: widget.peer.profilePicture(size: 50),
          title: SonrText.subtitle(widget.peer.profile.firstName + " " + widget.peer.profile.lastName, isCentered: true),
          subtitle: SonrText("",
              isRich: true,
              richText: RichText(
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  text: TextSpan(children: [
                    TextSpan(
                        text: widget.peer.platform.toString(),
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20, color: SonrPalette.Primary)),
                    TextSpan(
                        text: " - ${widget.peer.model}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 20, color: SonrPalette.Secondary)),
                  ]))),
          children: [
            Padding(padding: EdgeInsets.all(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColorButton.neutral(onPressed: () {}, text: "Block"),
                Padding(padding: EdgeInsets.all(8)),
                ColorButton.primary(
                  onPressed: () {
                    SonrService.inviteWithPeer(widget.peer);
                  },
                  text: "Invite",
                  icon: SonrIcon.invite,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(8)),
          ],
        ),
        style: SonrStyle.normal);
  }
}
