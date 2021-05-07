import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import '../style.dart';

/// ^ Arrow Painter for Dropdown ^ //
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

/// ^ Circle Ripple Painter ^ //
class CirclePainter extends CustomPainter {
  CirclePainter(this._animation) : super(repaint: _animation);

  final Animation<double> _animation;

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1 - (value / 3.5)).clamp(0.0, 0.8);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = sqrt(area * value / 2);
    final Paint paint = Paint()..color = SonrColor.Critical.withOpacity(opacity);
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

/// ^ Curved Wave for Animation Curve ^ //
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

/// ^ Icon Wave Painter ^ //
class IconWavePainter extends CustomPainter {
  final _pi2 = 2 * pi;
  final GlobalKey iconKey;
  final Animation<double>? waveAnimation;
  final double? percent;
  final double? boxHeight;
  final Gradient? gradient;

  IconWavePainter({
    required this.iconKey,
    this.waveAnimation,
    this.percent,
    this.boxHeight,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RenderBox iconBox = iconKey.currentContext!.findRenderObject() as RenderBox;
    final iconHeight = iconBox.size.height;
    final baseHeight = (boxHeight! / 2) + (iconHeight / 2) - (percent! * iconHeight);

    final width = size.width;
    final height = size.height;
    final path = Path();
    path.moveTo(0.0, baseHeight);
    for (var i = 0.0; i < width; i++) {
      path.lineTo(
        i,
        baseHeight + sin((i / width * _pi2) + (waveAnimation!.value * _pi2)) * 8,
      );
    }

    path.lineTo(width, height);
    path.lineTo(0.0, height);
    path.close();
    final wavePaint = Paint()
      ..shader = gradient!.createShader(
        Rect.fromLTWH(0, 0, width, height),
      );
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PolygonPathDrawer {
  final Path path;
  final Size size;
  final PolygonPathSpecs specs;

  PolygonPathDrawer({
    required this.size,
    required this.specs,
  }) : path = Path();

  Path draw() {
    final anglePerSide = 360 / specs.sides;

    final radius = (size.width - specs.borderRadiusAngle) / 2;
    final arcLength = (radius * _angleToRadian(specs.borderRadiusAngle)) + (specs.sides * 2);

    Path path = Path();

    for (var i = 0; i <= specs.sides; i++) {
      double currentAngle = anglePerSide * i;
      bool isFirst = i == 0;

      if (specs.borderRadiusAngle > 0) {
        _drawLineAndArc(path, currentAngle, radius, arcLength, isFirst);
      } else {
        _drawLine(path, currentAngle, radius, isFirst);
      }
    }

    return path;
  }

  _drawLine(Path path, double currentAngle, double radius, bool move) {
    Offset current = _getOffset(currentAngle, radius);

    if (move) {
      path.moveTo(current.dx, current.dy);
    } else {
      path.lineTo(current.dx, current.dy);
    }
  }

  _drawLineAndArc(Path path, double currentAngle, double radius, double arcLength, bool isFirst) {
    double prevAngle = currentAngle - specs.halfBorderRadiusAngle;
    double nextAngle = currentAngle + specs.halfBorderRadiusAngle;

    Offset previous = _getOffset(prevAngle, radius);
    Offset next = _getOffset(nextAngle, radius);

    if (isFirst) {
      path.moveTo(next.dx, next.dy);
    } else {
      path.lineTo(previous.dx, previous.dy);
      path.arcToPoint(next, radius: Radius.circular(arcLength));
    }
  }

  double _angleToRadian(double angle) {
    return angle * (pi / 180);
  }

  Offset _getOffset(double angle, double radius) {
    final rotationAwareAngle = angle - 90 + specs.rotate;

    final radian = _angleToRadian(rotationAwareAngle);
    final x = cos(radian) * radius + radius + specs.halfBorderRadiusAngle;
    final y = sin(radian) * radius + radius + specs.halfBorderRadiusAngle;

    return Offset(x, y);
  }
}

class PolygonPathSpecs {
  final int sides;
  final double rotate;
  final double borderRadiusAngle;
  final double halfBorderRadiusAngle;

  PolygonPathSpecs({
    required this.sides,
    required this.rotate,
    required this.borderRadiusAngle,
  }) : halfBorderRadiusAngle = borderRadiusAngle / 2;
}

/// ^ Offset Extension for Common Locations ^ //
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
}

/// ^ Wave Painter for File Progress ^ //
class WavePainter extends CustomPainter {
  final _pi2 = 2 * pi;
  final Animation<double>? waveAnimation;
  final double? percent;
  final Gradient? gradient;

  WavePainter({
    this.waveAnimation,
    this.percent,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baseHeight = (size.height + 10) - (percent! * size.height);
    final path = Path();
    path.moveTo(0.0, baseHeight);
    for (var i = 0.0; i < size.width; i++) {
      path.lineTo(
        i,
        baseHeight + sin((i / size.width * _pi2) + (waveAnimation!.value * _pi2)) * 16,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    final wavePaint = Paint()
      ..shader = gradient!.createShader(
        Rect.fromCenter(center: Offset.zero, width: size.width, height: size.height),
      );
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/// ^ Hexagon Shape Path ^ //
class ZoneClip extends CustomClipper<Path> {
  // References
  final Position_Proximity proximity;
  ZoneClip(this.proximity);

  /// ^ Returns Path Size ^
  static double arcLength(double angle) {
    return sqrt((Get.height / 2 * Get.height / 2) / 2) * angle;
  }

  @override
  getClip(Size size) {
    // Initialize Bounds
    final double height = (Get.height / 2);
    final double width = (Get.width / 2);
    final double radius = sqrt((Get.height / 2 * Get.height / 2) / 2);

    // Bottom Zone
    if (proximity == Position_Proximity.Immediate) {
      // Build Rect
      var immediateRect = Rect.fromCircle(center: Offset(width, height * 1.25), radius: radius);
      Path path = Path();
      path.addArc(immediateRect, pi, pi);
      return path;
      // Return Path
    }
    // Middle Zone
    else if (proximity == Position_Proximity.Near) {
      // Build Rect
      var nearRect = Rect.fromCircle(center: Offset(width, height), radius: radius);

      // Return Path
      Path path = Path();
      path.addArc(nearRect, pi, pi);
      return path;
    }
    // Top Zone
    else {
      // Build Rect
      var distantRect = Rect.fromCircle(center: Offset(width, height * 0.75), radius: radius);

      // Return Path
      Path path = Path();
      path.addArc(distantRect, pi, pi);
      return path;
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
