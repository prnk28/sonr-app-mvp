import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'color.dart';
import 'icon.dart';
import 'text.dart';

enum HapticFeedbackType { Light, Medium, Heavy, Selection }
enum IconPosition { Left, Right, Top, Bottom, Only }

class SonrButton extends StatelessWidget {
  final bool hasIcon;
  final SonrText text;
  final Color color;
  final Widget icon;
  final IconPosition iconPosition;
  final EdgeInsets margin;
  final NeumorphicShape shape;
  final double depth;
  final double intensity;
  final Function onPressed;
  final HapticFeedbackType feedbackType;
  final NeumorphicBoxShape boxShape;

  // * Constructer * //
  const SonrButton(
      this.hasIcon,
      this.text,
      this.color,
      this.margin,
      this.shape,
      this.depth,
      this.intensity,
      this.boxShape,
      this.onPressed,
      this.feedbackType,
      {this.icon,
      this.iconPosition,
      Key key})
      : super(key: key);

  // * Rectangle Button * //
  factory SonrButton.rectangle(SonrText text, Function onPressed,
      {EdgeInsets margin = EdgeInsets.zero,
      SonrIcon icon,
      Color color = K_BASE_COLOR,
      NeumorphicShape shape = NeumorphicShape.concave,
      double radius = 20,
      double intensity = 0.85,
      IconPosition iconPosition = IconPosition.Left,
      HapticFeedbackType haptic = HapticFeedbackType.Light}) {
    if (icon != null) {
      return SonrButton(
          true,
          text,
          color,
          margin,
          shape,
          8,
          intensity,
          NeumorphicBoxShape.roundRect(BorderRadius.circular(radius)),
          onPressed,
          haptic,
          icon: icon,
          iconPosition: iconPosition);
    } else {
      return SonrButton(
          false,
          text,
          color,
          margin,
          shape,
          8,
          intensity,
          NeumorphicBoxShape.roundRect(BorderRadius.circular(radius)),
          onPressed,
          haptic);
    }
  }

  // * Rectangle Button * //
  factory SonrButton.circle(SonrText text, Function onPressed,
      {SonrIcon icon,
      double intensity = 0.85,
      EdgeInsets margin = EdgeInsets.zero,
      IconPosition iconPosition = IconPosition.Left,
      HapticFeedbackType haptic = HapticFeedbackType.Light}) {
    if (icon != null) {
      return SonrButton(true, text, K_BASE_COLOR, margin, NeumorphicShape.flat,
          8, intensity, NeumorphicBoxShape.circle(), onPressed, haptic,
          icon: icon, iconPosition: iconPosition);
    } else {
      return SonrButton(false, text, K_BASE_COLOR, margin, NeumorphicShape.flat,
          8, intensity, NeumorphicBoxShape.circle(), onPressed, haptic);
    }
  }

  // * Rectangle Button * //
  factory SonrButton.appBar(SonrIcon icon, Function onPressed,
      {double intensity = 0.85}) {
    return SonrButton(
        true,
        null,
        K_BASE_COLOR,
        EdgeInsets.zero,
        NeumorphicShape.flat,
        8,
        intensity,
        NeumorphicBoxShape.circle(),
        onPressed,
        HapticFeedbackType.Medium,
        icon: icon,
        iconPosition: IconPosition.Only);
  }

  // * Accept Menu Button * //
  static Widget accept(Function onPressed,
      {Alignment alignment = Alignment.topLeft,
      double padTop = 14,
      double padRight = 5,
      double padLeft = 14,
      double padBottom = 5}) {
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
                style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.circle(),
                    color: K_BASE_COLOR,
                    shape: NeumorphicShape.flat,
                    depth: 8),
                child: SonrIcon.gradient(
                    Icons.check, FlutterGradientNames.newLife),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onPressed();
                })));
  }

  // * Close Menu Button * //
  static Widget close(Function onPressed,
      {Alignment alignment = Alignment.topRight,
      double padTop = 14,
      double padRight = 14,
      double padLeft = 5,
      double padBottom = 5}) {
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
                style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.circle(),
                    color: K_BASE_COLOR,
                    shape: NeumorphicShape.flat,
                    depth: 8),
                child: SonrIcon.gradient(
                  Icons.close,
                  FlutterGradientNames.phoenixStart,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onPressed();
                })));
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
        onPressed: () {
          _getHapticFeedback();
          onPressed();
        },
        margin: margin,
        style: NeumorphicStyle(
            depth: depth,
            color: color,
            boxShape: boxShape,
            intensity: intensity),
        padding: const EdgeInsets.all(12.0),
        child: hasIcon ? _buildIconView() : text);
  }

  _buildIconView() {
    switch (iconPosition) {
      case IconPosition.Left:
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [icon, text]);
        break;
      case IconPosition.Right:
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [text, icon]);
        break;
      case IconPosition.Top:
        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [icon, text]);
        break;
      case IconPosition.Bottom:
        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [text, icon]);
        break;
      case IconPosition.Only:
        return icon;
        break;
    }
    return Container();
  }

  _getHapticFeedback() {
    switch (feedbackType) {
      case HapticFeedbackType.Light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.Medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.Heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.Selection:
        HapticFeedback.selectionClick();
        break;
    }
  }
}
