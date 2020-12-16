import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sonar_app/controller/controller.dart';
import 'package:sonar_app/modules/widgets/design/util.dart';
import 'package:sonar_app/modules/widgets/painter/zones.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:rive/rive.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class PeerBubble extends StatefulWidget {
  // Bubble Values
  final double value;
  final Peer peer;

  PeerBubble(this.value, this.peer);

  @override
  _PeerBubbleState createState() => _PeerBubbleState();
}

class _PeerBubbleState extends State<PeerBubble> {
  TransferController controller = Get.find();
  bool isInvited = false;
  bool hasDenied = false;
  bool hasAccepted = false;
  bool inProgress = false;
  bool hasCompleted = false;
  Artboard _artboard;
  SimpleAnimation _idle, _pending, _denied, _accepted, _sending, _complete;

  @override
  void initState() {
    // Load Rive
    _loadRiveFile();
    super.initState();

    // ^ Listen to Status Changes ^ //
    controller.addListenerId(widget.peer.id, () {
      // @ Pending -> Busy = Peer Accepted File
      if (controller.status == Status.Busy) {
        if (mounted) {
          setState(() {
            _pending.instance.animation.loop = Loop.oneShot;
            _accepted.instance.animation.loop = Loop.oneShot;
            _accepted.isActive = hasAccepted = !hasAccepted;
          });
        }
      }

      // @ Pending -> Searching = Peer Denied File
      if (controller.status == Status.Searching) {
        if (mounted) {
          setState(() {
            _pending.instance.animation.loop = Loop.oneShot;
            _denied.instance.animation.loop = Loop.oneShot;
            _denied.isActive = hasDenied = !hasDenied;
          });
        }
      }

      // @ Pending -> Searching = Peer Completed File
      if (controller.status == Status.Complete) {
        if (mounted) {
          setState(() {
            if (inProgress) {
              _sending.instance.animation.loop = Loop.oneShot;
            }

            if (isInvited) {
              _pending.instance.animation.loop = Loop.oneShot;
            }

            // Start Complete Animation
            _complete.instance.animation.loop = Loop.oneShot;
            _complete.isActive = hasCompleted = !hasCompleted;
          });
        }
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
      artboard.addController(_idle = SimpleAnimation('Idle'));
      artboard.addController(_pending = SimpleAnimation('Pending'));
      artboard.addController(_denied = SimpleAnimation('Denied'));
      artboard.addController(_accepted = SimpleAnimation('Accepted'));
      artboard.addController(_sending = SimpleAnimation('Sending'));
      artboard.addController(_complete = SimpleAnimation('Complete'));

      // Set Default States
      _idle.isActive = !isInvited && !hasCompleted;
      _pending.isActive = isInvited;
      _denied.isActive = hasDenied;
      _accepted.isActive = hasAccepted;
      _sending.isActive = inProgress;
      _complete.isActive = hasCompleted;

      // Add One Shot Listeners
      _accepted.isActiveChanged.addListener(_handleAcceptToSend);
      _complete.isActiveChanged.addListener(_handleReset);

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
                if (mounted) {
                  setState(() => _pending.isActive = isInvited = !isInvited);
                }
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

  // ^ Add listener for file transfer ^
  _handleAcceptToSend() {
    if (_accepted.isActive == false) {
      if (mounted) {
        setState(() {
          hasAccepted = !hasAccepted;
          _sending.isActive = inProgress = !inProgress;
        });
      }
    }
  }

  // ^ Add listener for file transfer ^
  _handleReset() {
    if (_complete.isActive == false) {
      if (mounted) {
        setState(() {
          hasCompleted = false;
          isInvited = true;
          _idle.isActive = true;
          _complete.mix = 0.0;
        });
      }
    }
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
}
