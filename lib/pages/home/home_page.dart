import 'package:sonr_app/modules/grid/grid_view.dart';
import 'package:sonr_app/modules/share/index_view.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/modules/profile/profile_view.dart';
import 'package:sonr_app/modules/remote/remote_view.dart';
import 'action_button.dart';
import 'home_controller.dart';
import 'alerts_view.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
        resizeToAvoidBottomInset: false,
        shareView: ShareView(),
        bottomNavigationBar: HomeBottomNavBar(),
        appBar: DesignAppBar(
          title: HomeAppBarTitle(),
          action: HomeActionButton(),
        ),
        body: TabBarView(controller: controller.tabController, children: [
          CardMainView(key: ValueKey<HomeView>(HomeView.Main)),
          ProfileView(key: ValueKey<HomeView>(HomeView.Profile)),
          AlertsView(key: ValueKey<HomeView>(HomeView.Activity)),
          RemoteView(key: ValueKey<HomeView>(HomeView.Remote)),
        ]));
  }
}

// ^ Home Tab Bar Navigation ^ //
class HomeBottomNavBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isBottomBarVisible.value
        ? ClipPath(
            clipper: BottomBarClip(),
            child: Container(
              decoration: Neumorph.floating(),
              width: Get.width,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HomeBottomTabButton(HomeView.Main, controller.setBottomIndex, controller.bottomIndex),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: HomeBottomTabButton(HomeView.Profile, controller.setBottomIndex, controller.bottomIndex),
                  ),
                  Container(
                    width: Get.width * 0.20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: HomeBottomTabButton(HomeView.Activity, controller.setBottomIndex, controller.bottomIndex),
                  ),
                  HomeBottomTabButton(HomeView.Remote, controller.setBottomIndex, controller.bottomIndex),
                ],
              ),
            ),
          )
        : Container());
  }
}

// ^ Bottom Bar Button Widget ^ //
class HomeBottomTabButton extends GetView<HomeController> {
  final HomeView bottomType;
  final Function(int) onPressed;
  final RxInt currentIndex;
  HomeBottomTabButton(this.bottomType, this.onPressed, this.currentIndex);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onPressed(bottomType.index);
        },
        child: Container(
          constraints: BoxConstraints(maxHeight: 80, maxWidth: Get.width / 6),
          padding: const EdgeInsets.all(8.0),
          child: ObxValue<RxInt>(
              (idx) => AnimatedScale(
                    duration: 250.milliseconds,
                    child: idx.value == bottomType.index ? _buildSelected() : _buildDefault(),
                    scale: idx.value == bottomType.index ? 1.25 : 1.0,
                  ),
              currentIndex),
        ));
  }

  Widget _buildDefault() {
    return ImageIcon(
      AssetImage(bottomType.disabled),
      size: bottomType.iconSize,
      color: Colors.grey[400],
    );
  }

  Widget _buildSelected() {
    return LottieIcon(
      type: bottomType.lottie,
      size: bottomType.iconSize,
    );
  }
}

// ^ Dynamic App bar title for Lobby Size ^ //
class HomeAppBarTitle extends GetView<HomeController> {
  const HomeAppBarTitle({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isTitleVisible.value
        ? Container(
            height: 112,
            width: Get.width - 60,
            alignment: Alignment.centerLeft,
            child: OpacityAnimatedWidget(
              enabled: true,
              delay: 200.milliseconds,
              duration: 100.milliseconds,
              child: controller.view.value == HomeView.Main
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        "Hi ${UserService.contact.value.firstName},"
                            .headThree(color: SonrColor.Black, weight: FontWeight.w400, align: TextAlign.start),
                        AnimatedSlideSwitcher.fade(
                          duration: 2.seconds,
                          child: GestureDetector(
                            key: ValueKey<String>(controller.titleText.value),
                            onTap: () {
                              if (controller.isTitleVisible.value) {
                                controller.swapTitleText("${LobbyService.localSize.value} Around", timeout: 2500.milliseconds);
                              }
                            },
                            child: controller.titleText.value.headThree(color: SonrColor.Black, weight: FontWeight.w800, align: TextAlign.start),
                          ),
                        )
                      ],
                    )
                  : AnimatedSlideSwitcher.fade(
                      duration: 2.seconds,
                      child: GestureDetector(
                        key: ValueKey<String>(controller.titleText.value),
                        onTap: () {
                          if (controller.isTitleVisible.value) {
                            controller.swapTitleText("${LobbyService.localSize.value} Around", timeout: 2500.milliseconds);
                          }
                        },
                        child: controller.titleText.value.headThree(color: SonrColor.Black, weight: FontWeight.w800, align: TextAlign.start),
                      ),
                    ),
            ))
        : Container());
  }
}
