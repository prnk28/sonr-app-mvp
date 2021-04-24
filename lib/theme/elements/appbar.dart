// ^ Home Screen Header ^ //
import 'dart:ui';
import '../theme.dart';

class DesignAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget subtitle;
  final Widget leading;
  final Widget action;
  DesignAppBar({@required this.title, this.leading, this.action, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 28.0),
      child: NavigationToolbar(
        leading: leading,
        trailing: action != null ? action : Container(width: 56, height: 56),
        middle: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [subtitle ?? subtitle, title],
        ),
        centerMiddle: false,
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 64);
}
