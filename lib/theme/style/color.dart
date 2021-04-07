import 'dart:math';
import 'dart:ui';
import 'package:sonr_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'icon.dart';

class SonrColor {
  // ** General Theme Color Properties ** //
  static Color get neuoIconShadow => const Color(0xffDDDDDD).withOpacity(0.6);
  static const Color DialogBackground = Color.fromRGBO(0, 0, 0, 0.7);
  static const Color Black = Color(0xff202020);
  static const Color Dark = Color(0xff2c2b2b);
  static const Color Grey = Color(0xffC6C4C4);
  static const Color Blue = Color(0xff51C5DD);
  static const Color White = Color(0xffE0E0E0);
  static const Color Neutral = Color(0xff62666a);

  // ^ ThemeMode Handling ^ //
  static Color get currentNeumorphic {
    return UserService.isDarkMode ? SonrColor.Dark : SonrColor.White;
  }

  // ^ Returns Color from Hexidecimal ^ //
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // ^ Finds Current Theme Icon Color ^ //
  static Color icons() {
    final theme = NeumorphicTheme.of(Get.context);
    if (UserService.isDarkMode) {
      return theme.current.accentColor;
    } else {
      return theme.current.accentColor;
    }
  }
}

extension GradientValue on FlutterGradientNames {
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

class SonrGradient {
  // ** Gradients ** //
  static Gradient get bulbDark => FlutterGradients.findByName(FlutterGradientNames.amourAmour);
  static Gradient get bulbLight => FlutterGradients.findByName(FlutterGradientNames.malibuBeach);
  static Gradient get logo => FlutterGradients.fabledSunset(tileMode: TileMode.decal);

  // ^ Generates Random Gradient for Progress View ^ //
  static Gradient progress() {
    var name = [
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
}

class SonrPalette {
  static const Color Neutral = Color(0xff62666a);
  static const Color Primary = Color(0xff1792ff);
  static const Color Secondary = Color(0xffab17ff);
  static const Color Tertiary = Color(0xff52ffc0);
  static const Color Red = Color(0xffff176b);

  static const AlignmentGeometry _K_BEGIN = Alignment.bottomCenter;
  static const AlignmentGeometry _K_END = Alignment.topCenter;

  static Gradient primary() {
    return LinearGradient(colors: [Color(0xff4aaaff), Color(0xff1792ff)], begin: _K_BEGIN, end: _K_END);
  }

  static Gradient secondary() {
    return LinearGradient(colors: [Color(0xff7f30ff), Color(0xff9757ff)], begin: _K_BEGIN, end: _K_END);
  }

  static Gradient tertiary() {
    return LinearGradient(colors: [Color(0xff17ffab), Color(0xff52ffc0)], begin: _K_BEGIN, end: _K_END);
  }

  static Gradient neutral() {
    return LinearGradient(colors: [Color(0xffa2a2a2), Color(0xffa2a2a2)], begin: _K_BEGIN, end: _K_END);
  }

  static Gradient critical() {
    return LinearGradient(colors: [Color(0xffff176b), Color(0xffff176b).withOpacity(0.7)], begin: _K_BEGIN, end: _K_END);
  }
}
