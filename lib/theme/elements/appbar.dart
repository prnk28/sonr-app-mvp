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
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 28.0),
      child: NavigationToolbar(
        leading: leading,
        trailing: action,
        middle: title,
        centerMiddle: false,
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 64);
}
