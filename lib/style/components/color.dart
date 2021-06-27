import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

class SonrColor {
  SonrColor._();
  // ** Value to Map Reference ** //
  static const DesignColorMap = <int, Contact_Design_Color>{
    0xff323232: Contact_Design_Color.Black,
    0xfff0f6fa: Contact_Design_Color.White,
    0xff62666a: Contact_Design_Color.Grey,
    0xff1792ff: Contact_Design_Color.Primary,
    0xff7f30ff: Contact_Design_Color.Secondary,
    0xffB9FFE5: Contact_Design_Color.Tertiary,
    0xffff176b: Contact_Design_Color.Critical,
    0xffFF84B1: Contact_Design_Color.AccentPink,
    0xffC8E9FF: Contact_Design_Color.AccentBlue,
    0xff245379: Contact_Design_Color.AccentNavy,
    0xffD0CCFF: Contact_Design_Color.AccentPurple,
  };

  // ** General Theme Color Properties ** //
  static const Color Black = Color(0xff15162D);
  static const Color White = Color(0xfff0f6fa);
  static const Color Grey = Color(0xff62666a);
  static const Color LightGrey = Color(0xffa4a4a4);

  // ** Palette Colors ** //
  static const Color Primary = Color(0xff1792ff);
  static const Color Secondary = Color(0xff7f30ff);
  static const Color Tertiary = Color(0xff14B69A);
  static const Color Critical = Color(0xffFF2866);

  static const Color AccentPink = Color(0xffFF84B1);
  static const Color AccentBlue = Color(0xffC8E9FF);
  static const Color AccentNavy = Color(0xff245379);
  static const Color AccentPurple = Color(0xffD0CCFF);

  static Color _intToColor(int hexNumber) => Color.fromARGB(255, (hexNumber >> 16) & 0xFF, ((hexNumber >> 8) & 0xFF), (hexNumber >> 0) & 0xFF);

  /// String To Material color
  static Color fromHex(String hex, {double opacity = 1.0}) => _intToColor(int.parse(_textSubString(hex)!, radix: 16)).withOpacity(opacity);

  //Substring
  static String? _textSubString(String text) {
    if (text.length < 6) return null;
    if (text.length == 6) return text;
    return text.substring(1, text.length);
  }
}

extension SonrColorUtils on Color {
  // @ Static Map Reference

  /// Converts color to [Contact_Design_Color] enum
  Contact_Design_Color toDesignColor() {
    if (SonrColor.DesignColorMap.containsKey(this.value)) {
      return SonrColor.DesignColorMap[this.value]!;
    } else {
      return Contact_Design_Color.Transparent;
    }
  }
}

class NoSplashFactory extends InteractiveInkFeatureFactory {
  const NoSplashFactory();

  @override
  InteractiveInkFeature create(
      {required MaterialInkController controller,
      required RenderBox referenceBox,
      required Offset position,
      required Color color,
      required TextDirection textDirection,
      bool containedInkWell = false,
      RectCallback? rectCallback,
      BorderRadius? borderRadius,
      ShapeBorder? customBorder,
      double? radius,
      VoidCallback? onRemoved}) {
    return NoSplash(
      controller: controller,
      referenceBox: referenceBox,
    );
  }
}

class NoSplash extends InteractiveInkFeature {
  NoSplash({
    required MaterialInkController controller,
    required RenderBox referenceBox,
  }) : super(
          color: Colors.transparent,
          controller: controller,
          referenceBox: referenceBox,
        );

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
}
