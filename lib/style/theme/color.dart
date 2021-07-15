import 'package:sonr_app/style/style.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'package:flutter/material.dart';

class AppColor {
  // ** General Theme Color Properties ** //
  static const Color Black = Color(0xff15162D);
  static const Color White = Color(0xfff0f6fa);
  static const Color DarkGrey = Color(0xff8E8E93);
  static const Color LightGrey = Color(0xffBFBFC3);

  // ** Palette Colors ** //
  static const Color Blue = Color(0xff1792ff);
  static const Color Purple = Color(0xff9665FD);
  static const Color Green = Color(0xff14B69A);
  static const Color Red = Color(0xffFF2866);
  static const Color Orange = Color(0xffFDA14D);
  static const Color Pink = Color(0xffFD4DF6);

  static const Color AccentPink = Color(0xffFF84B1);
  static const Color AccentBlue = Color(0xffC8E9FF);
  static const Color AccentNavy = Color(0xff245379);
  static const Color AccentPurple = Color(0xffD0CCFF);

  // ** Theme Colors ** //
  static const Color BackgroundLight = Colors.white;
  static const Color BackgroundDark = Color(0xff151515);
  static const Color DividerLight = Color(0xffEBEBEB);
  static const Color DividerDark = Color(0xff4E4949);
  static const Color ForegroundLight = Color(0xffF6F6F6);
  static const Color ForegroundDark = Color(0xff2B2B2B);
  static Color ShadowLight = Color(0xffD4D7E0);
  static Color ShadowDark = Colors.black;

  static Color Background(bool isDarkMode) => isDarkMode ? BackgroundDark : BackgroundLight;

  static Color Divider(bool isDarkMode) => isDarkMode ? DividerDark : DividerLight;

  static Color Foreground(bool isDarkMode) => isDarkMode ? ForegroundDark : ForegroundLight;

  static Color Item(bool isDarkMode) => isDarkMode ? White : Black;

  static Color Grey(bool isDarkMode) => isDarkMode ? LightGrey : DarkGrey;

  static Color Accent(bool isDarkMode) => isDarkMode ? Pink : Blue;

  static Color Shadow(bool isDarkMode, {double lightOpacity = 0.75, double darkOpacity = 0.4}) =>
      isDarkMode ? ShadowDark.withOpacity(darkOpacity) : ShadowLight.withOpacity(lightOpacity);
}

class AppGradientColor {
  /// Angle of Primary Gradient
  static const K_PRIMARY_ANGLE = 314.65;

  /// Angle of Foreground Gradient
  static const K_FOREGROUND_ANGLE = 50.39;

  /// ### First Primary Gradient Color
  /// Returns Primary Gradient Start Color By Theme Mode
  /// - Gradient Red (1) `#FD4DF6`
  /// - Gradient Blue (1) `#4D74FD`
  static Tuple<Color, double> primaryStart(bool darkMode) {
    if (darkMode) {
      return Tuple(Color(0xffFD4DF6), 0);
    } else {
      return Tuple(Color(0xff4D74FD), 0);
    }
  }

  /// ### Final Primary Gradient Color
  /// Returns Primary Gradient Final Color By Theme Mode
  /// - Gradient Red (2) `#FDA14D`
  /// - Gradient Blue (2) `#4DFDF2`
  static Tuple<Color, double> primaryEnd(bool darkMode) {
    if (darkMode) {
      return Tuple(Color(0xffFDA14D), 1);
    } else {
      return Tuple(Color(0xff4DFDF2), 1);
    }
  }

  /// ### First Foreground Gradient Color
  /// Returns Foreground Gradient Start Color By Theme Mode
  /// - Gradient Black (1) `#3E3E3F`
  static Tuple<Color, double> foregroundStart(bool darkMode) {
    if (darkMode) {
      return Tuple(Color(0xff3E3E3F), 0);
    } else {
      return Tuple(AppColor.ForegroundLight, 0);
    }
  }

  /// ### Final Foreground Gradient Color
  /// Returns Foreground Gradient Final Color By Theme Mode
  /// - Gradient Black (2) `#25272C`
  static Tuple<Color, double> foregroundEnd(bool darkMode) {
    if (darkMode) {
      return Tuple(Color(0xff25272C), 1);
    } else {
      return Tuple(AppColor.ForegroundLight, 1);
    }
  }

  /// ### Light Mode Primary Gradient
  /// **CSS Reference**
  /// ``` css
  /// background: radial-gradient(87.68% 87.68% at 95.36% 14.36%, #FFD840 0%, #F3ACFF 55.86%, #8AECFF 100%);
  /// ```
  ///
  /// **Setup**
  /// - `#FFD840` -> 0%
  /// - `#F3ACFF` -> 55.86%
  /// - `#8AECFF` -> 100%
  static Tuple<List<Color>, List<double>> get lightColors => Tuple([
        Color(0xffFFD840),
        Color(0xffF3ACFF),
        Color(0xff8AECFF),
      ], [
        0,
        0.625,
        1
      ]);

  /// ### Light Mode Center Alignment
  ///   /// **CSS Reference**
  /// ``` css
  /// background: radial-gradient(87.68% 87.68% at 95.36% 14.36%, #FFD840 0%, #F3ACFF 55.86%, #8AECFF 100%);
  /// ```
  ///
  /// **Setup**
  /// - Focal Point 87.68%, 87.68%
  /// - Center Point 95.36%, 14.36%
  static Tuple<Alignment, Alignment> get lightAlignment => Tuple(Alignment(0.8768, 0.8768), Alignment(0.9536, 0.1436));
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
  static Color hex(String hex, {double opacity = 1.0}) => _intToColor(int.parse(_textSubString(hex)!, radix: 16)).withOpacity(opacity);

  static Color _intToColor(int hexNumber) => Color.fromARGB(255, (hexNumber >> 16) & 0xFF, ((hexNumber >> 8) & 0xFF), (hexNumber >> 0) & 0xFF);

  //Substring
  static String? _textSubString(String text) {
    if (text.length < 6) return null;
    if (text.length == 6) return text;
    return text.substring(1, text.length);
  }

  static LinearGradient bottomUp(List<Color> colors) =>
      LinearGradient(colors: colors, begin: Alignment.bottomCenter, end: Alignment.topCenter, tileMode: TileMode.clamp);

  static LinearGradient angled(double angle, List<Color> colors, List<double> stops) =>
      LinearGradient(colors: colors, stops: stops, transform: GradientRotation(radians(angle)), tileMode: TileMode.clamp);

  static LinearGradient angledFrom({required double angle, required List<Tuple<Color, double>> values}) {
    final colors = values.map((e) => e.item1).toList();
    final stops = values.map((e) => e.item2).toList();
    return LinearGradient(colors: colors, stops: stops, transform: GradientRotation(radians(angle)), tileMode: TileMode.clamp);
  }
}
