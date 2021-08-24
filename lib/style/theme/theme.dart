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
    Get.changeTheme(isDark ? AppTheme.DarkTheme : AppTheme.LightTheme);
  }

  /// Returns Light Theme for App
  static ThemeData get LightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColor.Blue,
        backgroundColor: Colors.white,
        dividerColor: Color(0xffEBEBEB),
        scaffoldBackgroundColor: AppColor.White.withOpacity(0.75),
        fontFamily: 'Montserrat',
        splashColor: Colors.transparent,
        errorColor: AppColor.Red,
        focusColor: AppColor.Black,
        hintColor: AppColor.DarkGrey,
        cardColor: Color(0xffF6F6F6),
        canvasColor: Color(0xffF6F6F6),
        shadowColor: AppColor.ShadowLight,
        splashFactory: const NoSplashFactory(),
      );

  /// Returns Dark Theme for App
  static ThemeData get DarkTheme => ThemeData(
        brightness: Brightness.dark,
        dividerColor: Color(0xff4E4949),
        fontFamily: 'Montserrat',
        primaryColor: AppColor.Blue,
        backgroundColor: Color(0xff15162D),
        scaffoldBackgroundColor: AppColor.Black.withOpacity(0.85),
        splashColor: Colors.transparent,
        errorColor: AppColor.Red,
        focusColor: AppColor.White,
        hintColor: AppColor.DarkGrey,
        cardColor: Color(0xff2f2a2a).withOpacity(0.75),
        canvasColor: Color(0xff212244),
        shadowColor: AppColor.ShadowDark,
        splashFactory: const NoSplashFactory(),
      );

  /// Returns Current Text Color
  static Color get BackgroundColor => AppColor.Background(Get.isDarkMode);

  /// Returns Current Divider Color
  static Color get DividerColor => AppColor.Divider(Get.isDarkMode);

  /// Returns Current Foreground Color
  static Color get ForegroundColor => AppColor.Foreground(Get.isDarkMode);

  /// Returns Current Text Color
  static Color get ItemColor => AppColor.Item(Get.isDarkMode);

  /// Returns Current Text Color
  static Color get ItemColorInversed => AppColor.Item(!Get.isDarkMode);

  /// Returns Accent Palette Color
  static Color get AccentColor => AppColor.Accent(Get.isDarkMode);

  /// Returns Current Box Border
  static Border get BoxBorder => Get.isDarkMode
      ? Border.all(
          color: AppTheme.DividerColor,
          width: 0.5,
        )
      : Border.all(
          color: AppTheme.BackgroundColor,
          width: 1,
        );

  /// Returns Current Shadow Color
  static Color get ShadowColor => AppColor.Shadow(Get.isDarkMode);

  /// Return Current Box Shadow
  static List<BoxShadow> get RectBoxShadow => [
        BoxShadow(
          color: AppColor.Shadow(Get.isDarkMode),
          offset: Get.isDarkMode ? Offset(0, 10) : Offset(0, 20),
          blurRadius: Get.isDarkMode ? 15 : 30,
        )
      ];

  /// Circle Box Shadow
  static List<BoxShadow> get CircleBoxShadow => [
        BoxShadow(
          offset: Offset(2, 2),
          blurRadius: 8,
          color: AppColor.Shadow(Get.isDarkMode, lightOpacity: 0.2, darkOpacity: 0.35),
        ),
      ];

  /// Return Current Box Shadow
  static List<PolygonBoxShadow> get PolyBoxShadow => [
        PolygonBoxShadow(
          color: AppColor.Shadow(Get.isDarkMode, lightOpacity: 0.4, darkOpacity: 0.4),
          elevation: 10,
        )
      ];

  /// Returns Current Text Color for Grey
  static Color get GreyColor => Get.theme.hintColor;
}
