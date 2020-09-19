import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// *******************
// ** Design Enums ***
// *******************
// Text Design
enum TextStyleType {
  MediumText,
  HeaderText, //
  DescriptionText,
  HintText // Above Input Fields
}

class Design {
// ******************
// *** Theme Data ***
// ******************
  static NeumorphicThemeData lightData = NeumorphicThemeData(
    baseColor: Color(0xFFFFFFFF),
    lightSource: LightSource.topLeft,
    depth: 10,
  );

  static NeumorphicThemeData darkData = NeumorphicThemeData(
    baseColor: Color(0xFF3E3E3E),
    lightSource: LightSource.topLeft,
    depth: 6,
  );

// ************
// *** Text ***
// ************
  // Text Styles
  static getTextStyle(TextStyleType design) {
    switch (design) {
      case TextStyleType.MediumText:
        return TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        );
      case TextStyleType.HeaderText:
        return TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        );
      case TextStyleType.HintText:
        return TextStyle(
          color: Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        );
      default:
    }
  }

  // Text Field Style
  static NeumorphicStyle textFieldStyle = NeumorphicStyle(
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(45)),
      depth: -4,
      lightSource: LightSource.top,
      color: Colors.transparent);

// ***************
// *** Buttons ***
// ***************

}
