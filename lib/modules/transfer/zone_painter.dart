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
  @override
  void paint(Canvas canvas, Size size) {
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
        return Rect.fromLTRB(0, 200, Get.width, 400);
        break;
      case Peer_Proximity.NEAR:
        return Rect.fromLTRB(0, 100, Get.width, 300);
        break;
      case Peer_Proximity.FAR:
        return Rect.fromLTRB(0, 0, Get.width, 150);
        break;
      default:
        return Rect.fromLTRB(0, 100, Get.width, 300);
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  static Path getBubblePath(Peer_Proximity proximity) {
    // Check Proximity Status
    switch (proximity) {
      case Peer_Proximity.IMMEDIATE:
        Path path = new Path();
        path.addArc(Rect.fromLTRB(0, 120, Get.width, 400), K_ANGLE, K_ANGLE);
        return path;
        break;
      case Peer_Proximity.NEAR:
        Path path = new Path();
        path.addArc(Rect.fromLTRB(0, 50, Get.width, 220), K_ANGLE, K_ANGLE);
        return path;
        break;
      case Peer_Proximity.FAR:
        Path path = new Path();
        path.addArc(Rect.fromLTRB(0, 0, Get.width, 150), K_ANGLE, K_ANGLE);
        return path;
        break;
      default:
        return null;
        break;
    }
  }
}
