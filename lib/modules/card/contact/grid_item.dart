import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/data/data.dart';

class ContactGridItemView extends StatelessWidget {
  final TransferCardItem item;
  const ContactGridItemView(this.item, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObxValue<RxBool>(
        (isFlipped) => Container(
              width: 160,
              height: 190,
              clipBehavior: Clip.antiAlias,
              decoration: Neumorph.floating(),
              margin: EdgeInsets.all(32),
              child: Stack(children: [
                // Content
                Container(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    // TODO: onTap: controller.invite,
                    child: AnimatedSlideSwitcher.fade(
                      child: isFlipped.value
                          ? _ContactGridItemDetailsView(
                              key: ValueKey<bool>(true),
                              isFlipped: isFlipped,
                              item: item,
                            )
                          : _ContactGridItemMainView(
                              key: ValueKey<bool>(false),
                              isFlipped: isFlipped,
                              item: item,
                            ),
                    ),
                  ),
                ),
              ]),
            ),
        false.obs);
  }
}

// ^ Main Contact Grid Item View ^ //
class _ContactGridItemMainView extends StatelessWidget {
  final TransferCardItem item;
  final RxBool isFlipped;
  const _ContactGridItemMainView({Key key, this.item, this.isFlipped}) : super(key: key);

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
                // TODO: onTap: () => controller.flipView(true),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SonrIcons.About.gradient(gradient: SonrGradient.Secondary, size: 24),
                ),
              )),

          // Avatar
          Obx(() => OpacityAnimatedWidget(
                // TODO: enabled: controller.isVisible.value,
                duration: 125.milliseconds,
                // TODO: child: controller.peer.value.profilePicture(size: 68),
              )),

          Spacer(),

          // Device Icon and Full Name
          // TODO: "${controller.peer.value.profile.firstName} ${controller.peer.value.profile.lastName}".h6,

          // Username
          // TODO: controller.peer.value.profile.username.p_Grey,
        ].column());
  }
}

// ^ Details Contact Grid Item View ^ //
class _ContactGridItemDetailsView extends StatelessWidget {
  final TransferCardItem item;
  final RxBool isFlipped;
  const _ContactGridItemDetailsView({Key key, this.item, this.isFlipped}) : super(key: key);

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
                // TODO: onTap: () => controller.flipView(false),
                child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SonrIcons.Backward.gradient(gradient: SonrGradient.Secondary, size: 24),
            )),

            // Align Compass
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.AccentNavy.withOpacity(0.75)),
              // TODO: child: Obx(() => " ${controller.peerVector.value.data.directionString}".h6_White),
            ),
          ].row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center),

          // Space Between
          Spacer(),

          // Device Information
          // TODO: controller.peer.value.platform.grey(size: 92),
          Spacer(),

          // Device Icon and Full Name
          // TODO:"${controller.peer.value.model}".h5,
        ].column());
  }
}
