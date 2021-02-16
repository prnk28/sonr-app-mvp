import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'icon.dart';

class SonrColor {
  // ** General Theme Color Properties ** //
  static const Color base = Color(0xffDDDDDD);
  static const Color baseWhite = Color(0xffEFEEEE);
  static const Color dialogBackground = Color.fromRGBO(0, 0, 0, 0.7);
  static const Color overlayBackground = Color.fromRGBO(0, 0, 0, 0.45);
  static const Color disabledButton = Color.fromRGBO(179, 181, 181, 1.0);

  // ^ Generates Random Gradient for Progress View ^ //
  static Gradient randomGradient() {
    var opts = [
      FlutterGradients.amyCrisp(),
      FlutterGradients.sugarLollipop(),
      FlutterGradients.summerGames(),
      FlutterGradients.supremeSky(),
      FlutterGradients.juicyCake(),
      FlutterGradients.northMiracle(),
      FlutterGradients.seaLord()
    ];

    // Generates a new Random object
    final _random = new Random();

    // Generate a random index based on the list length
    return opts[_random.nextInt(opts.length)];
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
