import '../style.dart';
import 'utility.dart';

class ColorButton extends StatelessWidget {
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget child;
  final Decoration decoration;
  final Function onPressed;
  final Function? onLongPressed;
  final String? tooltip;
  final bool isEnabled;
  final bool isPrimary;
  final double? width;
  final double pressedScale;

  ColorButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.decoration,
    required this.pressedScale,
    this.margin,
    this.padding,
    this.onLongPressed,
    this.tooltip,
    this.isEnabled = true,
    this.width,
    this.isPrimary = false,
  }) : super(key: key);

  // @ Primary Button //
  factory ColorButton.primary({
    required Function onPressed,
    Function? onLongPressed,
    Widget? child,
    String? tooltip,
    EdgeInsets? padding,
    EdgeInsets? margin,
    UIIcons? uiIcon,
    IconData? icon,
    double? gradientRadius,
    String? text,
    double? width,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Build Child
    return ColorButton(
        decoration: BoxDecoration(
            gradient: AppGradients.Primary(radius: gradientRadius ?? 2.5),
            borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
            boxShadow: AppTheme.RectBoxShadow),
        onPressed: onPressed,
        child: ButtonUtility.buildChild(iconPosition, icon, text, child ),
        tooltip: tooltip,
        width: width,
        margin: margin,
        isPrimary: true,
        onLongPressed: onLongPressed,
        pressedScale: 0.95);
  }

  // @ Secondary Button //
  factory ColorButton.secondary({
    required Function onPressed,
    Color? color,
    Function? onLongPressed,
    Widget? child,
    String? tooltip,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    IconData? icon,
    String? text,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Build Child
    return ColorButton(
        decoration: BoxDecoration(
          color: color != null ? color : AppColor.AccentPurple,
          borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
        ),
        onPressed: onPressed,
        width: width,
        child: ButtonUtility.buildChild(iconPosition, icon, text, child),
        tooltip: tooltip,
        margin: margin,
        onLongPressed: onLongPressed,
        pressedScale: 0.98);
  }

  // @ Neutral Button //
  factory ColorButton.neutral({
    required Function onPressed,
    Function? onLongPressed,
    EdgeInsets? padding,
    Color? textColor,
    Color? borderColor,
    EdgeInsets? margin,
    double? width,
    required String text,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Build Child
    return ColorButton(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
            border: Border.all(width: 2, color: borderColor ?? Color(0xffE7E7E7))),
        onPressed: onPressed,
        width: width,
        child: ButtonUtility.buildNeutralText(text, textColor),
        padding: padding,
        onLongPressed: onLongPressed,
        pressedScale: 0.98);
  }

  @override
  Widget build(BuildContext context) {
    final RxBool isPressed = false.obs;
    return Material(
      type: MaterialType.transparency,
      child: Container(
          child: ObxValue<RxBool>(
              (pressed) => GestureDetector(
                  onTapCancel: () => pressed(false),
                  onLongPressStart: (details) => pressed(true),
                  onLongPressUp: () async {
                    pressed(false);
                    await HapticFeedback.heavyImpact();
                    Future.delayed(ButtonUtility.K_BUTTON_DURATION, () {
                      if (onLongPressed != null) {
                        onLongPressed!();
                      }
                    });
                  },
                  onTapDown: (detail) => pressed(true),
                  onTapUp: (details) async {
                    pressed(false);
                    await HapticFeedback.mediumImpact();
                    Future.delayed(ButtonUtility.K_BUTTON_DURATION, () {
                      onPressed();
                    });
                  },
                  child: AnimatedScale(
                      scale: pressed.value ? pressedScale : 1.0,
                      duration: 300.milliseconds,
                      child: AnimatedContainer(
                          decoration: decoration,
                          duration: ButtonUtility.K_BUTTON_DURATION,
                          curve: Curves.ease,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: isPrimary ? 6 : 12),
                          child: child))),
              isPressed)),
    );
  }
}
