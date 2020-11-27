import 'dart:ui';

import 'package:sonr_core/sonr_core.dart';
import '../../screens.dart';

part 'active.dart';
part 'completed.dart';
part 'content.dart';
part 'denied.dart';

class PeerBubble extends StatefulWidget {
  final double value;
  final Peer peer;

  const PeerBubble(this.value, this.peer, {Key key}) : super(key: key);
  @override
  _PeerBubbleState createState() => _PeerBubbleState();
}

class _PeerBubbleState extends State<PeerBubble> with TickerProviderStateMixin {
  // Animation
  AnimationController _animationController;
  Animation _animation;
  bool isInvited = false;

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
    // Initialize
    var sonrBloc = context.getBloc(BlocType.Sonr);
    var content = buildBubbleContent(widget.peer);

    return BlocBuilder<SonrBloc, SonrState>(builder: (context, state) {
      if (state is NodeSearching) {
        // Build as Active Node
        return ActiveBubble(content, widget.value, widget.peer, sonrBloc);
      }
      // ** Create Pending Bubble Node **
      else if (state is NodePending) {
        if (state.peer.id == widget.peer.id) {
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
        } else {
          // Build as Active Node
          return ActiveBubble(content, widget.value, widget.peer, sonrBloc);
        }
      } else {
        // Build For Auth Message Handling
        return BlocBuilder<AuthenticationCubit, AuthMessage>(
            cubit: context.getCubit(CubitType.Authentication),
            builder: (context, state) {
              // ** Create Progress Node Bubble **
              if (state.event == AuthMessage_Event.ACCEPT) {
                return Positioned(
                    top: calculateOffset(widget.value).dy,
                    left: calculateOffset(widget.value).dx,
                    child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Neumorphic(
                              style: NeumorphicStyle(
                                  depth: 10,
                                  boxShape: NeumorphicBoxShape.circle()),
                              child: SizedBox(
                                child:
                                    CircularProgressIndicator(strokeWidth: 6),
                                height: 86.0,
                                width: 86.0,
                              )),
                          buildBubbleContent(widget.peer),
                        ]));
              } else if (state.event == AuthMessage_Event.DECLINE) {
                return DeniedBubble();
              } else {
                return Container();
              }
            });
      }
      // ** Create Declined Node Bubble **
    });
  }
}
