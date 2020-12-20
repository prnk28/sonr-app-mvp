import 'dart:math';

import 'package:flutter/widgets.dart';

class Direction {
  final double direction;
  final double alignModifier;
  double degrees;
  num radians;
  Alignment alignment;

  Direction(this.direction, this.alignModifier) {
    this.degrees = _directionToDegrees(direction);
    this.radians = (_directionToDegrees(degrees) * pi) / 180.0;
    this.alignment = _directionToAlignment(alignModifier, direction);
  }

  double _directionToDegrees(double direction) {
    if (direction + 90 > 360) {
      return direction - 270;
    } else {
      return direction + 90;
    }
  }

  num _directionToRads(num deg) {
    return (this.degrees * pi) / 180.0;
  }

  Alignment _directionToAlignment(double r, double deg) {
    // Calculate radians
    double radAngle = _directionToRads(deg);

    double x = cos(radAngle) * r;
    double y = sin(radAngle) * r;
    return Alignment(x, y);
  }
}
