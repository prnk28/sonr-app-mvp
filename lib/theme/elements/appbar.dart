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
    if (leading == null) {
      return Padding(
        padding: const EdgeInsets.only(left: 48.0),
        child: NavigationToolbar(
          leading: title,
          trailing: action ?? Container(),
          middleSpacing: 0,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: NavigationToolbar(
          leading: leading,
          trailing: action,
          middle: title,
        ),
      );
    }
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 16);
}
