import 'dart:math';
import 'dart:ui';
import 'package:sonr_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'icon.dart';
import 'package:sonr_app/data/data.dart';

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
}

class SonrGradient {
  // ^ General Gradients ^ //
  static Gradient get bulbDark => FlutterGradients.findByName(FlutterGradientNames.amourAmour);
  static Gradient get bulbLight => FlutterGradients.findByName(FlutterGradientNames.malibuBeach);
  static Gradient get logo => FlutterGradients.fabledSunset(tileMode: TileMode.decal);

  // ^ Generates Random Gradient for Progress View ^ //
  static Gradient get Progress {
    var name = <FlutterGradientNames>[
      FlutterGradientNames.amyCrisp,
      FlutterGradientNames.sugarLollipop,
      FlutterGradientNames.summerGames,
      FlutterGradientNames.supremeSky,
      FlutterGradientNames.juicyCake,
      FlutterGradientNames.northMiracle,
      FlutterGradientNames.seaLord
    ].random();
    return FlutterGradients.findByName(name, tileMode: TileMode.clamp);
  }

  // ^ Palette Gradients ^ //
  static const AlignmentGeometry _K_BEGIN = Alignment.bottomCenter;
  static const AlignmentGeometry _K_END = Alignment.topCenter;
  static Gradient get Primary => LinearGradient(colors: [Color(0xff4aaaff), Color(0xff1792ff)], begin: _K_BEGIN, end: _K_END);
  static Gradient get Secondary => LinearGradient(colors: [Color(0xff7f30ff), Color(0xff9757ff)], begin: _K_BEGIN, end: _K_END);
  static Gradient get Tertiary => LinearGradient(colors: [Color(0xff17ffab), Color(0xff52ffc0)], begin: _K_BEGIN, end: _K_END);
  static Gradient get Neutral => LinearGradient(colors: [Color(0xffa2a2a2), Color(0xffa2a2a2)], begin: _K_BEGIN, end: _K_END);
  static Gradient get Critical => LinearGradient(colors: [Color(0xffff176b), Color(0xffff176b).withOpacity(0.7)], begin: _K_BEGIN, end: _K_END);
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
