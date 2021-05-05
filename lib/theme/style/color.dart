import 'dart:math';
import 'dart:ui';
import 'package:sonr_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'icon.dart';


class SonrColor {
  // ** General Theme Color Properties ** //
  static const Color Black = Color(0xff323232);
  static const Color White = Color(0xfff0f6fa);
  static const Color Grey = Color(0xff62666a);

  // ** Palette Colors ** //
  static const Color Primary = Color(0xff1792ff);
  static const Color Secondary = Color(0xff7f30ff);
  static const Color Tertiary = Color(0xffB9FFE5);
  static const Color Critical = Color(0xffff176b);

  static const Color AccentPink = Color(0xffFF84B1);
  static const Color AccentBlue = Color(0xffC8E9FF);
  static const Color AccentNavy = Color(0xff245379);
  static const Color AccentPurple = Color(0xffD0CCFF);

  static Color _intToColor(int hexNumber) => Color.fromARGB(255, (hexNumber >> 16) & 0xFF, ((hexNumber >> 8) & 0xFF), (hexNumber >> 0) & 0xFF);

  /// String To Material color
  static Color fromHex(String hex, {double opacity = 1.0}) => _intToColor(int.parse(_textSubString(hex), radix: 16)).withOpacity(opacity);

//Substring
  static String _textSubString(String text) {
    if (text == null) return null;

    if (text.length < 6) return null;

    if (text.length == 6) return text;

    return text.substring(1, text.length);
  }
}



extension GradientValue on FlutterGradientNames {
  Gradient get clamp => FlutterGradients.findByName(this, tileMode: TileMode.clamp);

  Gradient linear({TileMode tileMode = TileMode.repeated}) {
    return FlutterGradients.findByName(this, tileMode: tileMode);
  }

  Gradient radial(
      {AlignmentGeometry center = Alignment.center,
      double radius = 0.5,
      double startAngle = 0.0,
      double endAngle = pi * 2,
      TileMode tileMode = TileMode.repeated}) {
    return FlutterGradients.findByName(
      this,
      type: GradientType.radial,
      tileMode: tileMode,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }

  Gradient sweep(
      {AlignmentGeometry center = Alignment.center,
      double radius = 0.5,
      double startAngle = 0.0,
      double endAngle = pi * 2,
      TileMode tileMode = TileMode.repeated}) {
    return FlutterGradients.findByName(
      this,
      type: GradientType.sweep,
      tileMode: tileMode,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
    );
  }
}
