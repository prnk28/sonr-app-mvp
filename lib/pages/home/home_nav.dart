import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';
import 'page_view.dart';

// ^ Home Tab Bar Navigation ^ //
class HomeBottomNavBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isBottomBarVisible.value
        ? Neumorphic(
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.path(BottomBarPath()),
              depth: UserService.isDarkMode ? 4 : 8,
              color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
            ),
            child: Container(
              width: Get.width,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NavButton(HomeView.Home, controller.setBottomIndex, controller.bottomIndex),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: NavButton(HomeView.Profile, controller.setBottomIndex, controller.bottomIndex),
                  ),
                  Container(
                    width: Get.width * 0.20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: NavButton(HomeView.Alerts, controller.setBottomIndex, controller.bottomIndex),
                  ),
                  NavButton(HomeView.Remote, controller.setBottomIndex, controller.bottomIndex),
                ],
              ),
            ),
          )
        : Container());
  }
}

// ^ Bottom Bar Button Status ^ //
enum NavButtonStatus { Default, Animating, Completed }

// ^ Bottom Bar Button Widget ^ //
class NavButton extends GetView<HomeController> {
  final HomeView bottomType;
  final Function(int) onPressed;
  final RxInt currentIndex;
  NavButton(this.bottomType, this.onPressed, this.currentIndex);
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
            height: 56,
            alignment: Alignment.centerLeft,
            child: AnimatedSlideSwitcher.fade(
              duration: 2.seconds,
              child: GestureDetector(
                key: ValueKey<String>(controller.titleText.value),
                onTap: () {
                  if (controller.isTitleVisible.value) {
                    controller.swapTitleText("${LobbyService.localSize.value} Around", timeout: 2500.milliseconds);
                  }
                },
                child: controller.titleText.value.h3_White,
              ),
            ),
          )
        : Container());
  }
}

class HomeActionButton extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSlideSwitcher.fade(
          child: _buildView(controller.page.value),
          duration: const Duration(milliseconds: 2500),
        ));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(HomeView page) {
    // Return View
    if (page == HomeView.Profile) {
      return Container(key: ValueKey<HomeView>(HomeView.Profile));
    } else if (page == HomeView.Alerts) {
      return Container(key: ValueKey<HomeView>(HomeView.Alerts));
    } else if (page == HomeView.Remote) {
      return Container(key: ValueKey<HomeView>(HomeView.Remote));
    } else {
      return CardToggleFilter(key: ValueKey<HomeView>(HomeView.Home));
    }
  }
}
