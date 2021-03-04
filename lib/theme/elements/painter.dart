import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../style/style.dart';
import 'package:sonr_core/sonr_core.dart';

import '../theme.dart';

// ^ Arrow Painter for Dropdown ^ //
class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 4);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

// ^ Circle Ripple Painter ^ //
class CirclePainter extends CustomPainter {
  CirclePainter(this._animation) : super(repaint: _animation);

  final Animation<double> _animation;

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (0.8 - (value / 3.5)).clamp(0.0, 0.8);
    final Color _color = SonrColor.Red.withOpacity(opacity);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = sqrt(area * value / 2);
    final Paint paint = Paint()..color = _color;
    // paint.style = PaintingStyle.stroke;
    // paint.strokeWidth = 20;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, Get.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}

// ^ Curved Wave for Animation Curve ^ //
class CurveWave extends Curve {
  const CurveWave();
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return sin(t * pi);
  }
}

// ^ Icon Wave Painter ^ //
class IconWavePainter extends CustomPainter {
  final _pi2 = 2 * pi;
  final GlobalKey iconKey;
  final Animation<double> waveAnimation;
  final double percent;
  final double boxHeight;
  final Gradient gradient;

  IconWavePainter({
    @required this.iconKey,
    this.waveAnimation,
    this.percent,
    this.boxHeight,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RenderBox iconBox = iconKey.currentContext.findRenderObject();
    final iconHeight = iconBox.size.height;
    final baseHeight = (boxHeight / 2) + (iconHeight / 2) - (percent * iconHeight);

    final width = size.width ?? 325;
    final height = size.height ?? 325;
    final path = Path();
    path.moveTo(0.0, baseHeight);
    for (var i = 0.0; i < width; i++) {
      path.lineTo(
        i,
        baseHeight + sin((i / width * _pi2) + (waveAnimation.value * _pi2)) * 8,
      );
    }

    path.lineTo(width, height);
    path.lineTo(0.0, height);
    path.close();
    final wavePaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, width, height),
      );
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// ^ Offset Extension for Common Locations ^ //
extension SonrOffset on Offset {
  static const Offset Top = Offset(0.0, -1.0);
  static const Offset Bottom = Offset(0.0, 1.0);
  static const Offset Left = Offset(-1.0, 0.0);
  static const Offset Right = Offset(1.0, 0.0);

  static Offset fromDegrees(double deg) {
    var rad = (deg * pi) / 180.0;
    var dx = cos(rad);
    var dy = sin(rad);
    return Offset(dx * (Get.width / 4), dy * (Get.height / 8));
  }

  static Offset fromProximity(Position_Proximity prox, double dir) {
    // Get Path Metric
    PathMetric pathMetric = ZonePathProvider(prox, widgetSize: 90).path.computeMetrics().elementAt(0);

    // Determine Point on Path
    double adjustedNorth = DeviceService.direction.value.headingForCameraMode;
    double posOnPath = (adjustedNorth - dir).clamp(0, ZonePathProvider.length(90));
    print(posOnPath);

    // Get Position on Path
    Tangent pos = pathMetric.getTangentForOffset(posOnPath);
    return pos.position;
  }
}

// ^ Wave Painter for File Progress ^ //
class WavePainter extends CustomPainter {
  final _pi2 = 2 * pi;
  final Animation<double> waveAnimation;
  final double percent;
  final Gradient gradient;

  WavePainter({
    this.waveAnimation,
    this.percent,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baseHeight = (size.height + 10) - (percent * size.height);
    final path = Path();
    path.moveTo(0.0, baseHeight);
    for (var i = 0.0; i < size.width; i++) {
      path.lineTo(
        i,
        baseHeight + sin((i / size.width * _pi2) + (waveAnimation.value * _pi2)) * 16,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    final wavePaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCenter(center: Offset.zero, width: size.width, height: size.height),
      );
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// ^ Provides Zone Path by Position Proximity ^ //
class ZonePathProvider extends NeumorphicPathProvider {
  final Position_Proximity proximity;
  final double widgetSize;

  ZonePathProvider(this.proximity, {this.widgetSize = 0});
  Path get path => getPath(Size.infinite);
  static double length(double angle) => angle * sqrt((Get.height / 2 * Get.height / 2) / 2);

  @override
  bool shouldReclip(NeumorphicPathProvider oldClipper) {
    return true;
  }

  @override
  Path getPath(Size size) {
    // Initialize Bounds
    final double height = (Get.height / 2) + (widgetSize / 2);
    final double radius = sqrt((Get.height / 2 * Get.height / 2) / 2);

    // Build Rects
    var distantRect = Rect.fromCircle(center: Offset(Get.width / 2, height - 120), radius: radius);
    var nearRect = Rect.fromCircle(center: Offset(Get.width / 2, height - 20), radius: radius);
    var immediateRect = Rect.fromCircle(center: Offset(Get.width / 2, height + 80), radius: radius);

    // Check Proximity Status
    switch (proximity) {
      case Position_Proximity.Immediate:
        Path path = new Path();
        path.addArc(immediateRect, pi, pi);
        return path;
        break;
      case Position_Proximity.Near:
        Path path = new Path();
        path.addArc(nearRect, pi, pi);
        return path;
        break;
      case Position_Proximity.Distant:
        Path path = new Path();
        path.addArc(distantRect, pi, pi);
        return path;
        break;
      default:
        return Path()
          ..moveTo(0, 0)
          ..lineTo(Get.width / 2, 0)
          ..lineTo(Get.width, height / 2)
          ..lineTo(Get.width / 2, height / 2)
          ..lineTo(Get.width, height)
          ..lineTo(0, height)
          ..close();
        break;
    }
  }

  @override
  bool get oneGradientPerPath => true;
}
