// ignore: non_constant_identifier_names
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import 'color.dart';

// ^ Sonr Global WindowBorder Data ^ //
// ignore: non_constant_identifier_names
NeumorphicStyle SonrBorderStyle() {
  return NeumorphicStyle(
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(40)));
}

// ^ Sonr Global WindowDecoration Data ^ //
// ignore: non_constant_identifier_names
NeumorphicDecoration SonrDecoration() {
  return NeumorphicDecoration(
      isForeground: true,
      shape: NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
      style: NeumorphicStyle(color: HexColor.fromHex("EFEEEE")),
      renderingByPath: false,
      splitBackgroundForeground: true);
}
