// Custom Theme Aspects
export '../widgets/header.dart';
export 'button.dart';
export 'color.dart';
export 'icon.dart';
export 'scaffold.dart';
export 'snackbar.dart';
export 'text.dart';

// Global UI Widgets
export '../widgets/animation.dart';
export '../widgets/painter.dart';
export '../widgets/sheet.dart';
export '../widgets/overlay.dart';
export '../widgets/form.dart';

// UI Packages
export 'package:google_fonts/google_fonts.dart';
export 'package:flutter_neumorphic/flutter_neumorphic.dart';
export 'package:simple_animations/simple_animations.dart';
export 'package:supercharged/supercharged.dart';
export 'package:simple_animations/simple_animations.dart';
export 'package:supercharged/supercharged.dart';
export 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
export 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_app/widgets/painter.dart';
import 'color.dart';

class SonrStyle {
  static get normal => NeumorphicStyle(intensity: 0.85, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)));
  static get indented => NeumorphicStyle(depth: -8, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)));
  static get timeStamp => NeumorphicStyle(intensity: 0.4, depth: 8, boxShape: NeumorphicBoxShape.stadium(), color: SonrColor.base);
  static get flat => NeumorphicStyle(depth: 8, shape: NeumorphicShape.flat, color: SonrColor.base);
  static get dropDownItem =>
      NeumorphicStyle(intensity: 0.85, depth: 8, shape: NeumorphicShape.flat, boxShape: NeumorphicBoxShape.stadium(), color: SonrColor.base);
  static get dropDownBox =>
      NeumorphicStyle(intensity: 0.85, depth: 8, shape: NeumorphicShape.flat, color: SonrColor.base, shadowLightColor: Colors.black38);
  static get overlay => NeumorphicStyle(
      intensity: 0.85,
      depth: 8,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
      color: SonrColor.base,
      shadowLightColor: Colors.black38);

  static get shareButton => NeumorphicStyle(
        color: Colors.black87,
        surfaceIntensity: 0.6,
        intensity: 0.75,
        depth: 8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
      );

  static get expandedBubble => NeumorphicStyle(intensity: 0.85, boxShape: NeumorphicBoxShape.path(ExpandedBubblePainter()));

  static get bubbleDecoration => BoxDecoration(shape: BoxShape.circle, boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(167, 179, 190, 1.0),
          offset: Offset(0, 2),
          blurRadius: 6,
          spreadRadius: 0.5,
        ),
        BoxShadow(
          color: Color.fromRGBO(248, 252, 255, 0.5),
          offset: Offset(-2, 0),
          blurRadius: 6,
          spreadRadius: 0.5,
        ),
      ]);
}
