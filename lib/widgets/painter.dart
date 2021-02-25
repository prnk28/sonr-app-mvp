import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

const double K_ANGLE = pi;

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
    return Offset(dx, dy);
  }
}

// ^ Expanded Bubble Painter ^ //
class ExpandedBubblePainter extends NeumorphicPathProvider {
  @override
  bool shouldReclip(NeumorphicPathProvider oldClipper) {
    return true;
  }

  @override
  Path getPath(Size size) {
    return Path()
      ..moveTo(size.width * 0.2000000, size.height * 0.2000000)
      ..quadraticBezierTo(size.width * -0.0002200, size.height * 0.1989600, 0, size.height * 0.3000000)
      ..lineTo(0, size.height * 0.9000000)
      ..quadraticBezierTo(size.width * 0.0002800, size.height * 0.9993200, size.width * 0.2000000, size.height)
      ..quadraticBezierTo(size.width * 0.1980000, size.height * 1.0025000, size.width * 0.2000000, size.height)
      ..lineTo(size.width * 0.8000000, size.height)
      ..quadraticBezierTo(size.width * 0.8022800, size.height * 1.0046800, size.width * 0.8000000, size.height)
      ..quadraticBezierTo(size.width * 1.0006800, size.height * 1.0005600, size.width, size.height * 0.9000000)
      ..lineTo(size.width, size.height * 0.3000000)
      ..quadraticBezierTo(size.width * 0.9955000, size.height * 0.1994000, size.width * 0.8000000, size.height * 0.2000000)
      ..quadraticBezierTo(size.width * 0.8008200, size.height * 0.1991600, size.width * 0.8000000, size.height * 0.2000000)
      ..lineTo(size.width * 0.7000000, size.height * 0.2000000)
      ..quadraticBezierTo(size.width * 0.7034200, size.height * 0.0004400, size.width * 0.5000000, 0)
      ..quadraticBezierTo(size.width * 0.3006400, size.height * -0.0016400, size.width * 0.3000000, size.height * 0.2000000)
      ..quadraticBezierTo(size.width * 0.1984200, size.height * 0.1971600, size.width * 0.2000000, size.height * 0.2000000)
      ..close();
  }

  @override
  bool get oneGradientPerPath => false;
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

// ^ Zone Painter for Transfer View Lines ^ //
class ZonePainter extends CustomPainter {
  // Size Reference
  var _currentSize;

  @override
  void paint(Canvas canvas, Size size) {
    // Initialize
    _currentSize = size;

    // Setup Paint
    var paint = Paint();
    paint.color = Colors.grey[400];
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;

    // Draw Zone Arcs
    canvas.drawArc(_rectByZone(Position_Proximity.Immediate), K_ANGLE, K_ANGLE, false, paint);

    canvas.drawArc(_rectByZone(Position_Proximity.Near), K_ANGLE, K_ANGLE, false, paint);

    canvas.drawArc(_rectByZone(Position_Proximity.Distant), K_ANGLE, K_ANGLE, false, paint);
  }

  Rect _rectByZone(Position_Proximity proximity) {
    switch (proximity) {
      case Position_Proximity.Immediate:
        return Rect.fromLTRB(0, 200, _currentSize.width, 400);
        break;
      case Position_Proximity.Near:
        return Rect.fromLTRB(0, 100, _currentSize.width, 300);
        break;
      case Position_Proximity.Distant:
        return Rect.fromLTRB(0, 0, _currentSize.width, 150);
        break;
      default:
        return Rect.fromLTRB(0, 100, _currentSize.width, 300);
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  static Path getBubblePath(double sizeWidth, Position_Proximity proximity) {
    // Check Proximity Status
    switch (proximity) {
      case Position_Proximity.Immediate:
        Path path = new Path();
        path.addArc(Rect.fromLTRB(0, 120, sizeWidth, 400), K_ANGLE, K_ANGLE);
        return path;
        break;
      case Position_Proximity.Near:
        Path path = new Path();
        path.addArc(Rect.fromLTRB(0, 50, sizeWidth, 220), K_ANGLE, K_ANGLE);
        return path;
        break;
      case Position_Proximity.Distant:
        Path path = new Path();
        path.addArc(Rect.fromLTRB(0, 0, sizeWidth, 150), K_ANGLE, K_ANGLE);
        return path;
        break;
      default:
        return null;
        break;
    }
  }
}
