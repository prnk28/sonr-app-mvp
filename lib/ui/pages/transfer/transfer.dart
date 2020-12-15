import 'dart:ui';

import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/sonr_core.dart';
import 'widgets/peers.dart';
import 'widgets/compass.dart';

const STACK_CONSTANT = 1;

class TransferScreen extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    // ** Listen to States ** //
    controller.addListenerId("Listener", () {
      if (controller.status == Status.Complete) {
        if (controller.reply.payload.type == Payload_Type.CONTACT) {
          Get.bottomSheet(ContactInviteView(controller.reply.payload.contact));
        }
      }
    });

    // Return Widget
    return AppTheme(Scaffold(
        appBar: exitAppBar(context, Icons.close, title: "OLC", onPressed: () {
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
            PeerStack(),
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
