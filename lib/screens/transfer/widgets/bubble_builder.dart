part of 'bubble.dart';

// *************************** //
// ** Build Bubbles in List ** //
// *************************** //
Stack buildStackView(List<Peer> peers, Animation animation) {
  // Initialize Widget List with Range Lines
  List<Widget> stackWidgets = new List<Widget>();
  stackWidgets.add(_buildRangeLines());

  // Create Bubbles
  for (Peer peer in peers) {
    Widget bubble = _buildBubble(animation.value, peer);
    stackWidgets.add(bubble);
  }

  // Return View
  return Stack(children: stackWidgets);
}

// ************************************** //
// ** Build Bubble Widget Requirements ** //
// ************************************** //
Widget _buildRangeLines() {
  return Padding(
      padding: EdgeInsets.only(bottom: 75),
      child: CustomPaint(
        size: screenSize,
        painter: CurvePainter(1),
        child: Container(),
      ));
}

Widget _buildBubble(double value, Peer node) {
  return Positioned(
      top: calculateOffset(value, node.proximity).dy,
      left: calculateOffset(value, node.proximity).dx,
      child: Neumorphic(
          style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
              depth: 10,
              lightSource: LightSource.topLeft,
              color: Colors.grey[300]),
          child: Container(
            width: 50,
            height: 50,
          )));
}

// ******************************** //
// ** Calculate Offset from Line ** //
// ******************************** //
Offset calculateOffset(double value, ProximityStatus proximity) {
  Path path = CurvePainter.getAnimationPath(screenSize.width, proximity);
  PathMetrics pathMetrics = path.computeMetrics();
  PathMetric pathMetric = pathMetrics.elementAt(0);
  value = pathMetric.length * value;
  Tangent pos = pathMetric.getTangentForOffset(value);
  return pos.position;
}
