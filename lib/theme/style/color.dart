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
  static const Color Dark = Color(0xff1A1A1A);
  static const Color DialogBackground = Color.fromRGBO(0, 0, 0, 0.7);
  static const Color OverlayBackground = Color.fromRGBO(0, 0, 0, 0.45);

  // ** Color Pallette ** //
  static const Color Red = Color(0xffF04C63);
  static const Color Grey = Color(0xffC6C4C4);
  static const Color Blue = Color(0xff51C5DD);
  static const Color White = Color(0xffF7F6F6);
  static const Color Navy = Color(0xff0A4F70);
  static const Color ShadowLight = Color.fromRGBO(198, 196, 196, 0.5);
  static const Color ShadowDark = Color.fromRGBO(0, 0, 0, 0.6);

  // ** Bulb Gradients ** //
  static Gradient get activeBulb => FlutterGradients.findByName(FlutterGradientNames.summerGames);
  static Gradient get inactiveBulb => FlutterGradients.findByName(FlutterGradientNames.octoberSilence);

  // ^ Generates Random Gradient for Progress View ^ //
  static Gradient progressGradient() {
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
    if (Get.isDarkMode) {
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