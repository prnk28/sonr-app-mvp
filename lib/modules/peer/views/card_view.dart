import 'package:sonr_app/modules/peer/peer.dart';
import 'package:sonr_app/modules/peer/widgets/peer_border.dart';
import 'package:sonr_app/style/style.dart';

const double K_CARD_WIDTH = 160;
const double K_CARD_HEIGHT = 190;

/// #### Root Peer Card View
class PeerCardView extends GetWidget<PeerController> {
  final Member member;
  final GlobalKey peerKey = GlobalKey();
  PeerCardView(this.member) : super(key: ValueKey(member.active.id.peer));

  @override
  Widget build(BuildContext context) {
    controller.initalize(member);
    return GestureDetector(
      onTap: () {
        //if (SenderService.hasSelected.value) {
        controller.invite();
        // } else {
        //   AppRoute.positioned(
        //     ShareHoverView(peer: peer),
        //     init: () => ShareController.initPopup(),
        //     parentKey: peerKey,
        //     offset: Offset(-Get.width / 2, 20),
        //   );
        // }
      },
      child: BoxContainer(
          constraints: BoxConstraints.tight(Size(K_CARD_WIDTH, K_CARD_HEIGHT)),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(24),
          child: ObxValue<RxBool>(
              (isFlipped) => Stack(
                    children: [
                      // Rive Board
                      IgnorePointer(
                        child: PeerAvatarBorder(
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

/// #### Main Peer Card View
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
                  child: SimpleIcons.MoreVertical.icon(color: AppTheme.GreyColor, size: 24),
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
      return "${peer.value.profile.firstName.capitalizeFirst}".subheading(color: AppTheme.ItemColor);
    } else {
      return "${peer.value.profile.firstName.capitalizeFirst}".subheading(color: AppTheme.ItemColor);
    }
  }

  Widget _buildModel() {
    return "${peer.value.platform}".paragraph(color: AppTheme.GreyColor);
  }
}

/// #### Details Peer Card View
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
                  child: SimpleIcons.Backward.gradient(
                    value: DesignGradients.CrystalRiver,
                    size: 24,
                  ),
                )),

            // Align Compass
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: AppColor.AccentNavy.withOpacity(0.75)),
              child: Obx(() => peer.value.prettyHeadingDirection().paragraph(color: AppColor.White)),
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
