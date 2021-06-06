import 'package:sonr_app/style.dart';

class ActionButton extends StatelessWidget {
  /// Function called on Tap Up
  final Function onPressed;

  /// Widget for Action Icon: Max Size 32
  final IconData iconData;

  /// String for Text Below Button
  final String? label;

  const ActionButton({Key? key, required this.onPressed, required this.iconData, this.label}) : super(key: key);
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
              onTapUp: (details) {
                isPressed(false);
                onPressed();
              },
              child: AnimatedScale(
                scale: isPressed.value ? 1.2 : 1.0,
                child: Container(
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
