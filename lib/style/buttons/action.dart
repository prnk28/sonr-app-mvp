import 'package:sonr_app/style/style.dart';

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
      return SizedBox(
        width: 40,
        height: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ActionIconButton(onPressed, iconData),
            label!.light(color: Get.theme.hintColor, fontSize: 16),
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
            Positioned.directional(
              start: banner!.start,
              top: banner!.top,
              textDirection: banner!.textDirection,
              child: Container(
                width: banner!.width,
                height: banner!.height,
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
    return Container(
      child: ObxValue<RxBool>(
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
                      color: Preferences.isDarkMode ? AppTheme.ForegroundColor : Color(0xffEAEAEA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      iconData,
                      color: AppTheme.ItemColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
          false.obs),
    );
  }
}

/// Class Manages ActionBanner for ActionButton
class ActionBanner {
  /// Count for Banner
  final int value;
  ActionBanner(this.value);

  /// Return Banner Width
  double get width => value != -1 ? 18 : 8;

  /// Return Banner Height
  double get height => value != -1 ? 18 : 8;

  /// Return Banner Position Top
  double get top => value != -1 ? 28 : 4;

  /// Return Banner Position Start
  double get start => value != -1 ? 28 : 4;

  /// Return Banner Position TextDirection
  TextDirection get textDirection => value != -1 ? TextDirection.rtl : TextDirection.ltr;

  /// Build Alert Style Banner
  factory ActionBanner.alert() {
    return ActionBanner(-1);
  }

  /// Build Selected Items Banner
  factory ActionBanner.count(int count) {
    return ActionBanner(count);
  }

  /// Helper: Builds BoxDecoration from Banner Data
  BoxDecoration decoration() {
    return BoxDecoration(shape: BoxShape.circle, color: Color(0xffFF0057));
  }

  /// Helper: Builds Text from Banner Data
  Widget text() {
    return value.toString().subheading(fontSize: 14, color: Colors.white, align: TextAlign.center);
  }
}
