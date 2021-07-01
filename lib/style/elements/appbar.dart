import 'dart:ui';
import '../style.dart';

/// @ Home Screen Header
class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Appears below Subtitle with Bold Font
  final Widget title;

  /// Appears above Title with Light Font
  final Widget? subtitle;
  final Widget? leading;
  final Widget? action;
  final Widget? secondAction;
  final bool centerTitle;
  PageAppBar({
    required this.title,
    this.leading,
    this.action,
    this.subtitle,
    Key? key,
    this.centerTitle = false,
    this.secondAction,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.only(left: 14.0, right: 14, top: 28.0),
        child: NavigationToolbar(
          centerMiddle: centerTitle,
          leading: _buildLeading(),
          trailing: _buildTrailing(),
          middle: AnimatedSlider.fade(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                subtitle != null ? subtitle! : Container(),
                title,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 64);

  Widget _buildTrailing() {
    if (action != null && secondAction != null) {
      return Container(
          width: 94,
          child: Row(
            children: [action!, secondAction!],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ));
    } else if (action != null && secondAction == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          action!,
        ],
      );
    } else {
      return Container(width: 32, height: 32);
    }
  }

  Widget? _buildLeading() {
    if (leading != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          leading!,
        ],
      );
    } else {
      return null;
    }
  }
}

/// @ Home Screen Header
class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Appears below Subtitle with Bold Font
  final String title;
  final Function() onPressed;

  /// Appears above Title with Light Font
  final bool isClose;
  final Widget? action;
  DetailAppBar({
    required this.onPressed,
    required this.title,
    this.isClose = false,
    this.action,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 14),
          padding: EdgeInsets.only(top: 24, bottom: 24),
          child: NavigationToolbar(
            centerMiddle: false,
            leading: ActionButton(
              onPressed: onPressed,
              iconData: isClose ? SonrIcons.Close : SonrIcons.Back,
            ),
            trailing: _buildTrailing(),
            middle: title.toUpperCase().light(color: AppTheme.itemColor, fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 32);

  Widget _buildTrailing() {
    return action != null ? action! : Container(width: 32, height: 32);
  }
}
