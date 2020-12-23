import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'color.dart';
import 'icon.dart';
import 'text.dart';

NeumorphicButton rectangleButton(String text, Function onPressed,
    {NeumorphicShape shape = NeumorphicShape.concave}) {
  return NeumorphicButton(
      onPressed: onPressed,
      style: NeumorphicStyle(
          depth: 8,
          color: K_BASE_COLOR,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
      padding: const EdgeInsets.all(12.0),
      child: SonrText.normal(text));
}

Widget closeButton(Function onPressed,
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
              onPressed: onPressed)));
}

Widget acceptButton(Function onPressed,
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
                  Icons.check, FlutterGradientNames.hiddenJaguar),
              onPressed: onPressed)));
}
