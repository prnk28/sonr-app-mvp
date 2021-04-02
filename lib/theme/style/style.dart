// Custom Theme Aspects
export '../elements/header.dart';
export 'background.dart';
export 'button.dart';
export 'color.dart';
export 'icon.dart';
export 'scaffold.dart';
export 'snackbar.dart';
export 'text.dart';

// Global UI Widgets
export '../elements/animation.dart';
export '../elements/glass.dart';
export '../elements/painter.dart';
export '../elements/sheet.dart';
export '../elements/overlay.dart';
export '../elements/form.dart';
export '../elements/flat.dart';

// UI Packages
export 'package:google_fonts/google_fonts.dart';
export 'package:flutter_neumorphic/flutter_neumorphic.dart';
export 'package:supercharged/supercharged.dart';
export 'package:flutter_custom_clippers/flutter_custom_clippers.dart' hide ArrowClipper;
export 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../theme.dart';
import 'color.dart';

enum WidgetPosition { Left, Right, Top, Bottom, Center }

class SonrStyle {
  static get appBarIcon =>
      NeumorphicStyle(color: SonrColor.White, shadowLightColor: SonrColor.neuoIconShadow, intensity: 0.65, depth: 2, surfaceIntensity: 0.6);

  static get compassStamp =>
      NeumorphicStyle(intensity: 0.4, depth: UserService.isDarkMode.value ? 4 : 8, boxShape: NeumorphicBoxShape.stadium(), color: Colors.black87);

  static get dropDownBackground => NeumorphicStyle(
      intensity: UserService.isDarkMode.value ? 0.45 : 0.85,
      depth: UserService.isDarkMode.value ? 4 : 8,
      shape: NeumorphicShape.flat,
      color: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      shadowLightColor: Colors.black38);

  static get dropDownItem => NeumorphicStyle(
        intensity: UserService.isDarkMode.value ? 0.45 : 0.85,
        depth: UserService.isDarkMode.value ? 4 : 8,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.stadium(),
        color: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      );

  static get dropDownFlat => NeumorphicStyle(
        intensity: UserService.isDarkMode.value ? 0.45 : 0.85,
        depth: UserService.isDarkMode.value ? 4 : 8,
        shape: NeumorphicShape.flat,
        color: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      );
  static get dropDownCurved => NeumorphicStyle(
        intensity: UserService.isDarkMode.value ? 0.45 : 0.85,
        depth: UserService.isDarkMode.value ? 4 : 8,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.stadium(),
        color: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      );

  static get flat => NeumorphicStyle(
        intensity: UserService.isDarkMode.value ? 0.45 : 0.85,
        depth: UserService.isDarkMode.value ? 4 : 8,
        shape: NeumorphicShape.flat,
        color: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      );

  static get indented => NeumorphicStyle(
      color: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      depth: -8,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)));

  static get gradientIcon => NeumorphicStyle(
      color: SonrColor.White,
      shadowLightColor: Colors.transparent,
      intensity: 0.85,
      depth: UserService.isDarkMode.value ? 4 : 8,
      surfaceIntensity: 0.6);

  static get overlay => NeumorphicStyle(
        intensity: UserService.isDarkMode.value ? 0.45 : 0.85,
        depth: UserService.isDarkMode.value ? 4 : 8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        color: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      );

  static get normal => NeumorphicStyle(
        depth: UserService.isDarkMode.value ? 4 : 8,
        color: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
        intensity: UserService.isDarkMode.value ? 0.45 : 0.85,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
      );

  static get photo => NeumorphicStyle(
      intensity: UserService.isDarkMode.value ? 0.45 : 0.85,
      depth: UserService.isDarkMode.value ? 4 : 8,
      boxShape: NeumorphicBoxShape.circle(),
      color: UserService.isDarkMode.value ? SonrColor.White : SonrColor.Dark,
      shadowLightColor: Colors.black38);

  static get shareButton => NeumorphicStyle(
        color: Colors.black87,
        surfaceIntensity: 0.6,
        intensity: UserService.isDarkMode.value ? 0.45 : 0.85,
        depth: UserService.isDarkMode.value ? 4 : 8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
      );

  static get timeStamp => NeumorphicStyle(
      intensity: 0.4,
      depth: UserService.isDarkMode.value ? 4 : 8,
      boxShape: NeumorphicBoxShape.stadium(),
      color: UserService.isDarkMode.value ? SonrColor.White : SonrColor.Dark);

  static get timeStampDark => NeumorphicStyle(
      intensity: 0.4,
      depth: UserService.isDarkMode.value ? 4 : 8,
      boxShape: NeumorphicBoxShape.stadium(),
      color: UserService.isDarkMode.value ? SonrColor.White : SonrColor.Dark);

  static get toggle => NeumorphicStyle(
        intensity: UserService.isDarkMode.value ? 0.25 : 0.5,
        depth: UserService.isDarkMode.value ? 4 : 6,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        color: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      );

  static zonePath({@required Position_Proximity proximity}) => NeumorphicStyle(
        border: NeumorphicBorder(
          color: UserService.isDarkMode.value ? SonrColor.White : SonrColor.Grey,
          width: 1,
        ),
        depth: UserService.isDarkMode.value ? 4 : 8,
        color: UserService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
        surfaceIntensity: 0.6,
        shape: NeumorphicShape.flat,
        intensity: 0.85,
        boxShape: NeumorphicBoxShape.path(ZonePathProvider(proximity)),
      );
}
