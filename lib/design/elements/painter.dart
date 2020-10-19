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
        _rectByZone(ProximityStatus.Immediate), K_ANGLE, K_ANGLE, false, paint);

    canvas.drawArc(
        _rectByZone(ProximityStatus.Near), K_ANGLE, K_ANGLE, false, paint);

    canvas.drawArc(
        _rectByZone(ProximityStatus.Far), K_ANGLE, K_ANGLE, false, paint);
  }

  Rect _rectByZone(ProximityStatus proximity) {
    switch (proximity) {
      case ProximityStatus.Immediate:
        return Rect.fromLTRB(0, 200, _currentSize.width, 400);
        break;
      case ProximityStatus.Near:
        return Rect.fromLTRB(0, 100, _currentSize.width, 300);
        break;
      case ProximityStatus.Far:
        return Rect.fromLTRB(0, 0, _currentSize.width, 150);
        break;
      default:
        return null;
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  static Path getBubblePath(double sizeWidth, ProximityStatus proximity) {
    // Check Proximity Status
    switch (proximity) {
      case ProximityStatus.Immediate:
        Path path = new Path();
        path.addArc(Rect.fromLTRB(0, 120, sizeWidth, 400), K_ANGLE, K_ANGLE);
        return path;
        break;
      case ProximityStatus.Near:
        Path path = new Path();
        path.addArc(Rect.fromLTRB(0, 50, sizeWidth, 220), K_ANGLE, K_ANGLE);
        return path;
        break;
      case ProximityStatus.Far:
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
