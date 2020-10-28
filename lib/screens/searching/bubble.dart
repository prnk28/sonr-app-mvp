part of 'searching.dart';

class PeerBubble extends StatefulWidget {
  final double value;
  final Node peer;

  const PeerBubble(this.value, this.peer, {Key key}) : super(key: key);
  @override
  _PeerBubbleState createState() => _PeerBubbleState();
}

class _PeerBubbleState extends State<PeerBubble> with TickerProviderStateMixin {
  // Animation
  AnimationController _animationController;
  Animation _animation;
  FToast fToast;

  @override
  void initState() {
    super.initState();
    // Toast Setup
    fToast = FToast();

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
    return BlocBuilder<UserBloc, UserState>(
        // Set Build Requirements
        buildWhen: (prev, curr) {
      if (curr is NodeRequestInProgress) {
        return true;
      } else if (curr is NodeRequestFailure) {
        return true;
      } else if (curr is NodeTransferInProgress) {
        return true;
      } else if (curr is NodeTransferSuccess) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      // Initialize Toast
      fToast.init(context);

      // Get Bloc References
      final data = context.getBloc(BlocType.Data);
      final user = context.getBloc(BlocType.User);

      // ** Create Requested Node Bubble **
      if (state is NodeRequestInProgress) {
        // Check if Current Node Requested
        if (state.match.id == widget.peer.id) {
          return Positioned(
              top: _calculateOffset(widget.value, widget.peer.proximity).dy,
              left: _calculateOffset(widget.value, widget.peer.proximity).dx,
              child: Container(
                child: _getBubbleContent(widget.peer),
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
        // Build as Standby Node
        return _buildActiveNode(data, user, interactable: false);
      }

      // ** Peer has Declined **
      else if (state is NodeRequestFailure) {
        // Check if Current Node Rejected
        if (state.rejecter.id == widget.peer.id) {
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
                  child: FlareActor("assets/animations/denied.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "animate"),
                ),
              )));
        }
        // Build as Active Node
        return _buildActiveNode(data, user);
      }

      // ** Peer Accepted: Transfer is in Progress **
      else if (state is NodeTransferInProgress) {
        if (state.match.id == widget.peer.id) {
          return BlocBuilder<ProgressCubit, double>(
              cubit: context.getCubit(CubitType.Progress),
              builder: (context, state) {
                return Positioned(
                    top: _calculateOffset(widget.value, widget.peer.proximity)
                        .dy,
                    left: _calculateOffset(widget.value, widget.peer.proximity)
                        .dx,
                    child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Neumorphic(
                              style: NeumorphicStyle(
                                  depth: 10,
                                  boxShape: NeumorphicBoxShape.circle()),
                              child: SizedBox(
                                child: CircularProgressIndicator(
                                    value: state, strokeWidth: 6),
                                height: 86.0,
                                width: 86.0,
                              )),
                          _getBubbleContent(widget.peer),
                        ]));
              });
        }

        // Build as Standby Node
        return _buildActiveNode(data, user, interactable: false);
      }

      // ** Peer has Completed Transfer **
      else if (state is NodeTransferSuccess) {
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
                child: FlareActor("assets/animations/complete.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "Untitled"),
              ),
            )));
      }
      // ** Create Active Node Bubble **
      return _buildActiveNode(data, user);
    });
  }

  _buildActiveNode(data, user, {bool interactable: true}) {
    // Build Active Bubble
    return BlocConsumer<DataBloc, DataState>(listenWhen: (previous, current) {
      if (current is PeerQueueSuccess) {
        return true;
      }
      return false;
    }, listener: (context, state) {
      if (state is PeerQueueSuccess) {
        showGreenToast(fToast, "File ready!", Icons.check);
      }
    },
        // Build Requirements
        buildWhen: (previous, current) {
      if (current is PeerQueueInProgress) {
        return true;
      } else if (current is PeerQueueSuccess) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      // Initialize Child
      var bubbleChild;

      // Bubble can be interacted
      if (interactable) {
        bubbleChild = GestureDetector(
            onTap: () async {
              // File not yet loaded
              if (state is PeerQueueInProgress) {
                showRedToast(fToast, "File isnt ready", Icons.error);
              }
              // File is Loaded send offer
              else if (state is PeerQueueSuccess) {
                // Send Offer to Bubble
                user.add(NodeOffered(
                    context.getBloc(BlocType.Data), widget.peer,
                    file: data.currentFile));
              }
            },
            child: _getBubbleContent(widget.peer));
      }
      // Bubble Busy
      else {
        bubbleChild = _getBubbleContent(widget.peer);
      }
      // Build Bubble
      return Positioned(
          top: _calculateOffset(widget.value, widget.peer.proximity).dy,
          left: _calculateOffset(widget.value, widget.peer.proximity).dx,
          child: bubbleChild);
    });
  }

  _getBubbleContent(Node peer) {
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
