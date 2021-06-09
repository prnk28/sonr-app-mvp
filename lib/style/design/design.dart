export 'data/color.dart';
export 'data/gradient.dart';
export 'data/icon.dart';

export 'widgets/card.dart';
export 'widgets/decoration.dart';
export 'widgets/text.dart';

import 'package:flutter/material.dart';
import 'data/color.dart';

class SonrDesign {
  static ThemeData get LightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: SonrColor.Primary,
        backgroundColor: SonrColor.White,
        dividerColor: Colors.white.withOpacity(0.65),
        scaffoldBackgroundColor: SonrColor.White.withOpacity(0.75),
        splashColor: SonrColor.Primary.withOpacity(0.2),
        errorColor: SonrColor.Critical,
        accentColor: SonrColor.Secondary,
        focusColor: SonrColor.Black,
        hintColor: SonrColor.Grey,
        cardColor: Color(0xfff0f6fa).withOpacity(0.85),
        canvasColor: Color(0xffffffff).withOpacity(0.75),
        shadowColor: Color(0xffc7ccd0),
      );

  static ThemeData get DarkTheme => ThemeData(
        brightness: Brightness.dark,
        dividerColor: SonrColor.Black.withOpacity(0.65),
        primaryColor: SonrColor.Primary,
        backgroundColor: SonrColor.Black,
        scaffoldBackgroundColor: SonrColor.Black.withOpacity(0.85),
        splashColor: SonrColor.Primary.withOpacity(0.2),
        errorColor: SonrColor.Critical,
        accentColor: SonrColor.AccentPurple,
        focusColor: SonrColor.White,
        hintColor: SonrColor.LightGrey,
        cardColor: Color(0xff2f2a2a).withOpacity(0.75),
        canvasColor: Color(0xff3e3737),
        shadowColor: Color(0xff2f2a2a),
      );
}

extension ThemeDataUtils on ThemeData {
  /// Checks if Current Theme Data is for Dark Mode
  bool get isDarkMode => this.brightness == Brightness.dark;

  /// Returns Blur Radius Based on Brightness
  double get blurRadius => this.isDarkMode ? 6 : 8;

  /// Returns Spread Radius Based on Brightness
  double get spreadRadius => this.isDarkMode ? 0.5 : 2;
}
