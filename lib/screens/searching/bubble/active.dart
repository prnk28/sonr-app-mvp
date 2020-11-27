part of 'bubble.dart';

class ActiveBubble extends StatelessWidget {
  final double value;
  final Peer data;
  final SonrBloc sonrBloc;
  final Widget content;

  const ActiveBubble(this.content, this.value, this.data, this.sonrBloc,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Content
    var icon;
    var initials;

    // Get Icon
    if (data.device.platform == "ANDROID") {
      icon = NeumorphicIcon((Icons.android),
          size: 30, style: NeumorphicStyle(color: Colors.green[200]));
    } else if (data.device.platform == "IOS") {
      icon = NeumorphicIcon((Icons.phone_iphone),
          size: 30, style: NeumorphicStyle(color: Colors.grey[500]));
    } else {
      icon = NeumorphicIcon((Icons.device_unknown));
    }

    // Get Initials
    initials = Text(
        data.firstName[0].toUpperCase() + data.lastName[0].toUpperCase(),
        style: mediumTextStyle());

    // Generate Bubble
    return Positioned(
        top: calculateOffset(value).dy,
        left: calculateOffset(value).dx,
        child: GestureDetector(
            onTap: () async {
              // Send Offer to Bubble
              sonrBloc.add(NodeInvitePeer(data));
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
                      initials,
                      icon,
                    ],
                  ),
                ))));
  }
}
