import 'dart:async';

import 'package:sonr_app/pages/home/home.dart';
import 'package:sonr_app/style/style.dart';

class IntelHeader extends GetView<IntelController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(
        () => GestureDetector(
          onTap: () async {
            if (controller.hasFailed.value) {
              await Logger.openIntercom();
            }
          },
          child: controller.isConnecting.value
              ? Center(
                  child: SpringLoader(),
                )
              : _buildTitle(
                  controller.title.value,
                ),
        ),
      ),
    );
  }

  /// Builds Title Widget from Controller Text
  Widget _buildTitle(String title) => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          WidgetSpan(
              alignment: PlaceholderAlignment.aboveBaseline,
              baseline: TextBaseline.alphabetic,
              child: SimpleIcons.Location.icon(
                size: 22,
                color: AppTheme.ItemColor,
              )),
          (" " + title).headingSpan(
            color: Get.theme.focusColor,
            fontSize: 32,
          ),
        ]),
      );
}

class IntelFooter extends StatefulWidget {
  IntelFooter({Key? key}) : super(key: key);
  @override
  _IntelFooterState createState() => _IntelFooterState();
}

class _IntelFooterState extends State<IntelFooter> {
  // Properties
  late StreamSubscription<Lobby> _lobbyStream;
  final badgeVisible = false.obs;

  // References
  CompareLobbyResult _compareResult = CompareLobbyResult();
  Lobby _lastLobby = Lobby();
  int _lastLobbyCount = 0;

  @override
  void initState() {
    // Listen to Streams
    _lobbyStream = LobbyService.lobby.listen(_handleLobbyStream);
    super.initState();
  }

  void dispose() {
    _lobbyStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSlider.fade(
          duration: 200.milliseconds,
          child: _buildChild(
            badgeVisible.value,
            Get.find<IntelController>().isConnecting.value,
          ),
        ));
  }

  Widget _buildChild(bool isBadgeVisible, bool isConnecting) {
    if (!isConnecting) {
      return isBadgeVisible
          ? Row(
              key: ValueKey(true),
              crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              textBaseline: TextBaseline.ideographic,
              children: [
                _compareResult.text(),
                _compareResult.icon(),
              ],
            )
          : _NearbyPeersRow(
              key: ValueKey(false),
            );
    } else {
      return Container();
    }
  }

  // @ Handle Size Update
  void _handleLobbyStream(Lobby onData) {
    // Check Valid
    _compareResult = CompareLobbyResult(current: onData, previous: _lastLobby);

    if (onData.count != _lastLobbyCount) {
      // Swap Text
      HapticFeedback.mediumImpact();
      badgeVisible(true);

      // Revert Text
      Future.delayed(1200.milliseconds, () {
        badgeVisible(false);
      });
    }

    // Update References
    _lastLobbyCount = onData.count;
    _lastLobby = onData;
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
        onError: (_) => Container(),
      ),
    );
  }
}

class HomeAppBar extends GetView<HomeController> implements PreferredSizeWidget {
  // References
  static Duration K_ANIMATION_DURATION = 200.milliseconds;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(() => AnimatedOpacity(
          duration: 200.milliseconds,
          opacity: controller.appbarOpacity.value,
          child: AnimatedSlider.fade(
            duration: 2.seconds,
            child: PageAppBar(
              centerTitle: controller.view.value.isDashboard,
              key: ValueKey(false),
              subtitle: Padding(
                padding: controller.view.value.paddingAppbar,
                child: _buildSubtitle(
                  controller.view.value.isDashboard,
                  Get.find<IntelController>().isConnecting.value,
                ),
              ),
              action: HomeActionButton(dashboardKey: controller.keyTwo),
              leading: controller.view.value.isDashboard
                  ? Padding(
                      padding: const EdgeInsets.only(top: 32.0, left: 8),
                      child: Container(
                          child: Obx(
                        () => ShowcaseItem.fromType(
                          type: ShowcaseType.Help,
                          child: ActionButton(
                            banner: Logger.intercomUnreadCount.value > 0 ? ActionBanner.count(Logger.intercomUnreadCount.value) : null,
                            key: ValueKey<HomeView>(HomeView.Dashboard),
                            iconData: SimpleIcons.Help,
                            onPressed: () async => await Logger.openIntercom(),
                          ),
                        ),
                      )),
                    )
                  : null,
              title: controller.view.value.isDashboard
                  ? IntelHeader()
                  : Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: controller.view.value.title.heading(
                        color: AppTheme.ItemColor,
                        align: TextAlign.start,
                      ),
                    ),
              footer: controller.view.value.isDashboard ? IntelFooter() : null,
            ),
          ),
        ));
  }

  // # Helper: Builds Subtitle
  Widget _buildSubtitle(bool isDashboard, bool isConnecting) {
    if (isDashboard && isConnecting) {
      return "Connecting..".subheading(
        fontSize: 22,
        color: Get.theme.focusColor.withOpacity(0.7),
        align: TextAlign.start,
      );
    } else if (isDashboard && !isConnecting) {
      return "Hi ${ContactService.contact.value.firstName.capitalizeFirst}".subheading(
        fontSize: 22,
        color: Get.theme.focusColor.withOpacity(0.7),
        align: TextAlign.start,
      );
    }
    return Container();
  }

  @override
  Size get preferredSize {
    if (controller.view.value != HomeView.Personal) {
      return Size(Get.width, 186);
    } else {
      return Size(Get.width, kToolbarHeight + 64);
    }
  }
}
