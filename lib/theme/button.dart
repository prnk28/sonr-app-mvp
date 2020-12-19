import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'icon.dart';
import 'text.dart';

NeumorphicButton rectangleButton(String text, Function onPressed,
    {NeumorphicShape shape = NeumorphicShape.concave}) {
  return NeumorphicButton(
      onPressed: onPressed,
      style: NeumorphicStyle(
          depth: 8,
          shape: shape,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
      padding: const EdgeInsets.all(12.0),
      child: normalText(text));
}

Widget closeButton(Function onPressed,
    {Alignment alignment = Alignment.topRight,
    double padTop = 5,
    double padRight = 5,
    double padLeft = 5,
    double padBottom = 5}) {
  return Align(
      alignment: Alignment.topRight,
      child: Padding(
          padding: EdgeInsets.only(
            top: padTop,
            right: padRight,
            left: padLeft,
            bottom: padBottom,
          ),
          child: NeumorphicButton(
              // padding: EdgeInsets.only(top: 10, right: 15),
              style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.circle(),
                  shape: NeumorphicShape.convex,
                  depth: 5),
              child: GradientIcon(Icons.close,
                  center: Alignment.topRight,
                  gradientType: FlutterGradientNames.phoenixStart),
              onPressed: onPressed)));
}
