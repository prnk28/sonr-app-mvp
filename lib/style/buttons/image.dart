import 'package:sonr_app/style/style.dart';

import 'utility.dart';

class ImageButton extends StatelessWidget {
  /// Function called on Tap Up
  final Function onPressed;

  /// Widget for Action Icon: Max Size 32
  final ComplexIcons icon;

  /// String for Text Below Button
  final String label;

  /// Circle Size
  final double size;

  /// Text Label Size
  final double fontSize;

  /// Text Label Color
  final Color? textColor;

  const ImageButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.size = 100,
    this.fontSize = 20,
    this.textColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ObxValue<RxBool>(
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedScale(
                        scale: isPressed.value ? 0.9 : 1.0,
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            color: AppTheme.ForegroundColor,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(24),
                        ),
                      ),
                      AnimatedScale(
                        scale: isPressed.value ? 1.1 : 1.0,
                        child: icon.dots(
                          width: size * 0.5,
                          height: size * 0.5,
                        ),
                      )
                    ],
                  )),
              false.obs),

          // Build Label
          Get.isDarkMode
              ? label.light(
                  color: textColor ?? AppColor.White.withOpacity(0.8),
                  fontSize: fontSize,
                )
              : label.light(
                  color: textColor ?? AppColor.Black.withOpacity(0.8),
                  fontSize: fontSize,
                ),
        ],
      ),
    );
  }
}
