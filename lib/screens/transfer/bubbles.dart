part of 'transfer.dart';

class BubbleView extends StatefulWidget {
  final List<Peer> activePeers;
  BubbleView(this.activePeers);

  @override
  State<StatefulWidget> createState() {
    return _BubbleAnimationState();
  }
}

class _BubbleAnimationState extends State<BubbleView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.stop();
    _controller.reset();
    _controller.repeat(
      period: Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildStackView(widget.activePeers, _animation),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
