export 'widgets/card.dart';
export 'widgets/decoration.dart';
export '../elements/text.dart';

import 'package:flutter/material.dart';

extension ThemeDataUtils on ThemeData {
  /// Checks if Current Theme Data is for Dark Mode
  bool get isDarkMode => this.brightness == Brightness.dark;

  /// Returns Blur Radius Based on Brightness
  double get blurRadius => this.isDarkMode ? 6 : 8;

  /// Returns Spread Radius Based on Brightness
  double get spreadRadius => this.isDarkMode ? 0.5 : 2;
}
