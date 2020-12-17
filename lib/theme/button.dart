import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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

Widget closeButton(Function onPressed) {
  return Align(
      alignment: Alignment.topRight,
      child: NeumorphicButton(
          padding: EdgeInsets.only(top: 10, right: 15),
          style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.circle(),
              shape: NeumorphicShape.convex,
              depth: 5),
          child: Icon(
            Icons.close_rounded,
            size: 35,
            color: Colors.grey[700],
          ),
          onPressed: onPressed));
}
