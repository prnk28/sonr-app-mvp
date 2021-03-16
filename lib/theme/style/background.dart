import 'dart:ui';
import '../theme.dart';

class GradientBackground extends StatelessWidget {
  final double blurRadius;
  final Widget child;

  const GradientBackground({Key key, this.blurRadius = 8.0, @required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double blurSigma = blurRadius * 0.57735 + 0.5;
    final double sizeInterval = Get.height / 10;

    return Container(
      width: Get.width,
      height: Get.height,
      child: Stack(children: [
        Align(
          alignment: Alignment.topLeft,
          child: ClipOval(
            child: Container(
              width: sizeInterval * 6,
              height: sizeInterval * 6,
              color: Colors.blue,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ClipOval(
            child: Container(
              width: sizeInterval * 3,
              height: sizeInterval * 3,
              color: Colors.red,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: ClipOval(
            child: Container(
              width: sizeInterval,
              height: sizeInterval,
              color: Colors.green,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(color: const Color(0x0), child: child),
        ),
      ]),
    );
  }
}
