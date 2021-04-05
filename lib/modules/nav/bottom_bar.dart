import 'package:sonr_app/theme/theme.dart';
import 'nav_button.dart';
import 'nav_controller.dart';
import 'share_button.dart';

class SonrBottomNavBar extends GetView<SonrNavController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(children: [
          Neumorphic(
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.path(BottomBarPath()),
              depth: UserService.isDarkMode ? 4 : 8,
              color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
              intensity: UserService.isDarkMode ? 0.45 : 0.85,
            ),
            child: Container(
              width: Get.width,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomBarButton(BottomBarButtonType.Home),
                  BottomBarButton(BottomBarButtonType.Profile),
                  Container(
                    width: Get.width * 0.20,
                  ),
                  BottomBarButton(BottomBarButtonType.Alerts),
                  BottomBarButton(BottomBarButtonType.Settings),
                ],
              ),
            ),
          ),
          Center(
            heightFactor: 0.6,
            child: BottomShareButton(),
          )
        ]));
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
