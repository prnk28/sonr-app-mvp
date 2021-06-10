import 'package:sonr_app/style.dart';

import 'utility.dart';

class ActionButton extends StatelessWidget {
  /// Function called on Tap Up
  final Function onPressed;

  /// Widget for Action Icon: Max Size 32
  final IconData iconData;

  /// String for Text Below Button
  final String? label;

  /// Integer for Banner Label
  final ActionBanner? banner;

  const ActionButton({Key? key, required this.onPressed, required this.iconData, this.label, this.banner}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return Container(
        constraints: BoxConstraints(maxHeight: 40, maxWidth: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ActionIconButton(onPressed, iconData),
            label!.light(color: Get.theme.hintColor),
          ],
        ),
      );
    }

    if (banner != null) {
      return Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _ActionIconButton(onPressed, iconData),
            Positioned(
              right: 28,
              top: 28,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 28),
                decoration: banner!.decoration(),
                child: banner!.text(),
              ),
            ),
          ],
        ),
      );
    }
    return _ActionIconButton(onPressed, iconData);
  }
}

class _ActionIconButton extends StatelessWidget {
  /// Function called on Tap Up
  final Function onPressed;

  /// Widget for Action Icon: Max Size 32
  final IconData iconData;
  const _ActionIconButton(this.onPressed, this.iconData, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObxValue<RxBool>(
        (isPressed) => GestureDetector(
              onTapDown: (details) => isPressed(true),
              onTapCancel: () => isPressed(false),
              onTapUp: (details) async {
                isPressed(false);
                await HapticFeedback.mediumImpact();
                Future.delayed(ButtonUtility.K_BUTTON_DURATION, () {
                  onPressed();
                });
              },
              child: AnimatedScale(
                scale: isPressed.value ? 1.2 : 1.0,
                child: Container(
                  constraints: BoxConstraints.tight(Size(40, 40)),
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: UserService.isDarkMode ? SonrTheme.foregroundColor : Color(0xffEAEAEA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    iconData,
                    color: SonrTheme.textColor,
                    size: 24,
                  ),
                ),
              ),
            ),
        false.obs);
  }
}

/// Class Manages ActionBanner for ActionButton
class ActionBanner {
  /// Count for Banner
  final int count;

  /// Color of Banner Background
  final Color bannerColor;

  /// Color of Banner Text
  final Color textColor;

  ActionBanner(this.count, this.bannerColor, this.textColor);

  /// Build Alert Style Banner
  factory ActionBanner.alert(int count) {
    return ActionBanner(count, SonrColor.AccentPink, SonrTheme.textColor);
  }

  /// Build Selected Items Banner
  factory ActionBanner.selected(int count) {
    return ActionBanner(count, SonrColor.AccentBlue, SonrTheme.textColor);
  }

  /// Helper: Builds BoxDecoration from Banner Data
  BoxDecoration decoration() {
    return BoxDecoration(shape: BoxShape.circle, color: bannerColor);
  }

  /// Helper: Builds Text from Banner Data
  Widget text() {
    return count.toString().section(fontSize: 16, color: textColor);
  }
}
