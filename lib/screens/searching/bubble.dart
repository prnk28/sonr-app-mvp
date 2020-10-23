part of 'search.dart';

class Bubble extends StatefulWidget {
  final double value;
  final Node peer;

  const Bubble(this.value, this.peer, {Key key}) : super(key: key);
  @override
  _BubbleState createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> with TickerProviderStateMixin {
  // Animation
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 1.0, end: 16.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        // Set Build Requirements
        buildWhen: (prev, curr) {
      if (curr is NodeSearchSuccess) {
        return true;
      } else if (curr is NodeRequestInProgress) {
        return true;
      } else if (curr is NodeRequestFailure) {
        return true;
      } else if (curr is NodeTransferInProgress) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      // ** Create Active Node Bubble **
      if (state is NodeSearchSuccess) {
        // BLoC References
        final data = context.getBloc(BlocType.Data);
        final user = context.getBloc(BlocType.User);

        // Build Active Bubble
        return Positioned(
            top: _calculateOffset(widget.value, widget.peer.proximity).dy,
            left: _calculateOffset(widget.value, widget.peer.proximity).dx,
            child: GestureDetector(
                onTap: () async {
                  // Send Offer to Bubble
                  user.add(NodeOffered(widget.peer, file: data.currentFile));
                },
                child: _getBubble(widget.peer)));
      }

      // ** Create Requested Node Bubble **
      else if (state is NodeRequestInProgress) {
        return Positioned(
            top: _calculateOffset(widget.value, widget.peer.proximity).dy,
            left: _calculateOffset(widget.value, widget.peer.proximity).dx,
            child: Container(
              child: _getBubble(widget.peer),
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

      // ** Peer has Declined **
      else if (state is NodeRequestFailure) {
        return Positioned(
            top: _calculateOffset(widget.value, widget.peer.proximity).dy,
            left: _calculateOffset(widget.value, widget.peer.proximity).dx,
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
                child: FlareActor("assets/animations/red_cross.flr",
                    alignment: Alignment.center, fit: BoxFit.contain),
              ),
            )));
      }

      // ** Peer Accepted: Transfer is in Progress **
      else if (state is NodeTransferInProgress) {
        return BlocBuilder<ProgressCubit, double>(
            cubit: context.getCubit(CubitType.Progress),
            builder: (context, state) {
              return Positioned(
                  top: _calculateOffset(widget.value, widget.peer.proximity).dy,
                  left:
                      _calculateOffset(widget.value, widget.peer.proximity).dx,
                  child:
                      Stack(alignment: AlignmentDirectional.center, children: [
                    Neumorphic(
                        style: NeumorphicStyle(
                            depth: 10, boxShape: NeumorphicBoxShape.circle()),
                        child: SizedBox(
                          child: CircularProgressIndicator(
                              value: state, strokeWidth: 6),
                          height: 86.0,
                          width: 86.0,
                        )),
                    _getBubble(widget.peer),
                  ]));
            });
      }
      return Container();
    });
  }

  _getBubble(Node peer) {
    // Content
    var icon;
    var initials;

    // Get Icon
    if (peer.device == "ANDROID") {
      icon = NeumorphicIcon((Icons.android),
          size: 30, style: NeumorphicStyle(color: Colors.green[200]));
    } else if (peer.device == "IOS") {
      icon = NeumorphicIcon((Icons.phone_iphone),
          size: 30, style: NeumorphicStyle(color: Colors.grey[500]));
    } else {
      icon = NeumorphicIcon((Icons.device_unknown));
    }

    // Get Initials
    initials = Text(
        peer.profile.firstName[0].toUpperCase() +
            peer.profile.lastName[0].toUpperCase(),
        style: mediumTextStyle());

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
              initials,
              icon,
            ],
          ),
        ));
  }

// ******************************** //
// ** Calculate Offset from Line ** //
// ******************************** //
  Offset _calculateOffset(double value, Proximity proximity) {
    Path path = ZonePainter.getBubblePath(screenSize.width, proximity);
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }
}
