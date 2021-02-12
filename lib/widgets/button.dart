import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../theme/theme.dart';

enum _ButtonType { Icon, Text, IconText, DisabledIcon, DisabledText, DisabledIconText }
enum WidgetPosition { Left, Right, Top, Bottom, Center }
final kTopLeftButton = EdgeInsets.only(top: 14, right: 14, left: 5, bottom: 5);
final kTopRightButton = EdgeInsets.only(top: 14, right: 5, left: 14, bottom: 5);

class SonrButton extends StatelessWidget {
  final bool hasIcon;
  final _ButtonType type;
  final SonrText text;
  final Color color;
  final Color shadowLightColor;
  final Color shadowDarkColor;
  final SonrIcon icon;
  final WidgetPosition iconPosition;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final NeumorphicShape shape;
  final double intensity;
  final Function onPressed;
  final NeumorphicBoxShape boxShape;
  final double depth;

  // * Constructer * //
  const SonrButton(
    this.hasIcon,
    this.text,
    this.color,
    this.margin,
    this.shape,
    this.intensity,
    this.depth,
    this.boxShape,
    this.onPressed, {
    this.icon,
    this.iconPosition,
    Key key,
    this.shadowLightColor,
    this.shadowDarkColor,
    this.type,
    this.padding,
  });

  // * Rectangle Button * //
  factory SonrButton.rectangle(
      {@required Function onPressed,
      SonrText text,
      SonrIcon icon,
      Color shadowLightColor,
      Color shadowDarkColor,
      Color color = K_BASE_COLOR,
      double depth = 8,
      double radius = 20,
      double intensity = 0.85,
      bool isDisabled = false,
      EdgeInsets margin = EdgeInsets.zero,
      NeumorphicShape shape = NeumorphicShape.concave,
      WidgetPosition iconPosition = WidgetPosition.Left,
      EdgeInsets padding = EdgeInsets.zero}) {
    // Icon AND Text
    if (icon != null && text != null) {
      var type = isDisabled ? _ButtonType.DisabledIconText : _ButtonType.IconText;
      return SonrButton(
        true,
        text,
        color,
        margin,
        shape,
        intensity,
        depth,
        NeumorphicBoxShape.roundRect(BorderRadius.circular(radius)),
        onPressed,
        icon: icon,
        iconPosition: iconPosition,
        shadowDarkColor: shadowDarkColor,
        shadowLightColor: shadowLightColor,
        type: type,
        padding: padding,
      );
    }
    // Icon ONLY
    else if (icon != null && text == null) {
      var type = isDisabled ? _ButtonType.DisabledIcon : _ButtonType.Icon;
      return SonrButton(
        true,
        text,
        color,
        margin,
        shape,
        intensity,
        depth,
        NeumorphicBoxShape.roundRect(BorderRadius.circular(radius)),
        onPressed,
        icon: icon,
        iconPosition: WidgetPosition.Center,
        shadowDarkColor: shadowDarkColor,
        shadowLightColor: shadowLightColor,
        type: type,
        padding: padding,
      );
    }
    // TEXT ONLY
    else {
      var type = isDisabled ? _ButtonType.DisabledText : _ButtonType.Text;
      return SonrButton(
        false,
        text,
        color,
        margin,
        shape,
        intensity,
        depth,
        NeumorphicBoxShape.roundRect(BorderRadius.circular(radius)),
        onPressed,
        shadowDarkColor: shadowDarkColor,
        shadowLightColor: shadowLightColor,
        type: type,
        padding: padding,
      );
    }
  }

