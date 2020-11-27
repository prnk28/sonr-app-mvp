part of '../searching.dart';

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
    return BlocBuilder<SonrBloc, SonrState>(
        // Set Build Requirements
        buildWhen: (prev, curr) {
      if (curr is PeerInvited) {
        return true;
      } else if (curr is PeerInviteDeclined) {
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

      // ** Create Requested Node Bubble **
      if (state is PeerInvited) {
        // Check if Current Node Requested
        if (state.peer.id == widget.peer.id) {
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
        return _buildActiveNode(state, interactable: false);
      }

      // ** Peer has Declined **
      else if (state is PeerInviteDeclined) {
        // Check if Current Node Rejected
        if (state.peer.id == widget.peer.id) {
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
        return _buildActiveNode(state);
      }

      // ** Peer Accepted: Transfer is in Progress **
      else if (state is NodeTransferInProgress) {
        if (state.receiver.id == widget.peer.id) {
          return BlocBuilder<ProgressCubit, double>(
              cubit: context.getCubit(CubitType.Exchange),
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
        return _buildActiveNode(state, interactable: false);
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
      return _buildActiveNode(state);
    });
  }

  _buildActiveNode(sonr, {bool interactable: true}) {
    // Build Active Bubble
    return BlocConsumer<SonrBloc, SonrState>(listenWhen: (previous, current) {
      if (current is NodeSearching) {
        return true;
      }
      return false;
    }, listener: (context, state) {
      if (state is NodeSearching) {
        showGreenToast(fToast, "File ready!", Icons.check);
      }
    },
        // Build Requirements
        buildWhen: (previous, current) {
      if (current is NodeQueueing) {
        return true;
      } else if (current is NodeQueueing) {
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
              if (state is NodeQueueing) {
                showRedToast(fToast, "File isnt ready", Icons.error);
              }
              // File is Loaded send offer
              else if (state is NodeSearching) {
                // Send Offer to Bubble
                sonr.add(NodeInvitePeer(widget.peer));
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

  _getBubbleContent(Peer peer) {
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
        peer.firstName[0].toUpperCase() + peer.lastName[0].toUpperCase(),
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
  Offset _calculateOffset(double value, Peer_Proximity proximity) {
    Path path = ZonePainter.getBubblePath(screenSize.width, proximity);
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }
}
