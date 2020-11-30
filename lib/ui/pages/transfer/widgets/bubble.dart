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
  }

  @override
  dispose() {
    _animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ^ Looking for Peer ^ //
    return GetBuilder<SonrController>(builder: (sonr) {
      // ^ [Ive Declined] Check if Ive already Declined ^ //
      if (sonr.status == SonrStatus.Searching) {
        if (sonr.auth() != null) {
          // Check if im the peer
          if (widget.peer.id == sonr.currentPeer().id) {
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
        }
      }
      // ^ [Im Pending] Check if im the Peer ^ //
      else if (sonr.status == SonrStatus.Pending) {
        if (widget.peer.id == sonr.currentPeer().id) {
          return Positioned(
              top: calculateOffset(widget.value).dy,
              left: calculateOffset(widget.value).dx,
              child: Container(
                child: buildBubbleContent(widget.peer),
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

      // ^ [We are transferring] Check if User is Transferring ^ //
      else if (sonr.status == SonrStatus.Transferring) {
        if (widget.peer.id == sonr.currentPeer().id) {
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
                buildBubbleContent(widget.peer),
              ]));
        }
      }

      // ^ [Im Available] Active Peer you can invite me ^
      return Positioned(
          top: calculateOffset(widget.value).dy,
          left: calculateOffset(widget.value).dx,
          child: GestureDetector(
              onTap: () async {
                // Send Offer to Bubble
                sonr.invitePeer(widget.peer);
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
                        initialsFromPeer(widget.peer),
                        iconFromPeer(widget.peer),
                      ],
                    ),
                  ))));
    });
  }
}
