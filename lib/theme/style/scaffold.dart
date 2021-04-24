import 'dart:ui';
import 'package:sonr_app/theme/theme.dart';
import 'dart:math';

// ^ Standardized Uniform Scaffold ^ //
class SonrScaffold extends StatelessWidget {
  final Widget body;
  final Widget bottomSheet;
  final Widget bottomNavigationBar;
  final Widget floatingAction;
  final PreferredSizeWidget appBar;
  final bool resizeToAvoidBottomInset;
  final Function bodyAction;
  final FlutterGradientNames gradientName;

  SonrScaffold({
    Key key,
    this.body,
    this.appBar,
    this.resizeToAvoidBottomInset,
    this.bodyAction,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.floatingAction,
    this.gradientName = FlutterGradientNames.northMiracle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PageBackground(
      gradientName: gradientName,
      scaffold: NeumorphicTheme(
        themeMode: UserService.isDarkMode ? ThemeMode.dark : ThemeMode.light, //or dark / system
        darkTheme: NeumorphicThemeData(
          defaultTextColor: Colors.white,
          baseColor: SonrColor.Black,
          lightSource: LightSource.topLeft,
        ),
        theme: NeumorphicThemeData(
          defaultTextColor: SonrColor.Black,
          baseColor: SonrColor.White,
          lightSource: LightSource.topLeft,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButtonLocation: FixedCenterDockedFabLocation(),
          body: body,
          appBar: appBar,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingAction,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          bottomSheet: bottomSheet,
        ),
      ),
    );
  }
}

class PageBackground extends StatelessWidget {
  final Widget scaffold;
  final FlutterGradientNames gradientName;
  const PageBackground({Key key, this.scaffold, this.gradientName}) : super(key: key);
  @override
  Widget build(Object context) {
    return NeumorphicBackground(
      backendColor: Colors.transparent,
      child: Stack(
        children: [
          // Gradient
          _BackgroundGradient(gradientName: gradientName),

          // Overlay Color
          _BackgroundOverlay(),

          // Blue
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.1188, sigmaY: 5.1188),
            child: Container(width: Get.width, height: Get.height),
          ),
          scaffold
        ],
      ),
    );
  }
}

class FixedCenterDockedFabLocation extends FloatingActionButtonLocation {
  const FixedCenterDockedFabLocation();

  @protected
  double getDockedY(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;
    double bottomDistance = MediaQuery.of(Get.context).viewInsets.bottom;
    double fabY = contentBottom + bottomDistance - fabHeight / 2.0;

    // The FAB should sit with a margin between it and the snack bar.
    if (snackBarHeight > 0.0) fabY = min(fabY, contentBottom - snackBarHeight - fabHeight - kFloatingActionButtonMargin);
    // The FAB should sit with its center in front of the top of the bottom sheet.
    if (bottomSheetHeight > 0.0) fabY = min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);

    final double maxFabY = scaffoldGeometry.scaffoldSize.height - fabHeight;
    return min(maxFabY, fabY);
  }

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2.0;
    return Offset(fabX, getDockedY(scaffoldGeometry));
  }
}

// ^ Animated Background Gradient ^ //
class _BackgroundGradient extends StatelessWidget {
  final FlutterGradientNames gradientName;
  const _BackgroundGradient({Key key, this.gradientName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (gradientName != FlutterGradientNames.northMiracle) {
      return CustomAnimatedWidget(
          enabled: true,
          duration: Duration(seconds: 4),
          curve: Curves.easeOut,
          builder: (context, percent) {
            return Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                color: UserService.isDarkMode ? SonrColor.Black : SonrColor.White,
                gradient: FlutterGradients.northMiracle(type: GradientType.radial, center: Alignment.topLeft, radius: 2.5)
                    // ignore: invalid_use_of_protected_member
                    .lerpTo(FlutterGradients.findByName(gradientName), percent),
              ),
            );
          });
    } else {
      return Opacity(
        opacity: 0.5,
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            color: UserService.isDarkMode ? SonrColor.Black : SonrColor.White,
            gradient: FlutterGradients.northMiracle(type: GradientType.radial, center: Alignment.topLeft, radius: 2.5),
          ),
        ),
      );
    }
  }
}

class _BackgroundOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserService.isDarkMode
        ? Container(
            height: Get.height,
            width: Get.width,
            color: SonrColor.Black.withOpacity(0.75),
          )
        : Container(
            height: Get.height,
            width: Get.width,
            color: SonrColor.White.withOpacity(0.75),
          );
  }
}
