import 'package:rive/rive.dart';
import 'package:sonr_app/style/style.dart';
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
    return GestureDetector(
      onTap: controller.invite,
      child: BoxContainer(
          constraints: BoxConstraints.tight(Size(K_CARD_WIDTH, K_CARD_HEIGHT)),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(24),
          child: ObxValue<RxBool>(
              (isFlipped) => Stack(
                    children: [
                      // Rive Board
                      IgnorePointer(
                        child: _PeerAvatar(
                          controller: controller,
                        ),
                      ),
                      // Content
                      Container(
                        padding: EdgeInsets.all(8),
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
                      )
                    ],
                  ),
              false.obs)),
    );
  }
}

/// @ Peer Avatar with Rive Board Border
class _PeerAvatar extends StatelessWidget {
  final PeerController controller;

  const _PeerAvatar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 34),
              child: Container(
                  alignment: Alignment.center,
                  height: 96,
                  width: 96,
                  child: Obx(
                    () => Rive(artboard: controller.board.value),
                  )),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Obx(
                () => AnimatedOpacity(
                    opacity: controller.opacity.value,
                    duration: 150.milliseconds,
                    child: ProfileAvatar.fromPeer(
                      controller.peer.value,
                      size: 80,
                    )),
              )),
        ],
      ),
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
                  child: SonrIcons.MoreVertical.icon(color: AppTheme.greyColor, size: 24),
                ),
              )),

          Spacer(),

          // Device Icon and Full Name
          _buildName(),

          // Username
          _buildModel(),
          Padding(padding: EdgeInsets.all(4))
        ].column(mainAxisSize: MainAxisSize.min));
  }

  Widget _buildName() {
    if (peer.value.profile.firstName.toLowerCase().contains('anonymous')) {
      return "${peer.value.profile.firstName}".subheading(color: AppTheme.itemColor);
    } else {
      return "${peer.value.profile.firstName}".subheading(color: AppTheme.itemColor);
    }
  }

  Widget _buildModel() {
    return "${peer.value.platform}".paragraph(color: AppTheme.greyColor);
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
        ].column(mainAxisSize: MainAxisSize.min));
  }
}
