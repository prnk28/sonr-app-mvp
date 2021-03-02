// Custom Theme Aspects
export '../elements/header.dart';
export 'button.dart';
export 'color.dart';
export 'icon.dart';
export 'scaffold.dart';
export 'snackbar.dart';
export 'text.dart';

// Global UI Widgets
export '../elements/animation.dart';
export '../elements/painter.dart';
export '../elements/sheet.dart';
export '../elements/overlay.dart';
export '../elements/form.dart';

// UI Packages
export 'package:google_fonts/google_fonts.dart';
export 'package:flutter_neumorphic/flutter_neumorphic.dart';
export 'package:simple_animations/simple_animations.dart';
export 'package:supercharged/supercharged.dart';
export 'package:simple_animations/simple_animations.dart';
export 'package:supercharged/supercharged.dart';
export 'package:flutter_custom_clippers/flutter_custom_clippers.dart' hide ArrowClipper;
export 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'color.dart';

class SonrStyle {
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

  static get compassStamp => NeumorphicStyle(intensity: 0.4, depth: 8, boxShape: NeumorphicBoxShape.stadium(), color: Colors.black87);

  static get dropDownBox =>
      NeumorphicStyle(intensity: 0.85, depth: 8, shape: NeumorphicShape.flat, color: SonrColor.base, shadowLightColor: Colors.black38);

  static get dropDownItem =>
      NeumorphicStyle(intensity: 0.85, depth: 8, shape: NeumorphicShape.flat, boxShape: NeumorphicBoxShape.stadium(), color: SonrColor.base);

  static get flat => NeumorphicStyle(depth: 8, shape: NeumorphicShape.flat, color: SonrColor.base);

  static const gradientIcon =
      NeumorphicStyle(color: SonrColor.base, shadowLightColor: Colors.transparent, intensity: 0.85, depth: 6, surfaceIntensity: 0.6);

  static get appBarIcon =>
      NeumorphicStyle(color: SonrColor.base, shadowLightColor: SonrColor.neuoIconShadow, intensity: 0.85, depth: 2, surfaceIntensity: 0.6);

  static get indented => NeumorphicStyle(depth: -8, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)));

  static get overlay => NeumorphicStyle(
      intensity: 0.85,
      depth: 8,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
      color: SonrColor.base,
      shadowLightColor: Colors.black38);

  static get mediaButtonDefault => NeumorphicStyle(intensity: 0.85, color: SonrColor.base);
  static get mediaButtonPressed => NeumorphicStyle(depth: -12, intensity: 0.85, shadowDarkColorEmboss: Colors.grey[700]);

  static get normal => NeumorphicStyle(intensity: 0.85, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)));

  static get photo =>
      NeumorphicStyle(intensity: 0.85, depth: 8, boxShape: NeumorphicBoxShape.circle(), color: SonrColor.base, shadowLightColor: Colors.black38);

  static get shareButton => NeumorphicStyle(
        color: Colors.black87,
        surfaceIntensity: 0.6,
        intensity: 0.75,
        depth: 8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
      );

  static get timeStamp => NeumorphicStyle(intensity: 0.4, depth: 8, boxShape: NeumorphicBoxShape.stadium(), color: SonrColor.base);

  static get timeStampDark => NeumorphicStyle(intensity: 0.4, depth: 8, boxShape: NeumorphicBoxShape.stadium(), color: SonrColor.baseDark);
}
