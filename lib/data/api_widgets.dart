import 'package:sonr_app/data/constants.dart';
import 'package:sonr_app/theme/theme.dart';

// ^ Edge Insets Helper Extensions ^ //
extension EdgeInsetsX on EdgeInsets {
  // Top Only Insets
  static EdgeInsets top(double value) {
    return EdgeInsets.only(top: value);
  }

  // Bottom Only Insets
  static EdgeInsets bottom(double value) {
    return EdgeInsets.only(bottom: value);
  }

  // Left Only Insets
  static EdgeInsets left(double value) {
    return EdgeInsets.only(left: value);
  }

  // Right Only Insets
  static EdgeInsets right(double value) {
    return EdgeInsets.only(right: value);
  }

  // Vertical Symmetric Only Insets
  static EdgeInsets vertical(double value) {
    return EdgeInsets.symmetric(vertical: value);
  }

  // Horizontal Symmetric Only Insets
  static EdgeInsets horizontal(double value) {
    return EdgeInsets.symmetric(horizontal: value);
  }
}

// ^ Padding Helper Extensions ^ //
extension PaddingX on Padding {
  // Top Only Insets
  static Padding top(double value) {
    return Padding(padding: EdgeInsets.only(top: value));
  }

  // Bottom Only Insets
  static Padding bottom(double value) {
    return Padding(padding: EdgeInsets.only(bottom: value));
  }

  // Left Only Insets
  static Padding left(double value) {
    return Padding(padding: EdgeInsets.only(left: value));
  }

  // Right Only Insets
  static Padding right(double value) {
    return Padding(padding: EdgeInsets.only(right: value));
  }

  // Vertical Symmetric Only Insets
  static Padding vertical(double value) {
    return Padding(padding: EdgeInsets.symmetric(vertical: value));
  }

  // Horizontal Symmetric Only Insets
  static Padding horizontal(double value) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: value));
  }
}
