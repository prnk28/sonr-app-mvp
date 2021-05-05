import 'package:sonr_app/style/style.dart';

class ActionButton extends StatelessWidget {
  /// Function called on Tap Up
  final Function onPressed;

  /// Widget for Action Icon: Max Size 32
  final Widget icon;

  /// String for Text Below Button
  final String label;

  /// Button Size: Menu Button = 56, Contact button = 72. Defaults to 56
  final double size;

  const ActionButton({Key key, @required this.onPressed, @required this.icon, this.size = 56, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return Container(
        constraints: BoxConstraints(maxHeight: 100, maxWidth: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ActionIconButton(onPressed, icon, size),
            label.h5_Grey,
          ],
        ),
      );
    }
    return _ActionIconButton(onPressed, icon, size);
  }
}

class _ActionIconButton extends StatelessWidget {
  /// Function called on Tap Up
  final Function onPressed;

  /// Widget for Action Icon: Max Size 32
  final Widget icon;

  /// Button Size: Menu Button = 56, Contact button = 72. Defaults to 56
  final double size;

  const _ActionIconButton(this.onPressed, this.icon, this.size, {Key key}) : super(key: key);
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
                  width: size,
                  height: size,
                  alignment: Alignment.center,
                  decoration: Neumorphic.floating(shape: BoxShape.circle),
                  child: icon,
                ),
              ),
            ),
        false.obs);
  }
}
