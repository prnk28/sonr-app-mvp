import 'package:sonr_app/style.dart';

import 'utility.dart';

class ArrowButton extends StatelessWidget {
  final String title;
  final Function() onPressed;

  const ArrowButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);
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
                scale: isPressed.value ? 0.9 : 1.0,
                child: Container(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      title.toUpperCase().light(fontSize: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0, left: 4),
                        child: SonrIcons.Down.icon(size: 16, color: SonrTheme.itemColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        false.obs);
  }
}
