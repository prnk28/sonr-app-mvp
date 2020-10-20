part of 'transfer.dart';

class Bubble extends StatefulWidget {
  final double value;
  final Peer node;

  const Bubble(this.value, this.node, {Key key}) : super(key: key);
  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: _calculateOffset(widget.value, widget.node.proximity).dy,
        left: _calculateOffset(widget.value, widget.node.proximity).dx,
        child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
                depth: 10,
                lightSource: LightSource.topLeft,
                color: Colors.grey[300]),
            child: GestureDetector(
                onTap: () async {
                  await _sendInvite(context, widget.node);
                },
                child: Container(
                  width: 80,
                  height: 80,
                  child: Column(
                    children: [
                      Spacer(),
                      _getInitials(widget.node.profile),
                      _getIconByDevice(widget.node.device),
                    ],
                  ),
                ))));
  }

  _sendInvite(BuildContext context, Peer to) async {
    // Get Data
    File dummyFile = await getAssetFileByPath("assets/images/fat_test.jpg");

    // Queue File
    context.emitDataBlocEvent(DataEventType.QueueOutgoingFile,
        rawFile: dummyFile);

    // Create Meta
    Metadata meta = Metadata.fromFile(dummyFile);

    // Invite Peer
    context.emitWebBlocEvent(WebEventType.Invite, match: to, meta: meta);
  }

  _getIconByDevice(String device) {
    if (device == "ANDROID") {
      return NeumorphicIcon((Icons.android),
          size: 30, style: NeumorphicStyle(color: Colors.green[200]));
    } else if (device == "IOS") {
      return NeumorphicIcon((Icons.phone_iphone),
          size: 30, style: NeumorphicStyle(color: Colors.grey[500]));
    } else {
      return NeumorphicIcon((Icons.device_unknown));
    }
  }

  _getInitials(Profile profile) {
    return Text(
        profile.firstName[0].toUpperCase() + profile.lastName[0].toUpperCase(),
        style: mediumTextStyle());
  }

// ******************************** //
// ** Calculate Offset from Line ** //
// ******************************** //
  Offset _calculateOffset(double value, ProximityStatus proximity) {
    Path path = ZonePainter.getBubblePath(screenSize.width, proximity);
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }
}
