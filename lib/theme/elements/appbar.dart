// ^ Home Screen Header ^ //
import 'dart:ui';
import '../theme.dart';

class DesignAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget leading;
  final Widget action;
  DesignAppBar({this.title, this.leading, this.action});
  @override
  Widget build(BuildContext context) {
    return CustomAnimatedWidget(
        enabled: true,
        duration: Duration(seconds: 20),
        curve: Curves.bounceInOut,
        builder: (context, percent) => ShapeContainer.ovalDown(
              height: 120,
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: RadialGradient(
                  colors: [
                    SonrPalette.Primary.withOpacity(0.5),
                    SonrPalette.Tertiary.withOpacity(0.5),
                    SonrPalette.Secondary.withOpacity(0.5),
                  ],
                  stops: [0.0, percent.clamp(0.1, 0.75), 1.0],
                  center: Alignment.topRight,
                  focal: Alignment.bottomLeft,
                  focalRadius: 1.5,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.1188, sigmaY: 5.1188),
                child: Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [leading ?? Container(), title ?? Container(), action ?? Container()],
                    )),
              ),
            ));
  }

  @override
  Size get preferredSize => Size(Get.width, 120);
}
