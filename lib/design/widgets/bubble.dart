part of 'widgets.dart';

// *************************** //
// ** Build Bubbles in List ** //
// *************************** //
buildStackView(List<Peer> peers, Animation animation) {
  // Check if null
  if (peers.isNotEmpty) {
// Initialize Widget List with Range Lines
    List<Widget> stackWidgets = new List<Widget>();
    stackWidgets.add(buildRangeLines());

    // Create Bubbles
    for (Peer peer in peers) {
      Widget bubble = buildBubble(animation.value, peer);
      stackWidgets.add(bubble);
    }

    // Return View
    return Stack(children: stackWidgets);
  }
  return Container();
}

// ************************************** //
// ** Build Bubble Widget Requirements ** //
// ************************************** //
Widget buildRangeLines() {
  return Padding(
      padding: EdgeInsets.only(bottom: 75),
      child: CustomPaint(
        size: screenSize,
        painter: ZonePainter(),
        child: Container(),
      ));
}

Widget buildBubble(double value, Peer node) {
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
  Path path = ZonePainter.getBubblePath(screenSize.width, proximity);
  PathMetrics pathMetrics = path.computeMetrics();
  PathMetric pathMetric = pathMetrics.elementAt(0);
  value = pathMetric.length * value;
  Tangent pos = pathMetric.getTangentForOffset(value);
  return pos.position;
}
