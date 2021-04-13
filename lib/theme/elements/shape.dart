import '../theme.dart';

class ShapeContainer extends StatelessWidget {
  // Properties
  final NeumorphicPathProvider path;
  final double height;
  final double width;
  final BoxDecoration decoration;
  final Widget child;

  // @ Factory Option: Message
  factory ShapeContainer.message({double height, double width, Widget child, BoxDecoration decoration}) =>
      ShapeContainer(path: MessagePath(), height: height, width: width, child: child, decoration: decoration);

  // @ Factory Option: Oval Bottom
  factory ShapeContainer.ovalDown({double height, double width, Widget child, BoxDecoration decoration}) =>
      ShapeContainer(path: OvalBottomPath(), height: height, width: width, child: child, decoration: decoration);

  // @ Factory Option: Oval Top
  factory ShapeContainer.ovalTop({double height, double width, Widget child, BoxDecoration decoration}) =>
      ShapeContainer(path: OvalTopPath(), height: height, width: width, child: child, decoration: decoration);

  // @ Factory Option: Wave Weak Right
  factory ShapeContainer.wave({double height, double width, Widget child, BoxDecoration decoration}) =>
      ShapeContainer(path: WavePath(), height: height, width: width, child: child, decoration: decoration);

  // @ Factory Option: Wave Strong
  factory ShapeContainer.waveStrong({double height, double width, Widget child, BoxDecoration decoration}) =>
      ShapeContainer(path: WaveStrongPath(), height: height, width: width, child: child, decoration: decoration);

  // ** Constructer ** //
  const ShapeContainer({@required this.path, Key key, this.decoration, this.child, this.width = 200, this.height = 200}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.path(path),
          depth: UserService.isDarkMode ? 4 : 8,
          intensity: UserService.isDarkMode ? 0.45 : 0.85,
          surfaceIntensity: 0.6,
        ),
        child: Container(height: height, width: width, decoration: decoration ?? BoxDecoration(), child: child));
  }
}

// ^ Bottom Nav Bar: Neumorphic Path ^ //
class BottomBarPath extends NeumorphicPathProvider {
  @override
  Path getPath(Size size) {
    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    return path;
  }

  @override
  bool get oneGradientPerPath => true;
}

// ^ Message Neumorphic Path ^ //
class MessagePath extends NeumorphicPathProvider {
  final double borderRadius;
  MessagePath({this.borderRadius = 8});

  @override
  Path getPath(Size size) {
    double width = size.width;
    double height = size.height;
    double rheight = height - height / 3;
    double oneThird = width / 3;

    final path = Path()
      ..lineTo(0, rheight - borderRadius)
      ..cubicTo(0, rheight - borderRadius, 0, rheight, borderRadius, rheight)
      ..lineTo(oneThird, rheight)
      ..lineTo(width / 2 - borderRadius, height - borderRadius)
      ..cubicTo(width / 2 - borderRadius, height - borderRadius, width / 2, height, width / 2 + borderRadius, height - borderRadius)
      ..lineTo(2 * oneThird, rheight)
      ..lineTo(width - borderRadius, rheight)
      ..cubicTo(width - borderRadius, rheight, width, rheight, width, rheight - borderRadius)
      ..lineTo(width, 0)
      ..lineTo(0, 0);
    return path;
  }

  @override
  bool get oneGradientPerPath => true;
}

// ^ Oval Bottom Neumorphic Path ^ //
class OvalBottomPath extends NeumorphicPathProvider {
  @override
  Path getPath(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, _buildBottomPoint(size));
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - size.width / 4, size.height, size.width, _buildBottomPoint(size));
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  double _buildBottomPoint(Size size) {
    var height = size.height;
    var diff = size.height / 5;
    return height - diff;
  }

  @override
  bool get oneGradientPerPath => true;
}

// ^ Oval Top Neumorphic Path ^ //
class OvalTopPath extends NeumorphicPathProvider {
  @override
  Path getPath(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, 40);
    path.quadraticBezierTo(size.width / 4, 0, size.width / 2, 0);
    path.quadraticBezierTo(size.width - size.width / 4, 0, size.width, 40);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool get oneGradientPerPath => true;
}

// ^ Wave Default Right Path ^ //
class WavePath extends NeumorphicPathProvider {
  @override
  Path getPath(Size size) {
    Offset firstEndPoint = Offset(size.width * .5, size.height - 20);
    Offset firstControlPoint = Offset(size.width * .25, size.height - 30);
    Offset secondEndPoint = Offset(size.width, size.height - 50);
    Offset secondControlPoint = Offset(size.width * .75, size.height - 10);

    final path = Path()
      ..lineTo(0.0, size.height)
      ..quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
      ..quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
      ..lineTo(size.width, 0.0)
      ..close();
    return path;
  }

  @override
  bool get oneGradientPerPath => true;
}

// ^ Wave Strong Right Path ^ //
class WaveStrongPath extends NeumorphicPathProvider {
  @override
  Path getPath(Size size) {
    var firstControlPoint = Offset(size.width / 3.25, 65);
    var firstEndPoint = Offset(size.width / 1.75, 40);
    var secondCP = Offset(size.width / 1.25, 0);
    var secondEP = Offset(size.width, 30);

    final path = Path();
    path.lineTo(0.0, 20);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    path.quadraticBezierTo(secondCP.dx, secondCP.dy, secondEP.dx, secondEP.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool get oneGradientPerPath => true;
}
