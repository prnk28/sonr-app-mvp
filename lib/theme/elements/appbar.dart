import 'dart:ui';
import '../theme.dart';

// ^ Home Screen Header ^ //
class DesignAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const draggableChannel = MethodChannel('io.sonr.desktop/window');
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
    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      child: Container(
        padding: const EdgeInsets.only(left: 14.0, right: 14, top: 28.0),
        child: NavigationToolbar(
          centerMiddle: centerTitle,
          leading: leading,
          trailing: _buildTrailing(),
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
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 64);

  // Handles Drag Update for Desktop Build
  void onPanUpdate(DragUpdateDetails details) async {
    if (DeviceService.isDesktop) {
      await draggableChannel.invokeMethod('onPanUpdate');
    }
  }

  // Handles Drag Start for Desktop Build
  void onPanStart(DragStartDetails details) async {
    if (DeviceService.isDesktop) {
      await draggableChannel.invokeMethod('onPanStart', {"dx": details.globalPosition.dx, "dy": details.globalPosition.dy});
    }
  }

  Widget _buildTrailing() {
    if (DeviceService.isDesktop) {
      return PlainIconButton(icon: SonrIcons.Close.greyWith(size: 32), onPressed: () async => await draggableChannel.invokeMethod("onClose"));
    } else {
      return action != null ? action : Container(width: 56, height: 56);
    }
  }
}
