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

  // /// @ Floating Default Neumorphic Box
  // static BoxDecoration floating({required ThemeData theme, double radius = 12, BoxShape shape = BoxShape.rectangle, Border? border}) {
  //   return BoxDecoration(
  //     shape: shape,
  //     border: border != null ? border : Border.all(color: theme.dividerColor, width: 1),
  //     borderRadius: shape != BoxShape.circle ? BorderRadius.circular(radius) : null,
  //     gradient: theme.brightness == Brightness.dark ? SonrGradient.DarkCard : SonrGradient.LightCard,
  //     boxShadow: [
  //       BoxShadow(
  //         color: theme.shadowColor,
  //         offset: Offset(5, 5),
  //         blurRadius: theme.blurRadius,
  //       ),
  //       BoxShadow(
  //         color: theme.canvasColor,
  //         offset: Offset(-5, -5),
  //         blurRadius: theme.blurRadius,
  //       ),
  //     ],
  //   );
  // }

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
