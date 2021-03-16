import 'dart:ui';
import 'package:get/get.dart';
import 'package:sonr_app/service/device_service.dart';
import '../style/style.dart';

final darkBoxShadow = [
  BoxShadow(color: Color(0xff464545).withOpacity(0.2), blurRadius: 20, offset: Offset(8, 8)),
  BoxShadow(color: Color(0xff121111).withOpacity(0.4), blurRadius: 20, offset: Offset(-8, -8))
];

final lightBoxShadow = [
  BoxShadow(color: Color(0xffFFFFFF).withOpacity(0.2), blurRadius: 20, offset: Offset(8, 8)),
  BoxShadow(color: Color(0xff6C8DC2).withOpacity(0.4), blurRadius: 20, offset: Offset(-8, -8))
];

class GlassContainer extends StatelessWidget {
  final double blurRadius, width, height;
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;

  const GlassContainer({
    Key key,
    this.width,
    this.height,
    this.blurRadius = 4.0,
    this.child,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double blurSigma = blurRadius * 0.57735 + 0.5;
    final borderRadius = BorderRadius.circular(20);

    return Container(
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      child: Obx(() => Stack(
            clipBehavior: Clip.none,
            children: [
              ClipPath(
                clipper: _InvRRectClipper(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    boxShadow: DeviceService.isDarkMode.value ? darkBoxShadow : lightBoxShadow,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  // Fill Opacity
                  color: DeviceService.isDarkMode.value ? SonrColor.black.withOpacity(0.50) : Colors.white.withOpacity(0.50),
                  borderRadius: borderRadius,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    backgroundBlendMode: BlendMode.overlay,
                    borderRadius: borderRadius,
                    // Object Opacity
                    gradient: LinearGradient(
                      colors: DeviceService.isDarkMode.value
                          ? [SonrColor.black.withOpacity(0.8), SonrColor.black.withOpacity(0.15)]
                          : [Colors.white.withOpacity(0.8), Colors.white.withOpacity(0.15)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )),
                clipBehavior: Clip.antiAlias,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                  child: Container(margin: EdgeInsets.all(8), color: const Color(0x0), child: child),
                ),
              ),
              IgnorePointer(
                child: Container(
                  foregroundDecoration: BoxDecoration(
                      border: DeviceService.isDarkMode.value
                          ? Border.all(color: SonrColor.black.withOpacity(0.4), width: 2)
                          : Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                      borderRadius: borderRadius),
                ),
              ),
            ],
          )),
    );
  }
}

class _InvRRectClipper extends CustomClipper<Path> {
  final double radius;

  _InvRRectClipper([this.radius = 12]);

  @override
  Path getClip(Size size) {
    final p = Path()
      ..addRRect(RRect.fromLTRBR(
        0,
        0,
        size.width,
        size.height,
        Radius.circular(radius),
      ))
      ..addRect(Rect.largest)
      ..fillType = PathFillType.evenOdd;
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