  // * Circle Style Button * //
  factory SonrButton.circle({
    @required Function onPressed,
    SonrIcon icon,
    SonrText text,
    Color shadowLightColor,
    Color shadowDarkColor,
    Color color = K_BASE_COLOR,
    bool isDisabled = false,
    double depth = 8,
    double intensity = 0.85,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    NeumorphicShape shape = NeumorphicShape.flat,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Icon AND Text
    if (icon != null && text != null) {
      var type = isDisabled ? _ButtonType.DisabledIconText : _ButtonType.IconText;
      return SonrButton(
        true,
        text,
        color,
        margin,
        shape,
        intensity,
        depth,
        NeumorphicBoxShape.circle(),
        onPressed,
        icon: icon,
        iconPosition: iconPosition,
        type: type,
        padding: padding,
      );
    }
    // Icon ONLY
    else if (icon != null && text == null) {
      var type = isDisabled ? _ButtonType.DisabledIcon : _ButtonType.Icon;
      return SonrButton(
        true,
        null,
        color,
        margin,
        shape,
        intensity,
        depth,
        NeumorphicBoxShape.circle(),
        onPressed,
        icon: icon,
        iconPosition: WidgetPosition.Center,
        shadowDarkColor: shadowDarkColor,
        shadowLightColor: shadowLightColor,
        type: type,
        padding: padding,
      );
    }
    // TEXT ONLY
    else {
      var type = isDisabled ? _ButtonType.DisabledText : _ButtonType.Text;
      return SonrButton(
        false,
        text,
        color,
        margin,
        shape,
        intensity,
        depth,
        NeumorphicBoxShape.circle(),
        onPressed,
        type: type,
        padding: padding,
      );
    }
  }

  // * Stadium Style Button * //
  factory SonrButton.stadium({
    @required Function onPressed,
    SonrIcon icon,
    SonrText text,
    Color shadowLightColor,
    Color shadowDarkColor,
    Color color = K_BASE_COLOR,
    bool isDisabled = false,
    double intensity = 0.85,
    double depth = 8,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    NeumorphicShape shape = NeumorphicShape.flat,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Icon AND Text
    if (icon != null && text != null) {
      var type = isDisabled ? _ButtonType.DisabledIconText : _ButtonType.IconText;
      return SonrButton(
        true,
        text,
        color,
        margin,
        shape,
        intensity,
        depth,
        NeumorphicBoxShape.stadium(),
        onPressed,
        icon: icon,
        iconPosition: iconPosition,
        type: type,
        padding: padding,
      );
    }
    // Icon ONLY
    else if (icon != null && text == null) {
      var type = isDisabled ? _ButtonType.DisabledIcon : _ButtonType.Icon;
      return SonrButton(
        true,
        null,
        color,
        margin,
        shape,
        intensity,
        depth,
        NeumorphicBoxShape.stadium(),
        onPressed,
        icon: icon,
        iconPosition: WidgetPosition.Center,
        shadowDarkColor: shadowDarkColor,
        shadowLightColor: shadowLightColor,
        type: type,
        padding: padding,
      );
    }
    // TEXT ONLY
    else {
      var type = isDisabled ? _ButtonType.DisabledText : _ButtonType.Text;
      return SonrButton(
        false,
        text,
        color,
        margin,
        shape,
        intensity,
        depth,
        NeumorphicBoxShape.stadium(),
        onPressed,
        type: type,
        padding: padding,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize
    bool isDisabled;
    var iconChild;
    var textChild;

    // Update Children
    switch (type) {
      case _ButtonType.DisabledIcon:
        iconChild = SonrIcon.normal(icon.data, size: icon.size, color: K_BUTTON_DISABLED);
        isDisabled = true;
        break;
      case _ButtonType.DisabledText:
        textChild = SonrText.normal(text.text, size: text.size, color: K_BUTTON_DISABLED);
        isDisabled = true;
        break;
      case _ButtonType.DisabledIconText:
        iconChild = SonrIcon.normal(icon.data, size: icon.size, color: K_BUTTON_DISABLED);
        textChild = SonrText.normal(text.text, size: text.size, color: K_BUTTON_DISABLED);
        isDisabled = true;
        break;
      default:
        iconChild = icon;
        textChild = text;
        isDisabled = false;
        break;
    }

    // Create View
    if (isDisabled) {
      var child = SonrAnimatedWidget.controlled(child: hasIcon ? _buildIconView(iconChild, textChild) : textChild);
      return NeumorphicButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          onPressed();
          child.animate(AnimType.Shake);
        },
        margin: margin,
        style: NeumorphicStyle(
          depth: 0,
          color: color,
          boxShape: boxShape,
          intensity: 0,
        ),
        padding: const EdgeInsets.all(12.0),
        child: child,
      );
    } else {
      return NeumorphicButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            onPressed();
          },
          margin: margin,
          style: NeumorphicStyle(
            depth: depth,
            color: color,
            boxShape: boxShape,
            intensity: intensity,
            shadowLightColor: shadowLightColor,
            shadowDarkColor: shadowDarkColor,
          ),
          padding: const EdgeInsets.all(12.0),
          child: hasIcon ? _buildIconView(iconChild, textChild) : textChild);
    }
  }

  _buildIconView(Widget iconWidget, Widget textWidget) {
    switch (iconPosition) {
      case WidgetPosition.Left:
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [iconWidget, textWidget]);
        break;
      case WidgetPosition.Right:
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [textWidget, iconWidget]);
        break;
      case WidgetPosition.Top:
        return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [iconWidget, textWidget]);
        break;
      case WidgetPosition.Bottom:
        return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [textWidget, iconWidget]);
        break;
      case WidgetPosition.Center:
        return iconWidget;
        break;
    }
    return Container();
  }

  // * Accept Menu Button * //
  static Widget accept(Function onPressed,
      {Alignment alignment = Alignment.topLeft, double padTop = 14, double padRight = 5, double padLeft = 14, double padBottom = 5}) {
    return Align(
        alignment: Alignment.topLeft,
        child: Padding(
            padding: EdgeInsets.only(
              top: padTop,
              right: padRight,
              left: padLeft,
              bottom: padBottom,
            ),
            child: NeumorphicButton(
                style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle(), color: K_BASE_COLOR, shape: NeumorphicShape.flat, depth: 8),
                child: SonrIcon.gradient(Icons.check, FlutterGradientNames.newLife),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onPressed();
                })));
  }

  // * Close Menu Button * //
  static Widget close(Function onPressed,
      {Alignment alignment = Alignment.topRight, double padTop = 14, double padRight = 14, double padLeft = 5, double padBottom = 5}) {
    return Align(
        alignment: Alignment.topLeft,
        child: Padding(
            padding: EdgeInsets.only(
              top: padTop,
              right: padRight,
              left: padLeft,
              bottom: padBottom,
            ),
            child: NeumorphicButton(
                style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle(), color: K_BASE_COLOR, shape: NeumorphicShape.flat, depth: 8),
                child: SonrIcon.gradient(
                  Icons.close,
                  FlutterGradientNames.phoenixStart,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onPressed();
                })));
  }
}
