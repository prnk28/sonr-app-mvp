import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_app/service/user.dart';
import '../theme.dart';

enum _ButtonType { Icon, Text, IconText, DisabledIcon, DisabledText, DisabledIconText }

class ShapeButton extends StatelessWidget {
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
  final Widget child;

  // * Constructer * //
  const ShapeButton(
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
    this.child,
  });

  // * Rectangle Button * //
  factory ShapeButton.rectangle(
      {@required Function onPressed,
      Function onLongPressed,
      Widget text,
      Widget child,
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
    // Child Provided
    if (child != null) {
      return ShapeButton(
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
        child: child,
        padding: padding,
      );
    } else {
      // Icon AND Text
      if (icon != null && text != null) {
        var type = isDisabled ? _ButtonType.DisabledIconText : _ButtonType.IconText;
        return ShapeButton(
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
        return ShapeButton(
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
        return ShapeButton(
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
  }

  // * Flat Button * //
  factory ShapeButton.flat({
    @required Function onPressed,
    Function onLongPressed,
    Widget text,
    Widget child,
    SonrIcon icon,
    Color color = SonrColor.White,
    bool isDisabled = false,
    WidgetPosition iconPosition = WidgetPosition.Left,
  }) {
    // Child Provided
    if (child != null) {
      return ShapeButton(
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
        child: child,
      );
    } else {
      // Icon AND Text
      if (icon != null && text != null) {
        var type = isDisabled ? _ButtonType.DisabledIconText : _ButtonType.IconText;
        return ShapeButton(
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
        return ShapeButton(
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
        return ShapeButton(
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
  }

  // * Circle Style Button * //
  factory ShapeButton.circle({
    @required Function onPressed,
    Function onLongPressed,
    SonrIcon icon,
    Widget text,
    Widget child,
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
    // Child Provided
    if (child != null) {
      return ShapeButton(
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
        child: child,
        padding: padding,
      );
    } else {
      // Icon AND Text
      if (icon != null && text != null) {
        var type = isDisabled ? _ButtonType.DisabledIconText : _ButtonType.IconText;
        return ShapeButton(
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
        return ShapeButton(
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
        return ShapeButton(
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
  }

  // * Stadium Style Button * //
  factory ShapeButton.stadium({
    @required Function onPressed,
    Function onLongPressed,
    SonrIcon icon,
    Widget text,
    Widget child,
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
    // Child Provided
    if (child != null) {
      return ShapeButton(
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
        child: child,
        padding: padding,
      );
    } else {
      // Icon AND Text
      if (icon != null && text != null) {
        var type = isDisabled ? _ButtonType.DisabledIconText : _ButtonType.IconText;
        return ShapeButton(
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
        return ShapeButton(
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
        return ShapeButton(
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
  }

  @override
  Widget build(BuildContext context) {
    // If Child Provided
    if (child != null) {
      return NeumorphicButton(
        margin: margin,
        style: NeumorphicStyle(
          depth: UserService.isDarkMode ? 4 : 8,
          color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
          boxShape: boxShape,
          intensity: UserService.isDarkMode ? 0.6 : 0.85,
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
          child: Container(child: child),
        ),
      );
    }
    // If Child Not Provided
    else {
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
          textChild = text.text.h6_Grey;
          isDisabled = true;
          break;
        case _ButtonType.DisabledIconText:
          iconChild = SonrIcon.normal(icon.data, size: icon.size, color: SonrColor.Grey);
          textChild = text.text.h6_Grey;
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
        var child = Container(child: hasIcon ? _buildIconView(iconChild, textChild) : textChild);
        return NeumorphicButton(
          onPressed: () {
            HapticFeedback.lightImpact();
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
            depth: UserService.isDarkMode ? 4 : 8,
            color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
            boxShape: boxShape,
            intensity: UserService.isDarkMode ? 0.6 : 0.85,
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
