import 'dart:ui';
import 'package:sonr_app/theme/theme.dart';

// ^ Standardized Uniform Scaffold ^ //
class SonrScaffold extends StatelessWidget {
  final Widget body;
  final Widget bottomSheet;
  final Widget bottomNavigationBar;
  final Widget floatingAction;
  final PreferredSizeWidget appBar;
  final bool resizeToAvoidBottomInset;
  final FlutterGradientNames gradientName;

  SonrScaffold({
    Key key,
    this.body,
    this.appBar,
    this.resizeToAvoidBottomInset,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.floatingAction,
    this.gradientName = FlutterGradientNames.northMiracle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: UserService.isDarkMode ? SonrColor.Black.withOpacity(0.75) : SonrColor.White.withOpacity(0.75),
          body: Stack(
            children: [
              // Gradient
              _BackgroundGradient(gradientName: gradientName),

              // Overlay Color
              UserService.isDarkMode
                  ? Container(
                      height: Get.height,
                      width: Get.width,
                      color: SonrColor.Black.withOpacity(0.85),
                    )
                  : Container(
                      height: Get.height,
                      width: Get.width,
                      color: SonrColor.White.withOpacity(0.85),
                    ),

              // Blue
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.1188, sigmaY: 5.1188),
                child: Container(width: Get.width, height: Get.height),
              ),
              SafeArea(child: body),
              Align(
                alignment: Alignment.bottomCenter,
                child: DeviceService.keyboardVisible.value ? Container() : floatingAction,
              )
            ],
          ),
          appBar: appBar,
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
        ));
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
