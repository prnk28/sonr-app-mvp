import 'package:sonr_app/theme/theme.dart';
import 'peer.dart';

const double K_CARD_WIDTH = 160;
const double K_CARD_HEIGHT = 180;

// ^ Root Peer Card View ^ //
class PeerCard extends GetWidget<BubbleController> {
  final Peer peer;
  PeerCard(this.peer);

  @override
  Widget build(BuildContext context) {
    // Initialize Controller
    controller.initalize(peer);

    // Build View
    return Container(
      width: K_CARD_WIDTH,
      height: K_CARD_HEIGHT,
      clipBehavior: Clip.antiAlias,
      decoration: Neumorph.floating(),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(32),
      child: AnimatedSlideSwitcher.fade(
        child: GestureDetector(
          onTap: controller.invite,
          onLongPress: controller.expandDetails,
          child: Obx(() => controller.isFacing.value
              ? _PeerDetailsCard(controller: controller, key: ValueKey<bool>(true))
              : _PeerMainCard(controller: controller, key: ValueKey<bool>(false))),
        ),
      ),
    );
  }
}

// ^ Main Peer Card View ^ //
class _PeerMainCard extends StatelessWidget {
  final BubbleController controller;

  const _PeerMainCard({Key key, this.controller}) : super(key: key);
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
                onTap: () => controller.flipView(),
                child: SonrIcons.About.gradient(gradient: SonrPalette.secondary(), size: 24),
              )),

          // Avatar
          controller.peer.value.profilePicture(size: 60),
          Spacer(),

          // Device Icon and Full Name
          "${controller.peer.value.profile.firstName} ${controller.peer.value.profile.lastName}".h5,

          // Username
          controller.peer.value.profile.username.p_Grey,
        ].column());
  }
}

// ^ Details Peer Card View ^ //
class _PeerDetailsCard extends StatelessWidget {
  final BubbleController controller;
  const _PeerDetailsCard({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.widthTransformer(reducedBy: 0.8),
        height: context.heightTransformer(reducedBy: 0.6),
        alignment: Alignment.center,
        child: [
          // Align Platform
          Align(alignment: Alignment.topLeft, child: SonrIcons.Backward.gradient(gradient: SonrPalette.secondary(), size: 24)),

          // Device Information
          controller.peer.value.platform.grey(size: 60),
          Spacer(),

          // Device Icon and Full Name
          "${controller.peer.value.model}".h4,
        ].column());
  }
}
