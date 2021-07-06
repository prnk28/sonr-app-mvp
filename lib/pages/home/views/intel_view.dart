import 'package:sonr_app/pages/home/home.dart';
import 'package:sonr_app/style/style.dart';

class IntelHeader extends GetView<IntelController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Obx(() => GestureDetector(
          onTap: () async {
            if (NodeService.status.value == Status.FAILED) {
              await Logger.openIntercom();
            }
          },
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                WidgetSpan(
                    alignment: PlaceholderAlignment.aboveBaseline,
                    baseline: TextBaseline.alphabetic,
                    child: SonrIcons.Location.icon(
                      size: 22,
                      color: AppTheme.itemColor,
                    )),
                (" " + controller.title.value).headingSpan(
                  color: Get.theme.focusColor,
                  fontSize: 32,
                ),
              ])))),
    ]));
  }
}

class IntelFooter extends GetView<IntelController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSlider.fade(
          duration: 200.milliseconds,
          child: controller.badgeVisible.value
              ? _IntelBadgeCount(
                  key: ValueKey(true),
                )
              : _NearbyPeersRow(
                  key: ValueKey(false),
                ),
        ));
  }
}

class _NearbyPeersRow extends GetView<IntelController> {
  const _NearbyPeersRow({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: controller.obx(
        (state) {
          if (state != null) {
            if (state.hasMoreThanVisible) {
              final moreKey = GlobalKey();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: state.mapNearby(),
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      key: moreKey,
                      width: 36,
                      height: 36,
                      child: "${state.additionalPeers}+".light(
                        fontSize: 16,
                        color: AppTheme.greyColor,
                      ),
                      decoration: BoxDecoration(
                        color: SonrColor.AccentBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: state.mapNearby(),
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                ),
              );
            }
          }
          return Container();
        },
        onEmpty: Container(
          padding: EdgeInsets.only(bottom: 16),
          child: "Nobody Around".light(
            fontSize: 16,
            color: AppTheme.greyColor,
          ),
        ),
        onLoading: Opacity(
          opacity: 0.7,
          child: HourglassIndicator(scale: 1),
        ),
        onError: (_) => Container(),
      ),
    );
  }
}

class _IntelBadgeCount extends GetView<IntelController> {
  const _IntelBadgeCount({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 8),
        child: controller.obx(
          (state) {
            if (state != null) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                textBaseline: TextBaseline.ideographic,
                children: [
                  state.text(),
                  state.icon(),
                ],
              );
            } else {
              return Container();
            }
          },
          onEmpty: Container(),
          onLoading: Container(),
          onError: (_) => Container(),
        ));
  }
}
