import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/core/core.dart';
import 'package:equatable/equatable.dart';

part 'web_event.dart';
part 'web_state.dart';

// ***********************
// ** Sonar Bloc Class ***
// ***********************
class WebBloc extends Bloc<WebEvent, WebState> {
  // Data Providers
  StreamSubscription directionSubscription;
  double _lastDirection;

  // Required Blocs
  final DataBloc data;
  final DeviceBloc device;
  final UserBloc user;

  // Constructer
  WebBloc(this.data, this.device, this.user) : super(null) {
    // ****************************** //
    // ** Device BLoC Subscription ** //
    // ****************************** //
    directionSubscription = device.directionCubit.listen((direction) {
      // Check Diff Direction
      if (direction != _lastDirection && this.state is! Loading) {
        // Device is Searching
        if (this.state is Searching) {
          add(Search());
        }
        // Send with 500ms delay
        else if (this.state is Active) {
          add(Active());
        }
        _lastDirection = direction;
      }
    });
  }

  // Initial State
  WebState get initialState => Disconnected();

  // On Bloc Close
  void dispose() {
    directionSubscription.cancel();
  }

// *********************************
// ** Map Events to State Method ***
// *********************************
  @override
  Stream<WebState> mapEventToState(
    WebEvent event,
  ) async* {
    // Device Can See Updates
    if (event is Connect) {
      yield* _mapConnectToState(event);
    } else if (event is Load) {
      yield* _mapLoadToState(event);
    } else if (event is Active) {
      yield* _mapActiveToState(event);
    } else if (event is Search) {
      yield* _mapSearchToState(event);
    } else if (event is Handle) {
      yield* _mapHandleToState(event);
    } else if (event is Invite) {
      yield* _mapInviteToState(event);
    } else if (event is Authorize) {
      yield* _mapAuthorizeToState(event);
    } else if (event is Create) {
      yield* _mapCreateToState(event);
    } else if (event is Complete) {
      yield* _mapCompleteToState(event);
    } else if (event is Fail) {
      yield* _mapFailToState(event);
    }
  }

// ********************
// ** Connect Event ***
// ********************
  Stream<WebState> _mapConnectToState(Connect event) async* {
    // Check if Peer Node exists
    if (user.node != null) {
      // Emit Peer Node
      user.node.emit(OutgoingMessage.Connect);

      // Device Pending State
      yield Available();
    }
    // No Peer Node in User Bloc
    else {
      log.e("Node Data not provided for WebBloc:Connect Event");
      yield Disconnected();
    }
  }

// *****************
// ** Load Event ***
// *****************
  Stream<WebState> _mapLoadToState(Load event) async* {
    // Device Pending State
    yield Loading();
  }

// *******************
// ** Active Event ***
// *******************
  Stream<WebState> _mapActiveToState(Active event) async* {
    // Update Status
    user.node.status = PeerStatus.Active;

    // Add Delay
    // await Future.delayed(const Duration(milliseconds: 500));

    // Yield Searching with Closest Neighbor
    yield Available();
  }

// *********************
// ** Search Event ***
// *********************
  Stream<WebState> _mapSearchToState(Search event) async* {
    // Update Status
    user.node.status = PeerStatus.Searching;

    // Add Delay
    // Future.delayed(const Duration(milliseconds: 250));

    // Yield Searching with Closest Neighbor
    yield Searching(activePeers: user.node.getZonedPeers());
  }

// ***************************************** //
// ** Handle Event = OFFER/ANSWER/DECLINE ** //
// ***************************************** //
  Stream<WebState> _mapHandleToState(Handle event) async* {
    // Get Message
    var msg = event.message;

    // Log Message
    log.i(enumAsString(event.type) + ": " + msg.toString());

    // Check Event Type
    switch (event.type) {
      case IncomingMessage.Connected:
        // Set Lobby Id
        user.node.lobbyId = msg["lobbyId"];
        add(Active());
        break;
      case IncomingMessage.Updated:
        // Get Peer
        Peer peer = Peer.fromMap(msg);

        // Check Node Status: Senders are From
        if (user.node.canSendTo(peer)) {
          // Find Previous Node
          Peer previousNode = graph.singleWhere(
              (element) => element.session_id == peer.id,
              orElse: () => null);

          // Remove Peer Node
          graph.remove(previousNode);

          // Calculate Difference and Create Edge
          graph.setToBy<double>(
              user.node, peer, Peer.getDifference(user.node, peer));
        }
        // Check Node Status: Receivers are To
        else if (user.node.canReceiveFrom(peer)) {
          // Find Previous Node
          var previousNode = graph.singleWhere(
              (element) => element.session_id == peer.id,
              orElse: () => null);

          // Remove Peer Node
          graph.remove(previousNode);

          // Calculate Difference and Create Edge
          graph.setToBy<double>(
              peer, user.node, Peer.getDifference(peer, user.node));
        }

        // Initialize Pathfinder
        PathFinder pathFinder = new PathFinder(graph, user.node);

        // Yield Searching
        yield Searching(pathfinder: pathFinder);
        break;
      case IncomingMessage.Exit:
        // Get Peer
        Peer peer = Peer.fromMap(msg);

        // Find Previous Node
        var previousNode = graph.singleWhere(
            (element) => element.session_id == peer.id,
            orElse: () => null);

        // Remove Peer Node
        graph.remove(previousNode);

        // Initialize Pathfinder
        PathFinder pathFinder = new PathFinder(graph, user.node);

        // Yield Searching
        yield Searching(pathfinder: pathFinder);
        break;
      case IncomingMessage.Offered:
        // Get Peer
        Peer peer = Peer.fromMap(msg["from"]);

        // Update Device Status
        user.node.status = PeerStatus.Busy;
        yield Pending();
        break;
      case IncomingMessage.Answered:
        // Get Peer
        Peer match = Peer.fromMap(msg["from"]);

        // Handle Answer
        var description = msg['description'];

        // Update Session Info
        var pc = session._peerConnections[match.id];
        if (pc != null) {
          await pc.setRemoteDescription(new RTCSessionDescription(
              description['sdp'], description['type']));
        }
        // Begin Transfer
        data.add(SendChunks());
        yield Transferring();
        break;
      case IncomingMessage.Declined:
        add(Fail());
        break;
      case IncomingMessage.Completed:
        add(Complete());
        break;
      default:
        break;
    }
  }

// *******************
// ** Invite Event ***
// *******************
  Stream<WebState> _mapInviteToState(Invite event) async* {
    // Update Node and Device State
    user.node.status = PeerStatus.Busy;
    add(Search());

    // Set Session Id
    session.session_id = user.node.id + "-" + event.match.id;

    // Initialize RTC Peer Connection
    session._createPeerConnection(event.match.id).then((pc) {
      // Set Peer Connection
      session._peerConnections[event.match.id] = pc;

      // Create DataChannel
      session._createDataChannel(event.match.id, pc);

      // Emit Offer
      add(Create(MessageKind.OFFER,
          metadata: event.metadata, pc: pc, match: event.match));
    });

    // Device Pending State
    yield Pending(match: event.match);
  }

// ***********************
// ** Authorize Event ***
// ***********************
  Stream<WebState> _mapAuthorizeToState(Authorize event) async* {
    // Get Message
    var msg = event.message;

    // Get Peer
    Peer match = Peer.fromMap(msg["from"]);

    // User ACCEPTED Transfer Request
    if (event.decision) {
      // Add Incoming File Info
      data.add(QueueFile(
        info: msg["file_info"],
      ));

      // Extract Message Info
      var description = msg['description'];
      session.session_id = msg["session_id"];

      // Set New State Change
      if (session.onStateChange != null) {
        session.onStateChange(SignalingState.CallStateNew);
      }

      // Initialize Peer Connection
      var pc = await session._createPeerConnection(match.id);
      await pc.setRemoteDescription(
          new RTCSessionDescription(description['sdp'], description['type']));

      add(Create(MessageKind.ANSWER, pc: pc, match: match));

      yield Transferring();
    }
    // User DECLINED Transfer Request
    else {
      // Send Decision
      socket.emit("DECLINE", match.id);
      add(Complete(resetSession: true));
    }
  }

// ***************************************** //
// ** Create Event = OFFER/ANSWER/DECLINE ** //
// ***************************************** //
  Stream<WebState> _mapCreateToState(Create event) async* {
    // Check Event Type
    switch (event.type) {
      case MessageKind.OFFER:
        try {
          // Create Session Description and Set
          RTCSessionDescription s = await event.pc.createOffer(RTC_CONSTRAINTS);
          event.pc.setLocalDescription(s);

          // Send Offer
          socket.emit('OFFER', {
            'to': event.match.id,
            'from': user.node.toMap(),
            'description': {'sdp': s.sdp, 'type': s.type},
            'session_id': session.session_id,
            'file_info': event.metadata.toMap()
          });
        } catch (e) {
          print(e.toString());
        }
        break;
      case MessageKind.ANSWER:
        try {
          // Create Session Description and Set
          RTCSessionDescription s =
              await event.pc.createAnswer(RTC_CONSTRAINTS);
          event.pc.setLocalDescription(s);

          // Send Answer
          socket.emit('ANSWER', {
            'to': event.match.id,
            'from': user.node.toMap(),
            'description': {'sdp': s.sdp, 'type': s.type},
            'session_id': session.session_id,
          });
        } catch (e) {
          print(e.toString());
        }

        // Add Candidates to PC
        if (session._remoteCandidates.length > 0) {
          session._remoteCandidates.forEach((candidate) async {
            await event.pc.addCandidate(candidate);
          });
          session._remoteCandidates.clear();
        }
        yield Transferring();
        break;
      default:
        yield Available();
        break;
    }
  }

// *********************
// ** Complete Event ***
// *********************
  Stream<WebState> _mapCompleteToState(Complete event) async* {
    // Check Reset Connection
    if (event.resetConnection) {
      socket.emit("CLOSE", user.node.toMap());
    }

    // Check Reset RTC Session
    if (event.resetSession) {
      session.close();
    }

    // Reset Node
    user.node.status = PeerStatus.Active;

    // Set Delay
    await new Future.delayed(Duration(seconds: 1));

    // Yield Ready
    add(Active());
  }

// *********************
// ** Fail Event ***
// *********************
  Stream<WebState> _mapFailToState(Fail event) async* {
    // Check Reset Connection
    if (event.resetConnection) {
      socket.emit("RESET");
    }

    // Check Reset RTC Session
    if (event.resetSession) {
      session.close();
    }

    // Set Delay
    await new Future.delayed(Duration(seconds: 1));

    // Yield Ready
    yield Failed();
  }
}
