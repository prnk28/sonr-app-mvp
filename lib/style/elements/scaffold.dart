import 'dart:ui';
import 'package:sonr_app/style.dart';
import 'dart:math';

/// @ Standardized Uniform Scaffold
class SonrScaffold extends StatelessWidget {
  final Widget? body;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final Widget? floatingAction;
  final PreferredSizeWidget? appBar;
  final bool? resizeToAvoidBottomInset;
  final Gradient? gradient;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  SonrScaffold({
    Key? key,
    this.body,
    this.appBar,
    this.resizeToAvoidBottomInset,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.floatingAction,
    this.gradient,
    this.floatingActionButtonLocation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SonrTheme.backgroundColor,
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: floatingActionButtonLocation ?? _FixedCenterDockedFabLocation(),
      body: SafeArea(child: body ?? Container()),
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingAction,
      bottomSheet: bottomSheet,
    );
  }
}

/// @ Fixed Location for Center Docked
class _FixedCenterDockedFabLocation extends FloatingActionButtonLocation {
  const _FixedCenterDockedFabLocation();

  @protected
  double getDockedY(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;
    double bottomDistance = MediaQuery.of(Get.context!).viewInsets.bottom;
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
