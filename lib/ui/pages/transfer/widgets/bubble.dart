import 'package:flutter/services.dart';
import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:rive/rive.dart';

class Bubble extends StatefulWidget {
  final double value;
  final Peer peer;
  Bubble(this.value, this.peer, {Key key}) : super(key: key);

  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> with TickerProviderStateMixin {
  Artboard _artboard;
  PeerController _controller;
  // Animation
  bool _isInvited = false;
  bool _hasDeclined = false;
  bool _hasAccepted = false;
  bool _hasCompleted = false;

  // Controller
  TransferController transfer = Get.find();

  void _setInvited() {
    _controller.peerState = PeerState.Pending;
    setState(() => _isInvited = true);
  }

  // loads a Rive file
  void _loadRiveFile() async {
    // Load File
    final bytes = await rootBundle.load('assets/animations/peerbubble.riv');
    final file = RiveFile();

    // Start Controller
    if (file.import(bytes)) {
      setState(() => _artboard = file.mainArtboard
        ..addController(_controller = PeerController()));
    }
  }

  @override
  void initState() {
    // Set Controller Device
    _controller.device = widget.peer.device.platform;

    // Load File
    _loadRiveFile();
    super.initState();

    // Controller Listener
    transfer.addListenerId("Bubble", () {
      // Set Bools - isInvited set on Tap
      _hasAccepted =
          (_isInvited) && (transfer.status == AuthMessage_Event.ACCEPT);
      _hasDeclined =
          (_isInvited) && (transfer.status == AuthMessage_Event.DECLINE);
      _hasCompleted = (_isInvited) && (transfer.completed);
      setState(() {
        if (_hasAccepted) {
          _controller.peerState = PeerState.Accepted;
        } else if (_hasDeclined) {
          _controller.peerState = PeerState.Denied;
        } else if (_hasCompleted) {
          _controller.peerState = PeerState.Done;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // @ Check if Declined
    if (_hasDeclined) {
      return Positioned(
          top: calculateOffset(widget.value).dy,
          left: calculateOffset(widget.value).dx,
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
    // @ Check if Completed
    else if (_hasCompleted) {
      return Positioned(
          top: calculateOffset(widget.value).dy,
          left: calculateOffset(widget.value).dx,
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
              child: FlareActor("assets/animations/complete.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "animate"),
            ),
          )));
    }
    // @ Im Pending
    else {
      // ^ [Im Available] Active Peer you can invite me ^
      return Positioned(
          top: calculateOffset(widget.value).dy,
          left: calculateOffset(widget.value).dx,
          child: GestureDetector(
              onTap: () async {
                if (!_isInvited) {
                  // Send Offer to Bubble
                  _setInvited();
                  transfer.invitePeer(widget.peer);
                }
              },
              child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(167, 179, 190, 1.0),
                      offset: Offset(8, 8),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                    ),
                    BoxShadow(
                      color: Color.fromRGBO(248, 252, 255, .5),
                      offset: Offset(-8, -8),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                    ),
                  ]),
                  child: Stack(alignment: Alignment.center, children: [
                    Rive(
                      artboard: _artboard,
                      fit: BoxFit.contain,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      iconFromPeer(widget.peer, size: 20),
                      initialsFromPeer(widget.peer),
                    ]),
                  ]))));
    }
  }

  // ^ Builds the Bubbles Content ^ //
  Neumorphic buildBubbleContent() {
    // Generate Bubble
    return Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.circle(),
            depth: 10,
            lightSource: LightSource.topLeft,
            color: Colors.grey[300]),
        child: Container(
          width: 90,
          height: 90,
          child: Column(
            children: [
              Spacer(),
              initialsFromPeer(widget.peer),
              iconFromPeer(widget.peer),
            ],
          ),
        ));
  }
}
