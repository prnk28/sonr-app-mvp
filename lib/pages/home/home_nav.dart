import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';

// ^ Home Tab Bar Navigation ^ //
class HomeBottomNavBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isBottomBarVisible.value
        ? Stack(children: [
            Neumorphic(
              style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.path(BottomBarPath()),
                  depth: UserService.isDarkMode ? 4 : 8,
                  color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
                  intensity: UserService.isDarkMode ? 0.45 : 0.85,
                  surfaceIntensity: 0.6),
              child: Container(
                width: Get.width,
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NavButton(HomeView.Grid, controller.setBottomIndex, controller.bottomIndex),
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
            ),
          ])
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
        child: Padding(
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
    return Obx(() => Container(
          padding: EdgeInsets.only(top: kToolbarHeight, bottom: 16),
          height: kToolbarHeight + 56,
          child: AnimatedSlideSwitcher.fade(
            duration: 2.seconds,
            child: GestureDetector(
              key: ValueKey<String>(controller.titleText.value),
              child: controller.titleText.value.h3,
              onTap: () {
                controller.swapTitleText("${LobbyService.localSize.value} Around", timeout: 2500.milliseconds);
              },
            ),
          ),
        ));
  }
}
