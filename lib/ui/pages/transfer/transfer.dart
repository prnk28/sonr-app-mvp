import 'dart:ui';

import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/sonr_core.dart';
import 'widgets/bubble.dart';
import 'widgets/compass.dart';

class TransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Return Widget
    return AppTheme(Scaffold(
        appBar: exitAppBar(context, Icons.close, onPressed: () {
          Get.offAllNamed("/home");
        }),
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            // @ Range Lines
            Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: CustomPaint(
                  size: Size(Get.width, Get.height),
                  painter: ZonePainter(),
                  child: Container(),
                )),

            // @ Bubble View
            GetX<SonrController>(builder: (sonr) {
              // Initialize Widget List
              List<Widget> stackWidgets = new List<Widget>();
              // Check Peers Size
              if (sonr.peers().length > 0) {
                // Init Stack Vars
                int total = sonr.peers().length + 1;
                int current = 0;
                double mean = 1.0 / total;

                // Create Bubbles
                print(sonr.peers().length);
                sonr.lobby().peers.values.forEach((peer) {
                  // Increase Count
                  current += 1;
                  // Create Bubble
                  stackWidgets.add(Bubble(current * mean, peer));
                });
              }
              return Stack(children: stackWidgets);
            }),
            CompassView(),
          ],
        ))));
  }
}

// ^ Builds the Bubbles Content ^ //
buildBubbleContent(Peer peer) {
  // Generate Bubble
  return Neumorphic(
      style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.circle(),
          depth: 10,
          lightSource: LightSource.topLeft,
          color: Colors.grey[300]),
      child: Container(
        width: 80,
        height: 80,
        child: Column(
          children: [
            Spacer(),
            initialsFromPeer(peer),
            iconFromPeer(peer),
          ],
        ),
      ));
}

// ^ Calculate Peer Offset from Line ^ //
Offset calculateOffset(double value,
    {Peer_Proximity proximity = Peer_Proximity.IMMEDIATE}) {
  Path path = ZonePainter.getBubblePath(Get.width, proximity);
  PathMetrics pathMetrics = path.computeMetrics();
  PathMetric pathMetric = pathMetrics.elementAt(0);
  value = pathMetric.length * value;
  Tangent pos = pathMetric.getTangentForOffset(value);
  return pos.position;
}
