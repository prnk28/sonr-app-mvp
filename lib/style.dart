export 'service/device/device.dart';
export 'service/device/desktop.dart';
export 'service/device/mobile.dart';
export 'service/client/transfer.dart';
export 'service/client/lobby.dart';
export 'service/client/sonr.dart';
export 'service/user/user.dart';
export 'data/core/logger.dart';
export 'package:flutter/services.dart';
export 'package:get/get.dart' hide Node;

export 'dart:typed_data';
export 'package:path_provider/path_provider.dart';
export 'package:flutter_compass/flutter_compass.dart';
export 'package:open_file/open_file.dart';
export 'package:sonr_app/style/elements/clipper.dart';
export 'package:animate_do/animate_do.dart';
export 'package:sonr_app/modules/camera/camera_view.dart';
export 'package:sonr_app/data/data.dart';
export 'package:firebase_analytics/firebase_analytics.dart';

// Custom Theme Aspects
export 'style/buttons/action.dart';
export 'style/buttons/color.dart';
export 'style/buttons/plain.dart';
export 'style/buttons/confirm.dart';
export 'style/elements/scaffold.dart';
export 'style/elements/appbar.dart';
export 'style/animation/animation.dart';
export 'style/buttons/image.dart';


// Form Styles
export 'style/form/checklist.dart';
export 'style/form/dropdown.dart';
export 'style/form/textfield.dart';
export 'style/form/tabs.dart';

// Custom Route Aspects
export 'style/route/popup.dart';
export 'style/route/sheet.dart';
export 'style/route/snackbar.dart';

// Global UI Widgets
export 'style/elements/shape.dart';
export 'style/elements/painter.dart';
export 'pages/overlay/overlay.dart';
export 'pages/overlay/controllers/flat_overlay.dart';


// UI Packages
export 'package:flutter/material.dart' hide Route;
export 'package:supercharged/supercharged.dart';
export 'package:flutter/services.dart';
export 'style/design/design.dart';
export 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:sonr_app/service/user/user.dart';
import 'style/design/design.dart';

import 'style/elements/clipper.dart';

/// * Widget Position Enum * //
enum WidgetPosition { Left, Right, Top, Bottom, Center }

/// * Widget List Extension * //
extension WidgetListUtils on List<Widget> {
  /// Accessor Method to Create a Row
  Widget row(
      {Key? key,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
      VerticalDirection verticalDirection = VerticalDirection.down,
      TextDirection? textDirection,
      TextBaseline? textBaseline}) {
    return Row(
      children: this,
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      verticalDirection: verticalDirection,
      textDirection: textDirection ?? textDirection,
      textBaseline: textBaseline ?? textBaseline,
    );
  }

  /// Accessor Method to Create a Column
  Widget column({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextDirection? textDirection,
    TextBaseline? textBaseline,
  }) {
    return Column(
      children: this,
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      verticalDirection: verticalDirection,
      textDirection: textDirection ?? textDirection,
      textBaseline: textBaseline ?? textBaseline,
    );
  }
}

/// * Class that Handles Device Screen Width Management * //
class Width {
  /// Return Full Screen Width
  static double get full => DeviceService.isDesktop ? 1280 : Get.width;

  /// Return Full Screen Width Divided by Value <= ScreenWidth
  static double divided(double val) {
    assert(val <= Get.width);
    return Get.width / val;
  }

  /// Return Width as Ratio from Screen between 0.0 and 1.0
  static double ratio(double ratio) {
    assert(ratio <= 1.0 && ratio > 0.0);
    return Get.width * ratio;
  }

  /// Return Width reduced by given Ratio from Screen between 0.0 and 1.0
  static double reduced(double ratio) {
    assert(ratio <= 1.0 && ratio > 0.0);
    var factor = Get.width * ratio;
    return Get.width - factor;
  }
}

/// * Class that Handles Device Screen Height Management * //
class Height {
  /// Return Full Screen Height
  static double get full => DeviceService.isDesktop ? 800 : Get.height;

  /// Return Full Screen Height Divided by Value <= ScreenHeight
  static double divided(double val) {
    assert(val <= Get.height);
    return Get.height / val;
  }

  /// Return Height as Ratio from Screen between 0.0 and 1.0
  static double ratio(double ratio) {
    assert(ratio <= 1.0 && ratio > 0.0);
    return Get.height * ratio;
  }

  /// Return Height reduced by given Ratio from Screen between 0.0 and 1.0
  static double reduced(double ratio) {
    assert(ratio <= 1.0 && ratio > 0.0);
    var factor = Get.height * ratio;
    return Get.height - factor;
  }
}

/// * Class that Handles Screen Margin Management * //
class Margin {
  static EdgeInsetsGeometry ratio(double vertical, {double horizontal = 24}) {
    var difference = Height.full - Height.ratio(vertical);
    return EdgeInsets.only(left: horizontal, right: horizontal, bottom: difference - horizontal, top: horizontal);
  }

  /// Return Margin as Ratio from Screen between 0.0 and 1.0 for Vertical, Horizontal defaults to 24
  /// Aligns to Center of Screen
  static EdgeInsetsGeometry ratioCentered(double vertical, {double horizontal = 24}) {
    var difference = Height.full - Height.ratio(vertical);
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: difference / 2);
  }
}

/// Class Handles Theme Data and General Dark Mode Features
class SonrTheme {
  /// Method sets [DarkMode] for Device and Updates [ThemeData]
  static void setDarkMode({required bool isDark}) {
    // Dark Mode
    if (isDark) {
      // Set Status Bar
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light));
    }

    // Light Mode
    else {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark));
    }

    // Set Theme Mode
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  /// Returns Primary Gradient
  static Gradient get primaryGradient => RadialGradient(
        colors: [
          Color(0xffFFCF14),
          Color(0xffF3ACFF),
          Color(0xff8AECFF),
        ],
        stops: [0, 0.45, 1],
        center: Alignment.center,
        focal: Alignment.topRight,
        tileMode: TileMode.clamp,
        radius: 0.72,
      );

  static BoxDecoration get cardDecoration => BoxDecoration(
        border: Border.all(color: SonrTheme.backgroundColor, width: 1),
        color: SonrTheme.foregroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: SonrTheme.boxShadow,
      );

  /// Returns Current Text Color
  static Color get backgroundColor => UserService.isDarkMode ? Colors.black : Colors.white;

  static Color get separatorColor => UserService.isDarkMode ? Color(0xff4E4949) : Color(0xffEBEBEB);

  static Color get foregroundColor => UserService.isDarkMode ? Color(0xff212121) : Color(0xffF6F6F6);

  /// Returns Current Text Color
  static Color get textColor => UserService.isDarkMode ? SonrColor.White : SonrColor.Black;

  /// Return Current Box Shadow
  static List<BoxShadow> get boxShadow => UserService.isDarkMode
      ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: Offset(0, 20),
            blurRadius: 30,
          )
        ]
      : [
          BoxShadow(
            color: Color(0xffD4D7E0).withOpacity(0.75),
            offset: Offset(0, 20),
            blurRadius: 30,
          )
        ];

  /// Return Current Box Shadow
  static List<PolygonBoxShadow> get polyBoxShadow => UserService.isDarkMode
      ? [
          PolygonBoxShadow(
            color: Colors.black.withOpacity(0.4),
            elevation: 10,
          )
        ]
      : [
          PolygonBoxShadow(
            color: Color(0xffD4D7E0).withOpacity(0.4),
            elevation: 10,
          )
        ];

  /// Returns Current Text Color for Grey
  static Color get greyColor => Get.theme.hintColor;
}

/// * Widget Position Enum * //
