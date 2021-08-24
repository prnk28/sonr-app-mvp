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
                  duration: 300.milliseconds,
                  child: Container(
                    constraints: BoxConstraints.tight(Size(40, 40)),
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppGradients.Foreground,
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

/// ### ArrowButton
/// Text Button That Displays Arrow Next to It
/// Used for [InfoList] and [CheckList] Modals.
class ArrowButton extends StatelessWidget {
  /// Button Title to Display
  final String title;

  /// Action on Pressed
  final Function() onPressed;

  /// ### ArrowButton
  /// Displays TextButton with Arrow to Left
  const ArrowButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  /// ### ArrowButton (CheckList)
  /// Creates ArrowButton which Displays CheckList on Press
  factory ArrowButton.checkList({
    required List<ChecklistOption> options,
    required String title,
    required dynamic Function(int) onSelectedOption,
    Offset? offset,
  }) {
    final key = GlobalKey();
    return ArrowButton(
        title: title,
        key: key,
        onPressed: () {
          AppRoute.positioned(
            Checklist(
              options: options,
              onSelectedOption: onSelectedOption,
            ),
            offset: offset,
            parentKey: key,
          );
        });
  }

  /// ### ArrowButton (InfoList)
  /// Creates ArrowButton which Displays InfoList on Press
  factory ArrowButton.infoList({
    required List<InfolistOption> options,
    required String title,
    Offset? offset,
  }) {
    final key = GlobalKey();
    return ArrowButton(
        title: title,
        key: key,
        onPressed: () {
          AppRoute.positioned(
            Infolist(options: options),
            offset: offset,
            parentKey: key,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ObxValue<RxBool>(
        (isPressed) => GestureDetector(
              onTapDown: (details) {
                HapticFeedback.lightImpact();
                isPressed(true);
              },
              onTapCancel: () => isPressed(false),
              onTapUp: (details) async {
                isPressed(false);
                HapticFeedback.heavyImpact();
                Future.delayed(ButtonUtility.K_BUTTON_DURATION, () {
                  onPressed();
                });
              },
              child: AnimatedScale(
                scale: isPressed.value ? 0.9 : 1.0,
                duration: 300.milliseconds,
                child: Container(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      title.toUpperCase().light(fontSize: 20, color: AppTheme.ItemColor),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0, left: 4),
                        child: SimpleIcons.Down.icon(size: 16, color: AppTheme.ItemColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        false.obs);
  }
}

/// ### InfoButton
/// Text Button That Displays Info Icon Next to It
/// Used for [InfoList] Modals.
class InfoButton extends StatelessWidget {
  /// Action on Pressed
  final Function() onPressed;

  const InfoButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ObxValue<RxBool>(
        (isPressed) => GestureDetector(
              onTapDown: (details) {
                HapticFeedback.lightImpact();
                isPressed(true);
              },
              onTapCancel: () => isPressed(false),
              onTapUp: (details) async {
                isPressed(false);
                HapticFeedback.heavyImpact();
                Future.delayed(ButtonUtility.K_BUTTON_DURATION, () {
                  onPressed();
                });
              },
              child: AnimatedScale(
                scale: isPressed.value ? 0.9 : 1.0,
                duration: 300.milliseconds,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(color: AppTheme.ForegroundColor, borderRadius: BorderRadius.circular(12)),
                  child: UIIcons.Bell.line(width: 28, height: 28, color: AppTheme.GreyColor),
                ),
              ),
            ),
        false.obs);
  }
}
