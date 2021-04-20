import 'package:sonr_app/theme/theme.dart';
import 'peer.dart';

const double K_CARD_WIDTH = 160;
const double K_CARD_HEIGHT = 190;

// ^ Root Peer Card View ^ //
class PeerCard extends GetWidget<PeerController> {
  final Peer peer;
  PeerCard(this.peer);

  @override
  Widget build(BuildContext context) {
    // Initialize Controller
    controller.initalize(peer);

    // Build View
    return Obx(
      () => Container(
        width: K_CARD_WIDTH,
        height: K_CARD_HEIGHT,
        clipBehavior: Clip.antiAlias,
        decoration: Neumorph.floating(),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(32),
        child: GestureDetector(
          onTap: controller.invite,
          child: AnimatedSlideSwitcher.fade(
            child: controller.isFlipped.value
                ? _PeerDetailsCard(
                    controller: controller,
                    key: ValueKey<bool>(true),
                  )
                : _PeerMainCard(
                    controller: controller,
                    key: ValueKey<bool>(false),
                  ),
          ),
        ),
      ),
    );
  }
}

// ^ Main Peer Card View ^ //
class _PeerMainCard extends StatelessWidget {
  final PeerController controller;
  const _PeerMainCard({Key key, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.widthTransformer(reducedBy: 0.8),
        height: context.heightTransformer(reducedBy: 0.6),
        alignment: Alignment.center,
        child: [
          // Align Platform
          Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => controller.flipView(true),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SonrIcons.About.gradient(gradient: SonrPalette.secondary(), size: 24),
                ),
              )),

          // Avatar
          controller.peer.value.profilePicture(size: 68),
          Spacer(),

          // Device Icon and Full Name
          "${controller.peer.value.profile.firstName} ${controller.peer.value.profile.lastName}".h4,

          // Username
          controller.peer.value.profile.username.p_Grey,
        ].column());
  }
}

// ^ Details Peer Card View ^ //
class _PeerDetailsCard extends StatelessWidget {
  final PeerController controller;
  const _PeerDetailsCard({Key key, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.widthTransformer(reducedBy: 0.8),
        height: context.heightTransformer(reducedBy: 0.6),
        alignment: Alignment.center,
        child: [
          [
            // Align Platform
            GestureDetector(
                onTap: () => controller.flipView(false),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SonrIcons.Backward.gradient(gradient: SonrPalette.secondary(), size: 24),
                )),

            // Align Compass
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.AccentNavy.withOpacity(0.75)),
              child: Obx(() => " ${controller.peerVector.value.data.directionString}".h6_White),
            ),
          ].row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center),

          // Space Between
          Spacer(),

          // Device Information
          controller.peer.value.platform.grey(size: 92),
          Spacer(),

          // Device Icon and Full Name
          "${controller.peer.value.model}".h5,
        ].column());
  }
}
