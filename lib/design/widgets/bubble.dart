part of 'widgets.dart';

// *************************** //
// ** Build Bubbles in List ** //
// *************************** //
buildStackView(List<Peer> peers) {
  // Initialize Widget List with Range Lines
  List<Widget> stackWidgets = new List<Widget>();
  stackWidgets.add(buildRangeLines());

  // Init Stack Vars
  int total = peers.length + 1;
  int current = 0;
  double mean = 1.0 / total;

  // Create Bubbles
  for (Peer peer in peers) {
    // Increase Count
    current += 1;

    // Place Bubble
    Widget bubble = buildBubble(current * mean, peer);
    stackWidgets.add(bubble);
  }

  // Return View
  return Stack(children: stackWidgets);
}

// ************************************** //
// ** Build Bubble Widget Requirements ** //
// ************************************** //
Widget buildRangeLines() {
  return Padding(
      padding: EdgeInsets.only(bottom: 5),
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
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
              depth: 10,
              lightSource: LightSource.topLeft,
              color: Colors.grey[300]),
          child: Container(
            width: 80,
            height: 80,
            child: Column(
              children: [
                Text(node.profile.firstName),
                Text(node.device),
              ],
            ),
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
