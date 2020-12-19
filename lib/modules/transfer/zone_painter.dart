import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_core/models/models.dart';

const double K_ANGLE = pi;

class ZoneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: CustomPaint(
          size: Size(Get.width, Get.height),
          painter: ZonePainter(),
          child: Container(),
        ));
  }
}

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
    canvas.drawArc(
        _rectByZone(Peer_Proximity.IMMEDIATE), K_ANGLE, K_ANGLE, false, paint);

    canvas.drawArc(
        _rectByZone(Peer_Proximity.NEAR), K_ANGLE, K_ANGLE, false, paint);

    canvas.drawArc(
        _rectByZone(Peer_Proximity.FAR), K_ANGLE, K_ANGLE, false, paint);
  }

  Rect _rectByZone(Peer_Proximity proximity) {
    switch (proximity) {
      case Peer_Proximity.IMMEDIATE:
        return Rect.fromLTRB(0, 200, _currentSize.width, 400);
        break;
      case Peer_Proximity.NEAR:
        return Rect.fromLTRB(0, 100, _currentSize.width, 300);
        break;
      case Peer_Proximity.FAR:
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

  static Path getBubblePath(double sizeWidth, Peer_Proximity proximity) {
    // Check Proximity Status
    switch (proximity) {
      case Peer_Proximity.IMMEDIATE:
        Path path = new Path();
        path.addArc(Rect.fromLTRB(0, 120, sizeWidth, 400), K_ANGLE, K_ANGLE);
        return path;
        break;
      case Peer_Proximity.NEAR:
        Path path = new Path();
        path.addArc(Rect.fromLTRB(0, 50, sizeWidth, 220), K_ANGLE, K_ANGLE);
        return path;
        break;
      case Peer_Proximity.FAR:
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
