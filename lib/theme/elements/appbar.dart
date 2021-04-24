// ^ Home Screen Header ^ //
import 'dart:ui';
import '../theme.dart';

class DesignAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Widget subtitle;
  final Widget leading;
  final Widget action;
  final bool centerTitle;
  DesignAppBar({
    @required this.title,
    this.leading,
    this.action,
    this.subtitle,
    Key key,
    this.centerTitle = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 28.0),
      child: NavigationToolbar(
        centerMiddle: centerTitle,
        leading: leading,
        trailing: action != null ? action : Container(width: 56, height: 56),
        middle: AnimatedSlideSwitcher.fade(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              subtitle != null ? subtitle : Container(),
              title,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 64);
}
