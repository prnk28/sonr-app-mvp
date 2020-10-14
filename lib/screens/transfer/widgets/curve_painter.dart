import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:path_drawing/path_drawing.dart';

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
    final startAngle = math.pi;
    final sweepAngle = math.pi;
    final useCenter = false;

    // Draw Arc
    canvas.drawArc(Rect.fromLTRB(0, 175, size.width, 400), startAngle,
        sweepAngle, useCenter, paint);

    canvas.drawArc(Rect.fromLTRB(0, 100, size.width, 300), startAngle,
        sweepAngle, useCenter, paint);

    canvas.drawArc(Rect.fromLTRB(0, 25, size.width, 200), startAngle,
        sweepAngle, useCenter, paint);
  }

  static Path getAnimationPath(double sizeWidth, int range) {
    // Default Arc Angles
    final startAngle = math.pi;
    final sweepAngle = math.pi;

    // Close Range
    if (range == 0) {
      Path path = new Path();
      path.addArc(
          Rect.fromLTRB(0, 150, sizeWidth, 400), startAngle, sweepAngle);
      return path;
    }
    // Near Range
    else if (range == 1) {
      Path path = new Path();
      path.addArc(Rect.fromLTRB(0, 75, sizeWidth, 300), startAngle, sweepAngle);
      return path;
    }
    // Far Range
    else {
      Path path = new Path();
      path.addArc(Rect.fromLTRB(0, 0, sizeWidth, 200), startAngle, sweepAngle);
      return path;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
