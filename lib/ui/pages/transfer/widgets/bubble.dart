import 'package:flutter/services.dart';
import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:rive/rive.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class Bubble extends StatefulWidget {
  // Bubble Values
  final double value;
  final Peer peer;

  Bubble(this.value, this.peer);

  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  TransferController controller = Get.find();
  bool isInvited = false;
  bool hasDenied = false;
  bool hasAccepted = false;
  bool hasCompleted = false;
  Artboard _artboard;
  SimpleAnimation _pending, _denied, _accepted, _complete;

  @override
  void initState() {
    // Load Rive
    _loadRiveFile();
    super.initState();

    // ^ Listen to Status Changes ^ //
    controller.addListenerId("Bubble_" + widget.peer.id, () {
      // Retreive Sequence of Events
      List<Status> seq = controller.sequence();
      Status prevStatus = seq[0];
      Status currStatus = seq[1];

      // @ Pending -> Busy = Peer Accepted File
      if (prevStatus == Status.Pending && currStatus == Status.Busy) {
        setState(() => _accepted.isActive = hasAccepted = !hasAccepted);
      }

      // @ Pending -> Searching = Peer Denied File
      if (prevStatus == Status.Pending && currStatus == Status.Searching) {
        setState(() => _denied.isActive = hasDenied = !hasDenied);
      }

      // @ Pending -> Searching = Peer Completed File
      if (prevStatus == Status.Busy && currStatus == Status.Complete) {
        setState(() => _complete.isActive = hasCompleted = !hasCompleted);
      }
    });
  }

  // ^ Loads dat afrom a Rive file and initializes playback ^
  _loadRiveFile() async {
    // Load your Rive data
    final data = await rootBundle.load('assets/animations/peerbubble.riv');
    // Create a RiveFile from the binary data
    final file = RiveFile();
    if (file.import(data)) {
      // Get the artboard containing the animation you want to play
      final artboard = file.mainArtboard;

      // Add Animation Controllers
      artboard.addController(SimpleAnimation('Idle'));
      artboard.addController(_pending = SimpleAnimation('Pending'));
      artboard.addController(_denied = SimpleAnimation('Denied'));
      artboard.addController(_accepted = SimpleAnimation('Accepted'));
      artboard.addController(_complete = SimpleAnimation('Completed'));

      // Set Default States
      _pending.isActive = isInvited;
      _denied.isActive = hasDenied;
      _accepted.isActive = hasAccepted;
      _complete.isActive = hasCompleted;

      // Wrapped in setState so the widget knows the artboard is ready to play
      setState(() => _artboard = artboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: calculateOffset(widget.value).dy,
        left: calculateOffset(widget.value).dx,
        child: GestureDetector(
            onTap: () async {
              if (!isInvited) {
                controller.invitePeer(widget.peer);
                setState(() => _pending.isActive = isInvited = !isInvited);
              }
            },
            child: PlayAnimation<double>(
                tween: (0.0).tweenTo(1.0),
                duration: 500.milliseconds,
                delay: 1.seconds,
                builder: (context, child, value) {
                  return Container(
                      width: 90,
                      height: 90,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(167, 179, 190, value),
                          offset: Offset(0, 2),
                          blurRadius: 6,
                          spreadRadius: 0.5,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(248, 252, 255, value / 2),
                          offset: Offset(-2, 0),
                          blurRadius: 6,
                          spreadRadius: 0.5,
                        ),
                      ]),
                      child: Stack(alignment: Alignment.center, children: [
                        Rive(
                          artboard: _artboard,
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                        ),
                        _buildContentVisibility(),
                      ]));
                })));
  }

  // ^ Method to Change Content Visibility By State ^ //
  Widget _buildContentVisibility() {
    if (hasCompleted || hasAccepted || hasDenied) {
      return PlayAnimation<double>(
          tween: (1.0).tweenTo(0.0),
          duration: 20.milliseconds,
          builder: (context, child, value) {
            return AnimatedOpacity(
                opacity: value,
                duration: 20.milliseconds,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  iconFromPeer(widget.peer, size: 20),
                  initialsFromPeer(widget.peer),
                ]));
          });
    }
    return PlayAnimation<double>(
        tween: (0.0).tweenTo(1.0),
        duration: 500.milliseconds,
        delay: 1.seconds,
        builder: (context, child, value) {
          return AnimatedOpacity(
              opacity: value,
              duration: 500.milliseconds,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                iconFromPeer(widget.peer, size: 20),
                initialsFromPeer(widget.peer),
              ]));
        });
  }
}
