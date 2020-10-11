import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class CurvePainter extends CustomPainter {
  final double multiplier;

  CurvePainter(this.multiplier);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = Colors.grey[400];
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;

    var startPoint = Offset(0, multiplier * size.height / 2);
    var controlPoint1 = Offset(size.width / 4, size.height / 4);
    var controlPoint2 = Offset(3 * size.width / 4, size.height / 4);
    var endPoint = Offset(size.width, multiplier * size.height / 2);

    var path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
