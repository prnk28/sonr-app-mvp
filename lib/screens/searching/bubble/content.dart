part of 'bubble.dart';

// ^ Builds the Bubbles Content ^ //
buildBubbleContent(Peer peer) {
  // Content
  var icon;
  var initials;

  // Get Icon
  if (peer.device.platform == "Android") {
    icon = NeumorphicIcon((Icons.android),
        size: 30, style: NeumorphicStyle(color: Colors.green[200]));
  } else if (peer.device.platform == "iOS") {
    icon = NeumorphicIcon((Icons.phone_iphone),
        size: 30, style: NeumorphicStyle(color: Colors.grey[500]));
  } else {
    icon = NeumorphicIcon((Icons.device_unknown));
  }

  // Get Initials
  initials = Text(
      peer.firstName[0].toUpperCase() + peer.lastName[0].toUpperCase(),
      style: mediumTextStyle());

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
            initials,
            icon,
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
