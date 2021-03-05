import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../style/style.dart';
import '../../data/data.dart';
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
    final Color _color = SonrColor.Blue.withOpacity(opacity);
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

  static Offset fromPosition(Position position, Position_Designation diffDesg, double diffRad) {
    // Convert Rad to Point on Path
    var path = ZonePathProvider(position.proximity);
    var metrics = path.getPath(Get.size).computeMetrics().elementAt(0);
    var point = diffRad * metrics.length;

    // Get Tanget for Point
    var tangent = metrics.getTangentForOffset(point);
    var calcPos = tangent.position;

    // Top of View
    if (diffDesg == Position_Designation.NNE || diffDesg == Position_Designation.NEbN || diffDesg == Position_Designation.NbE) {
      return Offset(180, position.proximity.topOffset);
    } else if (diffDesg == Position_Designation.NE) {
      return Offset(270, position.proximity.topOffset + 20);
    } else if (diffDesg == Position_Designation.N) {
      return Offset(90, position.proximity.topOffset + 20);
    } else {
      return Offset(calcPos.dx.clamp(0, 340).toDouble(), min(ZonePathProvider.proximityMaxHeight(position.proximity), calcPos.dy).toDouble());
    }
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
  // References
  final Position_Proximity proximity;
  ZonePathProvider(this.proximity);

  // ^ Returns Path Size ^
  static double get size {
    final ThemeData themeData = Theme.of(Get.context);
    final MaterialTapTargetSize effectiveMaterialTapTargetSize = themeData.checkboxTheme.materialTapTargetSize ?? themeData.materialTapTargetSize;
    final VisualDensity effectiveVisualDensity = themeData.checkboxTheme.visualDensity ?? themeData.visualDensity;
    Size size;
    switch (effectiveMaterialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        size = const Size(kMinInteractiveDimension, kMinInteractiveDimension);
        break;
      case MaterialTapTargetSize.shrinkWrap:
        size = const Size(kMinInteractiveDimension - 8.0, kMinInteractiveDimension - 8.0);
        break;
    }
    size += effectiveVisualDensity.baseSizeAdjustment;
    return size.longestSide;
  }

  // ^ Returns Path Size ^
  static double arcLength(double angle) {
    return sqrt((Get.height / 2 * Get.height / 2) / 2) * angle;
  }

  // ^ Constructs Path ^ //
  @override
  Path getPath(Size size) {
    // Initialize Bounds
    final double height = (Get.height / 2);
    final double radius = sqrt((Get.height / 2 * Get.height / 2) / 2);

    // Bottom Zone
    if (proximity == Position_Proximity.Immediate) {
      // Build Rect
      var immediateRect = Rect.fromCircle(center: Offset(Get.width / 2, height + 80), radius: radius);
      Path path = new Path();
      path.addArc(immediateRect, pi, pi);
      return path;
      // Return Path
    }
    // Middle Zone
    else if (proximity == Position_Proximity.Near) {
      // Build Rect
      var nearRect = Rect.fromCircle(center: Offset(Get.width / 2, height), radius: radius);

      // Return Path
      Path path = new Path();
      path.addArc(nearRect, pi, pi);
      return path;
    }
    // Top Zone
    else {
      // Build Rect
      var distantRect = Rect.fromCircle(center: Offset(Get.width / 2, height - 80), radius: radius);

      // Return Path
      Path path = new Path();
      path.addArc(distantRect, pi, pi);
      return path;
    }
  }

  static double proximityMaxHeight(Position_Proximity proximity) {
    // Bottom Zone
    if (proximity == Position_Proximity.Immediate) {
      return 235;
    }
    // Middle Zone
    else if (proximity == Position_Proximity.Near) {
      return 150;
    }
    // Top Zone
    else {
      return 75;
    }
  }

  @override
  bool shouldReclip(NeumorphicPathProvider oldClipper) {
    return true;
  }

  @override
  bool get oneGradientPerPath => true;
}
