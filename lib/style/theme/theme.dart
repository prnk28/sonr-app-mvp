import 'package:sonr_app/style/style.dart';

/// Class Handles Theme Data and General Dark Mode Features
class AppTheme {
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
        backgroundColor: Colors.white,
        dividerColor: Color(0xffEBEBEB),
        scaffoldBackgroundColor: SonrColor.White.withOpacity(0.75),
        splashColor: Colors.transparent,
        errorColor: SonrColor.Critical,
        focusColor: SonrColor.Black,
        hintColor: Color(0xff8E8E93),
        cardColor: Color(0xffF6F6F6),
        canvasColor: Color(0xffF6F6F6),
        shadowColor: Color(0xffc7ccd0),
        splashFactory: const NoSplashFactory(),
      );

  /// Returns Dark Theme for App
  static ThemeData get DarkTheme => ThemeData(
        brightness: Brightness.dark,
        dividerColor: Color(0xff4E4949),
        primaryColor: SonrColor.Primary,
        backgroundColor: Color(0xff15162D),
        scaffoldBackgroundColor: SonrColor.Black.withOpacity(0.85),
        splashColor: Colors.transparent,
        errorColor: SonrColor.Critical,
        focusColor: SonrColor.White,
        hintColor: Color(0xffBFBFC3),
        cardColor: Color(0xff2f2a2a).withOpacity(0.75),
        canvasColor: Color(0xff212244),
        shadowColor: Color(0xff2f2a2a),
        splashFactory: const NoSplashFactory(),
      );

  /// Returns Current Text Color
  static Color get BackgroundColor => Get.isDarkMode ? Color(0xff15162D) : Colors.white;

  static Color get DividerColor => Get.isDarkMode ? Color(0xff4E4949) : Color(0xffEBEBEB);

  static Color get ForegroundColor => Get.isDarkMode ? Color(0xff212244) : Color(0xffF6F6F6);

  /// Returns Current Text Color
  static Color get ItemColor => Get.isDarkMode ? SonrColor.White : SonrColor.Black;

  /// Returns Current Text Color
  static Color get ItemColorInversed => Get.isDarkMode ? SonrColor.Black : SonrColor.White;

  /// Returns Current Shadow Color
  static Color get ShadowColor => Get.isDarkMode ? Colors.black.withOpacity(0.4) : Color(0xffD4D7E0).withOpacity(0.75);

  /// Return Current Box Shadow
  static List<BoxShadow> get RectBoxShadow => Get.isDarkMode
      ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: Offset(0, 10),
            blurRadius: 15,
          )
        ]
      : [
          BoxShadow(
            color: Color(0xffD4D7E0).withOpacity(0.75),
            offset: Offset(0, 20),
            blurRadius: 30,
          )
        ];

  /// Circle Box Shadow
  static List<BoxShadow> get CircleBoxShadow => [
        BoxShadow(
          offset: Offset(2, 2),
          blurRadius: 8,
          color: SonrColor.Black.withOpacity(0.2),
        ),
      ];

  /// Return Current Box Shadow
  static List<PolygonBoxShadow> get PolyBoxShadow => Get.isDarkMode
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
  static Color get GreyColor => Get.theme.hintColor;
}
