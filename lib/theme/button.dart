import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'icon.dart';
import 'text.dart';

NeumorphicButton rectangleButton(String text, Function onPressed,
    {NeumorphicShape shape = NeumorphicShape.concave}) {
  return NeumorphicButton(
      onPressed: onPressed,
      style: NeumorphicStyle(
          depth: 8,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
      padding: const EdgeInsets.all(12.0),
      child: normalText(text));
}

Widget closeButton(Function onPressed,
    {Alignment alignment = Alignment.topRight,
    double padTop = 8,
    double padRight = 8,
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
                  shape: NeumorphicShape.flat,
                  depth: 8),
              child: GradientIcon(
                Icons.close,
                FlutterGradientNames.phoenixStart,
                center: Alignment.topRight,
              ),
              onPressed: onPressed)));
}
