import 'package:flutter/material.dart';
import 'package:sonr_app/style.dart';

extension Neumorphic on BoxDecoration {
  /// @ Floating Contact Neumorphic Box
  static BoxDecoration contact({required ThemeData theme, required Image image}) {
    return BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: image.image,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(theme.cardColor, BlendMode.difference),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            offset: Offset(5, 5),
            blurRadius: theme.blurRadius,
          ),
          BoxShadow(
            color: theme.canvasColor,
            offset: Offset(-5, -5),
            blurRadius: theme.blurRadius,
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.65), width: 1));
  }

  /// @ Floating Default Neumorphic Box
  static BoxDecoration floating({required ThemeData theme, double radius = 12, BoxShape shape = BoxShape.rectangle, Border? border}) {
    return BoxDecoration(
      shape: shape,
      border: border != null ? border : Border.all(color: theme.dividerColor, width: 1),
      borderRadius: shape != BoxShape.circle ? BorderRadius.circular(radius) : null,
      gradient: theme.brightness == Brightness.dark ? SonrGradient.DarkCard : SonrGradient.LightCard,
      boxShadow: [
        BoxShadow(
          color: theme.shadowColor,
          offset: Offset(5, 5),
          blurRadius: theme.blurRadius,
        ),
        BoxShadow(
          color: theme.canvasColor,
          offset: Offset(-5, -5),
          blurRadius: theme.blurRadius,
        ),
      ],
    );
  }

  /// @ Slightly Indented Neumorphic Box
  static BoxDecoration indented({required ThemeData theme, double radius = 20, BoxShape shape = BoxShape.rectangle}) {
    return BoxDecoration(
      shape: shape,
      borderRadius: shape != BoxShape.circle ? BorderRadius.circular(radius) : null,
      gradient: theme.brightness == Brightness.dark ? SonrGradient.DarkCard : SonrGradient.LightCard,
      boxShadow: [
        BoxShadow(
          color: theme.shadowColor,
          offset: Offset(-4, -4),
          blurRadius: theme.blurRadius,
        ),
        BoxShadow(
          color: theme.canvasColor,
          offset: Offset(4, 4),
          blurRadius: theme.blurRadius,
        ),
      ],
    );
  }
}

/// ## Edge Insets Helper Extensions
extension EdgeWith on EdgeInsets {
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

/// ## Padding Helper Extensions
extension PadWith on Padding {
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
