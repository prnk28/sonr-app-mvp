export '../service/device.dart';
export '../service/lobby.dart';
export '../service/media.dart';
export '../service/sonr.dart';
export '../service/cards.dart';
export '../service/user.dart';
export 'package:flutter/services.dart';
export 'package:get/get.dart' hide Node;
export 'dart:typed_data';
export 'package:path_provider/path_provider.dart';
export 'package:flutter_compass/flutter_compass.dart';
export 'package:open_file/open_file.dart';

export 'package:animated_widgets/animated_widgets.dart';
export 'package:sonr_app/modules/common/camera/camera_view.dart';
export 'package:sonr_app/modules/common/media/sheet_view.dart';

// Custom Theme Aspects
export 'style/background.dart';
export 'buttons/shape.dart';
export 'buttons/color.dart';
export 'buttons/navigation.dart';
export 'buttons/plain.dart';
export 'buttons/confirm.dart';
export 'style/color.dart';
export 'style/icon.dart';
export 'style/scaffold.dart';
export 'elements/snackbar.dart';
export 'elements/path.dart';
export 'style/text.dart';
export 'animation/animation.dart';

// Global UI Widgets
export 'elements/glass.dart';
export 'elements/painter.dart';
export '../modules/overlay/overlay.dart';
export '../modules/overlay/flat_overlay.dart';
export 'form/dropdown.dart';
export 'form/radio.dart';
export 'form/textfield.dart';

// UI Packages
export 'package:flutter_neumorphic/flutter_neumorphic.dart';
export 'package:supercharged/supercharged.dart';
export 'package:flutter_custom_clippers/flutter_custom_clippers.dart' hide ArrowClipper;
export 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/user.dart';
import 'package:sonr_core/sonr_core.dart';

import 'elements/painter.dart';
import 'style/color.dart';

enum WidgetPosition { Left, Right, Top, Bottom, Center }

class SonrStyle {
  static Size get viewSize => Size(Get.width * 0.95, Get.height * 0.85);
  static EdgeInsets get viewMargin => EdgeInsets.symmetric(vertical: Get.height * 0.15, horizontal: Get.width * 0.05);

  static NeumorphicStyle get appBarIcon =>
      NeumorphicStyle(color: SonrColor.White, shadowLightColor: SonrColor.neuoIconShadow, intensity: 0.65, depth: 2, surfaceIntensity: 0.6);

  static NeumorphicStyle get compassStamp =>
      NeumorphicStyle(intensity: 0.4, depth: UserService.isDarkMode ? 4 : 8, boxShape: NeumorphicBoxShape.stadium(), color: Colors.black87);

  static NeumorphicStyle get dropDownBackground => NeumorphicStyle(
      intensity: UserService.isDarkMode ? 0.45 : 0.85,
      depth: UserService.isDarkMode ? 4 : 8,
      shape: NeumorphicShape.flat,
      color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
      shadowLightColor: Colors.black38);

  static NeumorphicStyle get dropDownItem => NeumorphicStyle(
        intensity: UserService.isDarkMode ? 0.45 : 0.85,
        depth: UserService.isDarkMode ? 4 : 8,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.stadium(),
        color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
      );

  static NeumorphicStyle get dropDownFlat => NeumorphicStyle(
        intensity: UserService.isDarkMode ? 0.45 : 0.85,
        depth: UserService.isDarkMode ? 4 : 8,
        shape: NeumorphicShape.flat,
        color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
      );
  static NeumorphicStyle get dropDownCurved => NeumorphicStyle(
        intensity: UserService.isDarkMode ? 0.45 : 0.85,
        depth: UserService.isDarkMode ? 4 : 8,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.stadium(),
        color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
      );

  static NeumorphicStyle get flat => NeumorphicStyle(
        intensity: UserService.isDarkMode ? 0.45 : 0.85,
        depth: UserService.isDarkMode ? 4 : 8,
        shape: NeumorphicShape.flat,
        color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
      );

  static NeumorphicStyle get indented => NeumorphicStyle(
      color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White, depth: -8, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)));

  static NeumorphicStyle get gradientIcon => NeumorphicStyle(
      color: SonrColor.White, shadowLightColor: Colors.transparent, intensity: 0.85, depth: UserService.isDarkMode ? 4 : 8, surfaceIntensity: 0.6);

  static NeumorphicStyle get overlay => NeumorphicStyle(
        intensity: UserService.isDarkMode ? 0.45 : 0.85,
        depth: UserService.isDarkMode ? 4 : 8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
      );

  static NeumorphicStyle get normal => NeumorphicStyle(
        depth: UserService.isDarkMode ? 4 : 8,
        color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
        intensity: UserService.isDarkMode ? 0.45 : 0.85,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
      );

  static NeumorphicStyle get photo => NeumorphicStyle(
      intensity: UserService.isDarkMode ? 0.45 : 0.85,
      depth: UserService.isDarkMode ? 4 : 8,
      boxShape: NeumorphicBoxShape.circle(),
      color: UserService.isDarkMode ? SonrColor.White : SonrColor.Dark,
      shadowLightColor: Colors.black38);

  static NeumorphicStyle get shareButton => NeumorphicStyle(
        color: Colors.black87,
        surfaceIntensity: 0.6,
        intensity: UserService.isDarkMode ? 0.45 : 0.85,
        depth: UserService.isDarkMode ? 4 : 8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
      );

  static NeumorphicStyle get timeStamp => NeumorphicStyle(
      intensity: 0.4,
      depth: UserService.isDarkMode ? 4 : 8,
      boxShape: NeumorphicBoxShape.stadium(),
      color: UserService.isDarkMode ? SonrColor.White : SonrColor.Dark);

  static NeumorphicStyle get timeStampDark => NeumorphicStyle(
      intensity: 0.4,
      depth: UserService.isDarkMode ? 4 : 8,
      boxShape: NeumorphicBoxShape.stadium(),
      color: UserService.isDarkMode ? SonrColor.White : SonrColor.Dark);

  static NeumorphicStyle get toggle => NeumorphicStyle(
        intensity: UserService.isDarkMode ? 0.25 : 0.5,
        depth: UserService.isDarkMode ? 4 : 6,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
      );

  static NeumorphicStyle zonePath({@required Position_Proximity proximity}) => NeumorphicStyle(
        border: NeumorphicBorder(
          color: UserService.isDarkMode ? SonrColor.White : SonrColor.Grey,
          width: 1,
        ),
        depth: UserService.isDarkMode ? 4 : 8,
        color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
        surfaceIntensity: 0.6,
        shape: NeumorphicShape.flat,
        intensity: 0.85,
        boxShape: NeumorphicBoxShape.path(ZonePathProvider(proximity)),
      );
}

// ^ Edge Insets Helper Extensions ^ //
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

// ^ Padding Helper Extensions ^ //
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
