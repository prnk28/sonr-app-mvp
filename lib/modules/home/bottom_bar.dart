import 'package:sonr_app/modules/home/share_button.dart';
import 'package:sonr_app/theme/theme.dart';

import 'home_controller.dart';

class HomeBottomNavBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
              NavButton.bottom(BottomNavButton.Grid, controller.setBottomIndex, controller.bottomIndex),
              NavButton.bottom(BottomNavButton.Profile, controller.setBottomIndex, controller.bottomIndex),
              Container(
                width: Get.width * 0.20,
              ),
              NavButton.bottom(BottomNavButton.Alerts, controller.setBottomIndex, controller.bottomIndex),
              NavButton.bottom(BottomNavButton.Remote, controller.setBottomIndex, controller.bottomIndex),
            ],
          ),
        ),
      ),
      Obx(() => Center(
            heightFactor: controller.shareState.value == ShareButtonState.Expanded ? 0.2 : 0.6,
            child: ShareButton(),
          ))
    ]);
  }
}

class BottomBarPath extends NeumorphicPathProvider {
  @override
  Path getPath(Size size) {
    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    return path;
  }

  @override
  bool get oneGradientPerPath => true;
}
