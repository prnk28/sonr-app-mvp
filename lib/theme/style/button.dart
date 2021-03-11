import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_app/service/device_service.dart';
import 'style.dart';

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
  final Function onLongPressed;
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
    this.onLongPressed,
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
      Function onLongPressed,
      SonrText text,
      SonrIcon icon,
      Color shadowLightColor,
      Color shadowDarkColor,
      Color color = SonrColor.White,
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
        onLongPressed: onLongPressed,
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
        text,
        color,
        margin,
        shape,
        intensity,
        depth,
        NeumorphicBoxShape.roundRect(BorderRadius.circular(radius)),
        onPressed,
        onLongPressed: onLongPressed,
        icon: icon,
        iconPosition: WidgetPosition.Center,
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
        onLongPressed: onLongPressed,
        type: type,
        padding: padding,
      );
    }
  }

  // * Flat Button * //
  factory SonrButton.flat({
    @required Function onPressed,
    Function onLongPressed,
    SonrText text,
    SonrIcon icon,
    Color color = SonrColor.White,
    bool isDisabled = false,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Icon AND Text
    if (icon != null && text != null) {
      var type = isDisabled ? _ButtonType.DisabledIconText : _ButtonType.IconText;
      return SonrButton(
        true,
        text,
        color,
        const EdgeInsets.all(0),
        NeumorphicShape.flat,
        0,
        0,
        NeumorphicBoxShape.rect(),
        onPressed,
        onLongPressed: onLongPressed,
        icon: icon,
        iconPosition: iconPosition,
        type: type,
      );
    }
    // Icon ONLY
    else if (icon != null && text == null) {
      var type = isDisabled ? _ButtonType.DisabledIcon : _ButtonType.Icon;
      return SonrButton(
        true,
        text,
        color,
        const EdgeInsets.all(0),
        NeumorphicShape.flat,
        0,
        0,
        NeumorphicBoxShape.rect(),
        onPressed,
        onLongPressed: onLongPressed,
        icon: icon,
        iconPosition: WidgetPosition.Center,
        type: type,
      );
    }
    // TEXT ONLY
    else {
      var type = isDisabled ? _ButtonType.DisabledText : _ButtonType.Text;
      return SonrButton(
        false,
        text,
        color,
        const EdgeInsets.all(0),
        NeumorphicShape.flat,
        0,
        0,
        NeumorphicBoxShape.rect(),
        onPressed,
        onLongPressed: onLongPressed,
        type: type,
      );
    }
  }

  // * Circle Style Button * //
  factory SonrButton.circle({
    @required Function onPressed,
    Function onLongPressed,
    SonrIcon icon,
    SonrText text,
    Color shadowLightColor,
    Color shadowDarkColor,
    Color color = SonrColor.White,
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
        onLongPressed: onLongPressed,
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
        onLongPressed: onLongPressed,
        icon: icon,
        iconPosition: WidgetPosition.Center,
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
        onLongPressed: onLongPressed,
        type: type,
        padding: padding,
      );
    }
  }

  // * Stadium Style Button * //
  factory SonrButton.stadium({
    Function onPressed,
    Function onLongPressed,
    SonrIcon icon,
    SonrText text,
    Color shadowLightColor,
    Color shadowDarkColor,
    Color color = SonrColor.White,
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
        onLongPressed: onLongPressed,
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
        onLongPressed: onLongPressed,
        iconPosition: WidgetPosition.Center,
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
        onLongPressed: onLongPressed,
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
        iconChild = SonrIcon.normal(icon.data, size: icon.size, color: SonrColor.Grey);
        isDisabled = true;
        break;
      case _ButtonType.DisabledText:
        textChild = SonrText.medium(text.text, size: text.size, color: SonrColor.Grey);
        isDisabled = true;
        break;
      case _ButtonType.DisabledIconText:
        iconChild = SonrIcon.normal(icon.data, size: icon.size, color: SonrColor.Grey);
        textChild = SonrText.medium(text.text, size: text.size, color: SonrColor.Grey);
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
        margin: margin,
        style: NeumorphicStyle(
          depth: DeviceService.isDarkMode.value ? 4 : 8,
          color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
          boxShape: boxShape,
          intensity: DeviceService.isDarkMode.value ? 0.6 : 0.85,
        ),
        padding: const EdgeInsets.all(12.0),
        onPressed: () {
          if (onPressed != null) {
            HapticFeedback.mediumImpact();
            onPressed();
          }
        },
        child: GestureDetector(
          onLongPress: () {
            if (onLongPressed != null) {
              HapticFeedback.heavyImpact();
              onLongPressed();
            }
          },
          child: hasIcon ? _buildIconView(iconChild, textChild) : textChild,
        ),
      );
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
}
