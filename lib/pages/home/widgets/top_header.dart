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
                    child: SimpleIcons.Location.icon(
                      size: 22,
                      color: AppTheme.ItemColor,
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
                        color: AppTheme.GreyColor,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.AccentBlue,
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
          padding: EdgeInsets.only(top: 8),
          child: "Nobody Around".light(
            fontSize: 18,
            color: AppTheme.GreyColor,
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
        height: 30,
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

class HomeAppBar extends GetView<HomeController> implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(() => AnimatedOpacity(
          duration: 200.milliseconds,
          opacity: controller.appbarOpacity.value,
          child: AnimatedSlider.fade(
            duration: 2.seconds,
            child: PageAppBar(
              centerTitle: controller.view.value.isDefault,
              key: ValueKey(false),
              subtitle: Padding(
                padding: controller.view.value.isDefault ? EdgeInsets.only(top: 68) : EdgeInsets.zero,
                child: controller.view.value == HomeView.Dashboard
                    ? "Hi ${ContactService.contact.value.firstName.capitalizeFirst},".subheading(
                        fontSize: 22,
                        color: Get.theme.focusColor.withOpacity(0.7),
                        align: TextAlign.start,
                      )
                    : Container(),
              ),
              action: HomeActionButton(
                dashboardKey: controller.keyTwo,
              ),
              leading: controller.view.value != HomeView.Contact
                  ? Padding(
                      padding: const EdgeInsets.only(top: 32.0, left: 8),
                      child: Container(
                        child: Obx(() => ShowcaseItem.fromType(
                              type: ShowcaseType.Help,
                              child: ActionButton(
                                banner: Logger.unreadIntercomCount.value > 0 ? ActionBanner.count(Logger.unreadIntercomCount.value) : null,
                                key: ValueKey<HomeView>(HomeView.Dashboard),
                                iconData: SimpleIcons.Help,
                                onPressed: () async => await Logger.openIntercom(),
                              ),
                            )),
                      ),
                    )
                  : null,
              title: controller.view.value != HomeView.Contact
                  ? IntelHeader()
                  : Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: controller.view.value.title.heading(
                        color: AppTheme.ItemColor,
                        align: TextAlign.start,
                      ),
                    ),
              footer: controller.view.value != HomeView.Contact ? IntelFooter() : null,
            ),
          ),
        ));
  }

  @override
  Size get preferredSize {
    if (controller.view.value != HomeView.Contact) {
      return Size(Get.width, 186);
    } else {
      return Size(Get.width, kToolbarHeight + 64);
    }
  }
}
