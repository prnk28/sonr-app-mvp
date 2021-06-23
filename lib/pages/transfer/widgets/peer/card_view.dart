import 'package:rive/rive.dart';
import 'package:sonr_app/style.dart';
import 'peer.dart';

const double K_CARD_WIDTH = 160;
const double K_CARD_HEIGHT = 190;

/// @ Root Peer Card View
class PeerCard extends GetWidget<PeerController> {
  final Peer peer;
  PeerCard(this.peer) : super(key: ValueKey(peer.id.peer));

  @override
  Widget build(BuildContext context) {
    controller.initalize(peer);
    return Obx(
      () => Padding(
          padding: EdgeInsets.symmetric(vertical: 70),
          child: BoxContainer(
              width: K_CARD_WIDTH,
              height: K_CARD_HEIGHT,
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.all(24),
              child: ObxValue<RxBool>(
                  (isFlipped) => Stack(
                        children: [
                          // Rive Board
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 34),
                              child: Container(
                                alignment: Alignment.center,
                                height: 96,
                                width: 96,
                                child: controller.board.value == null || isFlipped.value
                                    ? Container()
                                    : Rive(
                                        artboard: controller.board.value!,
                                      ),
                              ),
                            ),
                          ),

                          // Content
                          Container(
                            padding: EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap: controller.invite,
                              child: AnimatedSlider.fade(
                                child: isFlipped.value
                                    ? _PeerDetailsCard(
                                        isFlipped: isFlipped,
                                        peer: controller.peer,
                                        key: ValueKey<bool>(true),
                                      )
                                    : _PeerMainCard(
                                        isFlipped: isFlipped,
                                        peer: controller.peer,
                                        key: ValueKey<bool>(false),
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                  false.obs))),
    );
  }
}

/// @ Main Peer Card View
class _PeerMainCard extends StatelessWidget {
  final RxBool isFlipped;
  final Rx<Peer> peer;
  const _PeerMainCard({Key? key, required this.isFlipped, required this.peer}) : super(key: key);

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
                onTap: () {
                  isFlipped(!isFlipped.value);
                  isFlipped.refresh();
                  HapticFeedback.heavyImpact();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SonrIcons.About.gradient(value: SonrGradient.Secondary, size: 24),
                ),
              )),

          // Avatar
          Obx(() => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: SonrTheme.foregroundColor.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: ProfileAvatar.fromPeer(peer.value, size: 72),
                ),
              )),
          Spacer(),

          // Device Icon and Full Name
          _buildName(),

          // Username
          _buildSName(),
        ].column());
  }

  Widget _buildName() {
    if (peer.value.profile.firstName.toLowerCase().contains('anonymous')) {
      return "${peer.value.profile.firstName}".subheading(color: SonrTheme.itemColor);
    } else {
      return "${peer.value.profile.fullName}".subheading(color: SonrTheme.itemColor);
    }
  }

  Widget _buildSName() {
    if (peer.value.profile.firstName.toLowerCase().contains('anonymous')) {
      return "${peer.value.profile.lastName}".paragraph(color: SonrTheme.greyColor);
    } else {
      return "${peer.value.profile.sName}.snr/".paragraph(color: SonrTheme.greyColor);
    }
  }
}

/// @ Details Peer Card View
class _PeerDetailsCard extends StatelessWidget {
  final RxBool isFlipped;
  final Rx<Peer> peer;
  const _PeerDetailsCard({Key? key, required this.isFlipped, required this.peer}) : super(key: key);

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
                onTap: () {
                  isFlipped(!isFlipped.value);
                  isFlipped.refresh();
                  HapticFeedback.heavyImpact();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SonrIcons.Backward.gradient(value: SonrGradient.Secondary, size: 24),
                )),

            // Align Compass
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.AccentNavy.withOpacity(0.75)),
              child: Obx(() => peer.value.prettyHeadingDirection().paragraph(color: SonrColor.White)),
            ),
          ].row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center),

          // Space Between
          Spacer(),

          // Device Information
          peer.value.platform.icon(size: 92, color: Get.theme.hintColor),
          Spacer(),

          // Device Icon and Full Name
          "${peer.value.model}".paragraph(),
        ].column());
  }
}
