import 'dart:ui';

import 'package:sonar_app/screens/screens.dart';

import 'curve_painter.dart';

part 'bubble_builder.dart';

class BubbleView extends StatefulWidget {
  final Size screenSize;
  final PathFinder pathFinder;
  BubbleView(this.pathFinder, this.screenSize);

  @override
  State<StatefulWidget> createState() {
    return _BubbleAnimationState();
  }
}

class _BubbleAnimationState extends State<BubbleView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  Path _path;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.stop();
    _controller.reset();
    _controller.repeat(
      period: Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // ***************** //
          // ** Range Lines ** //
          // ***************** //
          Padding(
              padding: EdgeInsets.only(bottom: 75),
              child: CustomPaint(
                size: widget.screenSize,
                painter: CurvePainter(1),
                child: Container(),
              )),

          // ************* //
          // ** Bubbles ** //
          // ************* //
          Positioned(
            top: calculate(_animation.value, 0).dy + 5,
            left: calculate(_animation.value, 0).dx,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(40)),
              width: 40,
              height: 40,
            ),
          ),

          Positioned(
            top: calculate(_animation.value, 1).dy + 5,
            left: calculate(_animation.value, 1).dx,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(40)),
              width: 40,
              height: 40,
            ),
          ),
          Positioned(
            top: calculate(_animation.value, 2).dy + 5,
            left: calculate(_animation.value, 2).dx,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(40)),
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset calculate(value, int range) {
    Path path = CurvePainter.getAnimationPath(widget.screenSize.width, range);
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }
}
