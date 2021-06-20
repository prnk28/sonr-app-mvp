import 'package:sonr_app/style.dart';

import 'utility.dart';

class ImageButton extends StatelessWidget {
  /// Function called on Tap Up
  final Function onPressed;

  /// Widget for Action Icon: Max Size 32
  final String path;

  /// String for Text Below Button
  final String label;

  /// Current Image Fit
  final BoxFit imageFit;

  /// Button Image Width
  final double imageWidth;

  /// Button Image Height
  final double imageHeight;

  /// Circle Size
  final double circleSize;

  /// Text Label Size
  final double fontSize;

  /// Text Label Color
  final Color? textColor;

  const ImageButton({
    Key? key,
    required this.onPressed,
    required this.path,
    required this.label,
    this.circleSize = 110,
    this.imageFit = BoxFit.contain,
    this.imageWidth = 100,
    this.imageHeight = 100,
    this.fontSize = 20,
    this.textColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 160, maxWidth: 160),
      child: Column(
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
                          width: circleSize,
                          height: circleSize,
                          decoration: BoxDecoration(
                            color: SonrTheme.foregroundColor,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(24),
                        ),
                      ),
                      AnimatedScale(
                        scale: isPressed.value ? 1.1 : 1.0,
                        child: Container(
                          width: imageWidth,
                          height: imageHeight,
                          child: Image.asset(
                            path,
                            fit: imageFit,
                          ),
                        ),
                      )
                    ],
                  )),
              false.obs),

          // Build Label
          UserService.isDarkMode
              ? label.light(
                  color: textColor ?? SonrColor.White.withOpacity(0.8),
                  fontSize: fontSize,
                )
              : label.light(
                  color: textColor ?? SonrColor.Black.withOpacity(0.8),
                  fontSize: fontSize,
                ),
        ],
      ),
    );
  }
}
