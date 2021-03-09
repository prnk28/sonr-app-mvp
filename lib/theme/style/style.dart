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
import '../theme.dart';
import 'color.dart';

class SonrStyle {
  static get compassStamp => NeumorphicStyle(intensity: 0.4, depth: 8, boxShape: NeumorphicBoxShape.stadium(), color: Colors.black87);

  static get dropDownBackground => NeumorphicStyle(
      intensity: DeviceService.isDarkMode.value ? 0.45 : 0.85,
      depth: DeviceService.isDarkMode.value ? 6 : 8,
      shape: NeumorphicShape.flat,
      color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      shadowLightColor: Colors.black38);

  static get dropDownItem => NeumorphicStyle(
        intensity: DeviceService.isDarkMode.value ? 0.45 : 0.85,
        depth: DeviceService.isDarkMode.value ? 6 : 8,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.stadium(),
        color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      );

  static get dropDownFlat => NeumorphicStyle(
        intensity: DeviceService.isDarkMode.value ? 0.45 : 0.85,
        depth: DeviceService.isDarkMode.value ? 6 : 8,
        shape: NeumorphicShape.flat,
        color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      );
  static get dropDownCurved => NeumorphicStyle(
        intensity: DeviceService.isDarkMode.value ? 0.45 : 0.85,
        depth: DeviceService.isDarkMode.value ? 6 : 8,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.stadium(),
        color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      );

  static get flat => NeumorphicStyle(
        intensity: DeviceService.isDarkMode.value ? 0.45 : 0.85,
        depth: DeviceService.isDarkMode.value ? 6 : 8,
        shape: NeumorphicShape.flat,
        color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      );

  static get gradientIcon =>
      NeumorphicStyle(color: SonrColor.White, shadowLightColor: Colors.transparent, intensity: 0.85, depth: 6, surfaceIntensity: 0.6);

  static get appBarIcon =>
      NeumorphicStyle(color: SonrColor.White, shadowLightColor: SonrColor.neuoIconShadow, intensity: 0.65, depth: 2, surfaceIntensity: 0.6);

  static get indented => NeumorphicStyle(
      color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      depth: -8,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)));
  static get overlay => NeumorphicStyle(
        intensity: DeviceService.isDarkMode.value ? 0.45 : 0.85,
        depth: DeviceService.isDarkMode.value ? 6 : 8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      );

  static get mediaButtonDefault => NeumorphicStyle(intensity: 0.85, color: SonrColor.White);
  static get mediaButtonPressed => NeumorphicStyle(depth: -12, intensity: 0.85, shadowDarkColorEmboss: Colors.grey[700]);

  static get normal => NeumorphicStyle(
      depth: DeviceService.isDarkMode.value ? 6 : 8,
      color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
      intensity: DeviceService.isDarkMode.value ? 0.45 : 0.85,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
      shadowDarkColor: SonrColor.LightModeShadowDark,
      shadowLightColor: SonrColor.LightModeShadowLight);

  static get photo => NeumorphicStyle(
      intensity: DeviceService.isDarkMode.value ? 0.45 : 0.85,
      depth: DeviceService.isDarkMode.value ? 6 : 8,
      boxShape: NeumorphicBoxShape.circle(),
      color: DeviceService.isDarkMode.value ? SonrColor.White : SonrColor.Dark,
      shadowLightColor: Colors.black38);

  static get shareButton => NeumorphicStyle(
        color: Colors.black87,
        surfaceIntensity: 0.6,
        intensity: DeviceService.isDarkMode.value ? 0.45 : 0.85,
        depth: 8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
      );

  static get timeStamp => NeumorphicStyle(
      intensity: 0.4, depth: 8, boxShape: NeumorphicBoxShape.stadium(), color: DeviceService.isDarkMode.value ? SonrColor.White : SonrColor.Dark);

  static get timeStampDark => NeumorphicStyle(
      intensity: 0.4, depth: 8, boxShape: NeumorphicBoxShape.stadium(), color: DeviceService.isDarkMode.value ? SonrColor.White : SonrColor.Dark);

  static zonePath({@required Position_Proximity proximity}) => NeumorphicStyle(
        border: NeumorphicBorder(
          color: DeviceService.isDarkMode.value ? SonrColor.White : SonrColor.Grey,
          width: 1,
        ),
        depth: 8,
        color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
        surfaceIntensity: 0.6,
        shape: NeumorphicShape.flat,
        intensity: 0.85,
        boxShape: NeumorphicBoxShape.path(ZonePathProvider(proximity)),
      );
}
