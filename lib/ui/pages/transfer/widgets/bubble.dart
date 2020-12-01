import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/sonr_core.dart';

class Bubble extends StatefulWidget {
  final double value;
  final Peer peer;
  Bubble(this.value, this.peer, {Key key}) : super(key: key);

  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> with TickerProviderStateMixin {
  // Animation
  AnimationController _animationController;
  Animation _animation;
  bool _isInvited = false;
  bool _hasDeclined = false;
  bool _hasAccepted = false;
  bool _hasCompleted = false;

  // Controller
  TransferController transfer = Get.find();

  @override
  void initState() {
    super.initState();
    // Animation for Requested
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 1.0, end: 16.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    // Controller Listener
    transfer.addListenerId("Bubble", () {
      // Set Bools - isInvited set on Tap
      _hasAccepted =
          (_isInvited) && (transfer.status == AuthMessage_Event.ACCEPT);
      _hasDeclined =
          (_isInvited) && (transfer.status == AuthMessage_Event.DECLINE);
      _hasCompleted = (_isInvited) && (transfer.completed);
      setState(() {});
    });
  }

  @override
  dispose() {
    _animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ^ Check if Invited ^
    if (_isInvited) {
      // @ We are transferring
      if (_hasAccepted) {
        return Positioned(
            top: calculateOffset(widget.value).dy,
            left: calculateOffset(widget.value).dx,
            child: Stack(alignment: AlignmentDirectional.center, children: [
              Neumorphic(
                  style: NeumorphicStyle(
                      depth: 10, boxShape: NeumorphicBoxShape.circle()),
                  child: SizedBox(
                    child: CircularProgressIndicator(strokeWidth: 6),
                    height: 86.0,
                    width: 86.0,
                  )),
              buildBubbleContent(),
            ]));
      }
      // @ Check if Declined
      else if (_hasDeclined) {
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
        return Positioned(
            top: calculateOffset(widget.value).dy,
            left: calculateOffset(widget.value).dx,
            child: Container(
              child: buildBubbleContent(),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 27, 28, 30),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(130, 237, 125, 58),
                        blurRadius: _animation.value,
                        spreadRadius: _animation.value)
                  ]),
            ));
      }
    }
    // ^ [Im Available] Active Peer you can invite me ^
    return Positioned(
        top: calculateOffset(widget.value).dy,
        left: calculateOffset(widget.value).dx,
        child: GestureDetector(
            onTap: () async {
              // Send Offer to Bubble
              _isInvited = true;
              setState(() {});
              transfer.invitePeer(widget.peer);
            },
            child: buildBubbleContent()));
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
          width: 80,
          height: 80,
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
