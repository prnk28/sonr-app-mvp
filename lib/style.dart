export 'data/core/logger.dart';
export 'package:flutter/services.dart';
export 'package:get/get.dart' hide Node;
export 'package:flutter/material.dart' hide Route;
export 'package:supercharged/supercharged.dart';
export 'package:flutter/services.dart';
export 'package:feedback/feedback.dart';
export 'dart:typed_data';
export 'package:path_provider/path_provider.dart';
export 'package:flutter_compass/flutter_compass.dart';
export 'package:open_file/open_file.dart';
export 'package:sonr_app/style/elements/painter.dart';
export 'package:animate_do/animate_do.dart';
export 'package:sonr_app/modules/camera/camera.dart';
export 'package:sonr_app/data/data.dart';

// Custom Theme Buttons
export 'style/buttons/action.dart';
export 'style/buttons/arrow.dart';
export 'style/buttons/color.dart';
export 'style/buttons/plain.dart';
export 'style/buttons/confirm.dart';
export 'style/buttons/image.dart';

// Theme Components
export 'style/components/color.dart';
export 'style/components/gradient.dart';
export 'style/components/icon.dart';
export 'style/components/overlay.dart';
export 'style/components/shape.dart';
export 'style/components/text.dart';

// Common Widgets
export 'style/common/sname_field.dart';

// Theme Models
export 'style/models/direction.dart';
export 'style/models/type.dart';

// Custom Theme Elements
export 'style/elements/shape.dart';
export 'style/elements/painter.dart';
export 'style/elements/scaffold.dart';
export 'style/elements/appbar.dart';
export 'style/elements/animation.dart';
export 'style/elements/image.dart';

// Form Styles
export 'style/form/checklist.dart';
export 'style/form/infolist.dart';
export 'style/form/textfield.dart';
export 'style/form/tabs.dart';

// UI Packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style/elements/painter.dart';
import 'style/components/color.dart';

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

  /// Returns Light Theme for App
  static ThemeData get LightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: SonrColor.Primary,
        backgroundColor: SonrColor.White,
        dividerColor: Colors.white.withOpacity(0.65),
        scaffoldBackgroundColor: SonrColor.White.withOpacity(0.75),
        splashColor: SonrColor.Primary.withOpacity(0.2),
        errorColor: SonrColor.Critical,
        accentColor: SonrColor.Secondary,
        focusColor: SonrColor.Black,
        hintColor: SonrColor.Grey,
        cardColor: Color(0xfff0f6fa).withOpacity(0.85),
        canvasColor: Color(0xffffffff).withOpacity(0.75),
        shadowColor: Color(0xffc7ccd0),
      );

  /// Returns Dark Theme for App
  static ThemeData get DarkTheme => ThemeData(
        brightness: Brightness.dark,
        dividerColor: SonrColor.Black.withOpacity(0.65),
        primaryColor: SonrColor.Primary,
        backgroundColor: SonrColor.Black,
        scaffoldBackgroundColor: SonrColor.Black.withOpacity(0.85),
        splashColor: SonrColor.Primary.withOpacity(0.2),
        errorColor: SonrColor.Critical,
        accentColor: SonrColor.AccentPurple,
        focusColor: SonrColor.White,
        hintColor: SonrColor.LightGrey,
        cardColor: Color(0xff2f2a2a).withOpacity(0.75),
        canvasColor: Color(0xff3e3737),
        shadowColor: Color(0xff2f2a2a),
      );

  /// Returns Current Text Color
  static Color get backgroundColor => ContactService.isDarkMode ? Colors.black : Colors.white;

  static Color get dividerColor => ContactService.isDarkMode ? Color(0xff4E4949) : Color(0xffEBEBEB);

  static Color get foregroundColor => ContactService.isDarkMode ? Color(0xff212121) : Color(0xffF6F6F6);

  /// Returns Current Text Color
  static Color get itemColor => ContactService.isDarkMode ? SonrColor.White : SonrColor.Black;

  /// Returns Current Text Color
  static Color get itemColorInversed => ContactService.isDarkMode ? SonrColor.Black : SonrColor.White;

  /// Return Current Box Shadow
  static List<BoxShadow> get boxShadow => ContactService.isDarkMode
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

  static List<BoxShadow> get circleBoxShadow => [
        BoxShadow(
          offset: Offset(2, 2),
          blurRadius: 8,
          color: SonrColor.Black.withOpacity(0.2),
        ),
      ];

  /// Return Current Box Shadow
  static List<PolygonBoxShadow> get polyBoxShadow => ContactService.isDarkMode
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

/// * Widget Extensions * //
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
