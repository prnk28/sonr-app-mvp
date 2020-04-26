import 'package:flutter/material.dart';

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
  static TextStyle mediumTextStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle bigTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );
}
