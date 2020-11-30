import 'dart:ui';

import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/sonr_core.dart';
import 'widgets/bubble.dart';
import 'widgets/compass.dart';

const STACK_CONSTANT = 1;

class TransferScreen extends GetView<LobbyController> {
  @override
  Widget build(BuildContext context) {
    // Return Widget
    return AppTheme(Scaffold(
        appBar: exitAppBar(context, Icons.close, title: controller.code(),
            onPressed: () {
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
            Obx(() {
              // Initialize Widget List
              List<Widget> stackWidgets = new List<Widget>();

              // Check Peers Size
              if (controller.peers.value.length > 0) {
                // Init Stack Vars
                int total = controller.peers.value.length + STACK_CONSTANT;
                double mean = 1.0 / total;
                int current = 0;

                // Create Bubbles
                controller.peers.value.values.forEach((peer) {
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
