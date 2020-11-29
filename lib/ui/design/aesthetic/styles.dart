part of 'aesthetic.dart';

NeumorphicStyle windowStyle() {
  return NeumorphicStyle(
      shape: NeumorphicShape.flat,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
      depth: 8,
      lightSource: LightSource.topLeft,
      color: Colors.blueGrey[50]);
}
