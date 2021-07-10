import 'package:sonr_app/style/style.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'package:flutter/material.dart';


class AppColor {
  /// #### Gradient Red (1) `#FD4DF6`
  /// First Color in Dark Mode Primary Gradient
  static const Color gradientRedStart = Color(0xffFD4DF6);

  /// #### Gradient Red (2) `#FDA14D`
  /// Last Color in Dark Mode Primary Gradient
  static const Color gradientRedEnd = Color(0xffFDA14D);

  /// #### Gradient Blue (1) `#6587FD`
  /// First Color in Light Mode Primary Gradient
  static const Color gradientBlueStart = Color(0xff6587FD);

  /// #### Gradient Blue (2) `#65FDF4`
  /// Last Color in Light Mode Primary Gradient
  static const Color gradientBlueEnd = Color(0xff65FDF4);

  // ** General Theme Color Properties ** //
  static const Color Black = Color(0xff15162D);
  static const Color White = Color(0xfff0f6fa);
  static const Color Grey = Color(0xff62666a);
  static const Color LightGrey = Color(0xffa4a4a4);

  // ** Palette Colors ** //
  static const Color Primary = Color(0xff1792ff);
  static const Color Secondary = Color(0xff9665FD);
  static const Color Tertiary = Color(0xff14B69A);
  static const Color Critical = Color(0xffFF2866);

  static const Color AccentPink = Color(0xffFF84B1);
  static const Color AccentBlue = Color(0xffC8E9FF);
  static const Color AccentNavy = Color(0xff245379);
  static const Color AccentPurple = Color(0xffD0CCFF);
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

class CGUtility {
  /// String To Material color
  static Color hexColor(String hex, {double opacity = 1.0}) => _intToColor(int.parse(_textSubString(hex)!, radix: 16)).withOpacity(opacity);

  static Color _intToColor(int hexNumber) => Color.fromARGB(255, (hexNumber >> 16) & 0xFF, ((hexNumber >> 8) & 0xFF), (hexNumber >> 0) & 0xFF);

  //Substring
  static String? _textSubString(String text) {
    if (text.length < 6) return null;
    if (text.length == 6) return text;
    return text.substring(1, text.length);
  }

  static LinearGradient bottomUpGradient(List<Color> colors) =>
      LinearGradient(colors: colors, begin: Alignment.bottomCenter, end: Alignment.topCenter, tileMode: TileMode.clamp);

  static LinearGradient angledGradient(double angle, List<Color> colors, List<double> stops) =>
      LinearGradient(colors: colors, stops: stops, transform: GradientRotation(radians(angle)), tileMode: TileMode.clamp);

  static LinearGradient angledGradientWith({required double angle, required List<Tuple<String, double>> values}) {
    final colors = values.map((e) => CGUtility.hexColor(e.item1)).toList();
    final stops = values.map((e) => e.item2).toList();
    return LinearGradient(colors: colors, stops: stops, transform: GradientRotation(radians(angle)), tileMode: TileMode.clamp);
  }
}
