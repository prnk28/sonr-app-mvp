import 'dart:ui';

import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/models/models.dart';
part 'pending.dart';

getPeerBubble(double value, Peer peer, AuthMessage currentMessage) {
  if (currentMessage.event == AuthMessage_Event.ACCEPT) {
    return acceptedBubble(value, peer);
  } else if (currentMessage.event == AuthMessage_Event.DECLINE) {
    return deniedBubble(value);
  }
  return PendingBubble(value, peer);
}

// ^ Build Active Bubble ^ //
Positioned activeBubble(double value, Peer data) {
  SonrController sonr = Get.find();
  return Positioned(
      top: calculateOffset(value).dy,
      left: calculateOffset(value).dx,
      child: GestureDetector(
          onTap: () async {
            // Send Offer to Bubble
            sonr.invitePeer(data);
          },
          child: Neumorphic(
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
                    initialsFromPeer(data),
                    iconFromPeer(data),
                  ],
                ),
              ))));
}

// ^ Build Accepted Bubble ^ //
Positioned acceptedBubble(double value, Peer data) {
  return Positioned(
      top: calculateOffset(value).dy,
      left: calculateOffset(value).dx,
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Neumorphic(
            style: NeumorphicStyle(
                depth: 10, boxShape: NeumorphicBoxShape.circle()),
            child: SizedBox(
              child: CircularProgressIndicator(strokeWidth: 6),
              height: 86.0,
              width: 86.0,
            )),
        buildBubbleContent(data),
      ]));
}

// ^ Build Denied Bubble ^ //
Positioned deniedBubble(double value) {
  return Positioned(
      top: calculateOffset(value).dy,
      left: calculateOffset(value).dx,
      child: Container(
          child: Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.circle(),
            depth: 10,
            lightSource: LightSource.topLeft,
            color: Colors.grey[300]),
        child: Container(
          width: 80,
          height: 80,
          child: FlareActor("assets/animations/denied.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "animate"),
        ),
      )));
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
