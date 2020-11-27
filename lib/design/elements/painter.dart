part of 'elements.dart';

// Constants
const double K_ANGLE = pi;

// *********************** //
// ** Paints Zone Lines ** //
// *********************** //
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

// ******************** //
// ** Paints Cross X ** //
// ******************** //
class CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.red;
    canvas.drawLine(
        new Offset(0, 0), new Offset(size.width, size.height), paint);
    canvas.drawLine(
        new Offset(size.width, 0), new Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// ******************************* //
// ** Paints Waves for Progress ** //
// ******************************* //
class WavePainter extends CustomPainter {
  final _pi2 = 2 * pi;
  final GlobalKey iconKey;
  final Animation<double> waveAnimation;
  final double percent;
  final double boxHeight;
  final Color waveColor;

  WavePainter({
    @required this.iconKey,
    this.waveAnimation,
    this.percent,
    this.boxHeight,
    this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RenderBox iconBox = iconKey.currentContext.findRenderObject();
    final iconHeight = iconBox.size.height;
    final baseHeight =
        (boxHeight / 2) + (iconHeight / 2) - (percent * iconHeight);

    final width = size.width ?? 200;
    final height = size.height ?? 200;
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
    final wavePaint = Paint()..color = waveColor;
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
