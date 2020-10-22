part of 'widgets.dart';

// *************************** //
// ** Build Bubbles in List ** //
// *************************** //
buildStackView(List<Node> peers) {
  // Initialize Widget List with Range Lines
  List<Widget> stackWidgets = new List<Widget>();
  stackWidgets.add(buildRangeLines());

  // Init Stack Vars
  int total = peers.length + 1;
  int current = 0;
  double mean = 1.0 / total;

  // Create Bubbles
  for (Node peer in peers) {
    // Increase Count
    current += 1;

    // Place Bubble
    Widget bubble = new Bubble(current * mean, peer);
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
