import 'dart:ui';

import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/models/models.dart';

class PendingBubble extends StatefulWidget {
  final double value;
  final Peer peer;

  const PendingBubble(this.value, this.peer, {Key key}) : super(key: key);

  @override
  _PendingBubbleState createState() => _PendingBubbleState();
}

class _PendingBubbleState extends State<PendingBubble>
    with TickerProviderStateMixin {
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
