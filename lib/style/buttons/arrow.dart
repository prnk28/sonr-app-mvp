import 'package:sonr_app/style/style.dart';

import 'utility.dart';

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
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(color: AppTheme.ForegroundColor, borderRadius: BorderRadius.circular(12)),
                  child: SimpleIcons.Menu.icon(size: 28, color: AppTheme.GreyColor),
                ),
              ),
            ),
        false.obs);
  }
}
