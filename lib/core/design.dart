import 'package:flutter/material.dart';
import 'package:sonar_app/core/core.dart';

// *******************
// ** Design Enums ***
// *******************
// Text Design
enum TextDesign { MediumText, BigText, NormalText, DescriptionText }

class Design {
// **************************
// *** Primary Theme Data ***
// **************************
  static ThemeData data = ThemeData(
    primaryColor: Color.fromRGBO(109, 234, 255, 1),
    accentColor: Color.fromRGBO(72, 74, 126, 1),
    brightness: Brightness.dark,
  );

// *******************
// *** Text Styles ***
// *******************

  static getTextStyle(TextDesign design) {
    switch (design) {
      case TextDesign.MediumText:
        return TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        );
      case TextDesign.BigText:
        return TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        );
      default:
    }
  }
}
