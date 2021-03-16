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
  static const Color OverlayBackground = Color.fromRGBO(0, 0, 0, 0.45);

  static const Color Dark = Color(0xff2c2b2b);
  static const Color Grey = Color(0xffC6C4C4);
  static const Color Blue = Color(0xff51C5DD);
  static const Color White = Color(0xffE0E0E0);

  // ** Color Pallette ** //
  static Color get primary => DeviceService.isDarkMode.value ? Color(0xff2c2b2b) : Color(0xff538fff);
  static Color get secondary => DeviceService.isDarkMode.value ? Color(0xff9757ff) : Color(0xff543191);
  static Color get tertiary => DeviceService.isDarkMode.value ? Color(0xff52ffc0) : Color(0xff2e906e);
  static Color get red => DeviceService.isDarkMode.value ? Color(0xffcc1b0b) : Color(0xffff4d62);

  // static const Color ShadowLight = Color.fromRGBO(190, 190, 190, 0.6);
  // static const Color ShadowDark = Color.fromRGBO(55, 55, 55, 0.8);

  // ** Gradients ** //
  static Gradient get lightModeBulb => FlutterGradients.findByName(FlutterGradientNames.malibuBeach);
  static Gradient get darkModeBulb => FlutterGradients.findByName(FlutterGradientNames.amourAmour);
  static Gradient get mainGradient => FlutterGradients.fabledSunset(tileMode: TileMode.decal);

  // ^ ThemeMode Handling ^ //
  static Color get currentNeumorphic {
    return DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White;
  }

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
    if (DeviceService.isDarkMode.value) {
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
