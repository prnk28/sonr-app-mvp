import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sonr_core/models/models.dart';

const double K_ANGLE = pi;

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
  final double height;
  final double width;
  final Gradient gradient;

  WavePainter({
    this.waveAnimation,
    this.percent,
    this.height,
    this.width,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baseHeight = (height) - (percent * height);
    final path = Path();
    path.moveTo(0.0, baseHeight);
    for (var i = 0.0; i < width; i++) {
      path.lineTo(
        i,
        baseHeight + sin((i / width * _pi2) + (waveAnimation.value * _pi2)) * 16,
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
