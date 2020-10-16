import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:path_drawing/path_drawing.dart';
import 'package:sonar_app/core/core.dart';

const double K_ANGLE = math.pi;

class CurvePainter extends CustomPainter {
  final double multiplier;

  CurvePainter(this.multiplier);

  @override
  void paint(Canvas canvas, Size size) {
    // Setup Paint
    var paint = Paint();
    paint.color = Colors.grey[400];
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;

    // Initialize Default Arc Angles
    final useCenter = false;

    // Draw Arc
    canvas.drawArc(Rect.fromLTRB(0, 175, size.width, 400), K_ANGLE, K_ANGLE,
        useCenter, paint);

    canvas.drawArc(Rect.fromLTRB(0, 100, size.width, 300), K_ANGLE, K_ANGLE,
        useCenter, paint);

    canvas.drawArc(Rect.fromLTRB(0, 25, size.width, 200), K_ANGLE, K_ANGLE,
        useCenter, paint);
  }

  Rect _getRectForZone(ProximityStatus proximity) {
    switch (proximity) {
      case ProximityStatus.Immediate:
        // TODO: Handle this case.
        break;
      case ProximityStatus.Near:
        // TODO: Handle this case.
        break;
      case ProximityStatus.Far:
        // TODO: Handle this case.
        break;
      case ProximityStatus.Away:
        // TODO: Handle this case.
        break;
    }
  }

  static Path getAnimationPath(double sizeWidth, ProximityStatus proximity) {
    // Check Proximity Status
    switch (proximity) {
      case ProximityStatus.Immediate:
        Path path = new Path();
        path.addArc(Rect.fromLTRB(0, 150, sizeWidth, 400), K_ANGLE, K_ANGLE);
        return path;
        break;
      case ProximityStatus.Near:
        Path path = new Path();
        path.addArc(Rect.fromLTRB(0, 75, sizeWidth, 300), K_ANGLE, K_ANGLE);
        return path;
        break;
      case ProximityStatus.Far:
        Path path = new Path();
        path.addArc(Rect.fromLTRB(0, 0, sizeWidth, 200), K_ANGLE, K_ANGLE);
        return path;
        break;
      case ProximityStatus.Away:
        return null;
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
