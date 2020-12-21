// ignore: non_constant_identifier_names
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'color.dart';

// ^ Sonr Global WindowBorder Data ^ //
// ignore: non_constant_identifier_names
NeumorphicStyle SonrBorderStyle() {
  return NeumorphicStyle(
      color: HexColor.fromHex("EFEEEE"),
      lightSource: LightSource.top,
      intensity: 0.85,
      surfaceIntensity: 0.25,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(40)));
}
