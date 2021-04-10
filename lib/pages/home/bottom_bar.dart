import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';

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
                    NavButton(BottomNavButton.Grid, controller.setBottomIndex, controller.bottomIndex),
                    NavButton(BottomNavButton.Profile, controller.setBottomIndex, controller.bottomIndex),
                    Container(
                      width: Get.width * 0.20,
                    ),
                    NavButton(BottomNavButton.Alerts, controller.setBottomIndex, controller.bottomIndex),
                    NavButton(BottomNavButton.Remote, controller.setBottomIndex, controller.bottomIndex),
                  ],
                ),
              ),
            ),

          ])
        : Container());
  }
}
