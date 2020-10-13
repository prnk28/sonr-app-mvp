import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:graph_collection/graph.dart';

part 'web_event.dart';
part 'web_state.dart';

// ***********************
// ** Sonar Bloc Class ***
// ***********************
class WebBloc extends Bloc<WebEvent, WebState> {
  // Data Providers
  DirectedValueGraph graph;
  Connection connection;
  StreamSubscription directionSubscription;
  double _lastDirection;

  // Required Blocs
  final DataBloc data;
  final DeviceBloc device;
  final UserBloc user;

  // Constructer
  WebBloc(this.data, this.device, this.user) : super(null) {
    // ** Initialization
    graph = new DirectedValueGraph();
    connection = new Connection(this, this.user);

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
          add(Update(UpdateType.NODE));
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
    } else if (event is Search) {
      yield* _mapSearchToState(event);
    } else if (event is Update) {
      yield* _mapUpdateToState(event);
    } else if (event is Invite) {
      yield* _mapInviteToState(event);
    } else if (event is Authorize) {
      yield* _mapAuthorizeToState(event);
    } else if (event is Create) {
      yield* _mapCreateToState(event);
    } else if (event is Handle) {
      yield* _mapHandleToState(event);
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
    // Emit to Socket.io from User Peer Node
    socket.emit("CONNECT", user.node.toMap());

    // Device Pending State
    yield Active();
  }

// *****************
// ** Load Event ***
// *****************
  Stream<WebState> _mapLoadToState(Load event) async* {
    // Device Pending State
    yield Loading();
  }

// *********************
// ** Search Event ***
// *********************
  Stream<WebState> _mapSearchToState(Search event) async* {
    // Update Status
    add(Update(UpdateType.STATUS, newStatus: PeerStatus.Searching));

    // Add Delay
    // Future.delayed(const Duration(milliseconds: 250));

    // Send to Server
    socket.emit("UPDATE", user.node.toMap());

    // Initialize Pathfinder
    PathFinder pathFinder = new PathFinder(graph, user.node);

    // Yield Searching with Closest Neighbor
    yield Searching(pathfinder: pathFinder);
  }

// *******************
// ** Update Event ***
// *******************
  Stream<WebState> _mapUpdateToState(Update event) async* {
    // By Event Type
    switch (event.type) {
      case UpdateType.NODE:
// Add Delay
        // await Future.delayed(const Duration(milliseconds: 500));

// Change status
        add(Update(UpdateType.STATUS, newStatus: PeerStatus.Active));

        // Send to Server
        socket.emit("UPDATE", user.node.toMap());

        // Yield Searching with Closest Neighbor
        yield Active();
        break;
      case UpdateType.GRAPH:
        // -- Modify Graph Relations --
        switch (event.graphUpdate) {
// -- Peer Updated Sensory Input --
          case GraphUpdate.UPDATE:
            // Check Node Status: Senders are From
            if (user.node.canSendTo(event.peer)) {
              // Find Previous Node
              Peer previousNode = graph.singleWhere(
                  (element) => element.id == event.peer.id,
                  orElse: () => null);

              // Remove Peer Node
              graph.remove(previousNode);

              // Calculate Difference and Create Edge
              graph.setToBy<double>(user.node, event.peer,
                  Peer.getDifference(user.node, event.peer));
            }
            // Check Node Status: Receivers are To
            else if (user.node.canReceiveFrom(event.peer)) {
              // Find Previous Node
              var previousNode = graph.singleWhere(
                  (element) => element.id == event.peer.id,
                  orElse: () => null);

              // Remove Peer Node
              graph.remove(previousNode);

              // Calculate Difference and Create Edge
              graph.setToBy<double>(event.peer, user.node,
                  Peer.getDifference(event.peer, user.node));
            }
            break;
          // Peer Left Lobby
          case GraphUpdate.EXIT:
            log.i("Peer exited Graph");
            // Find Previous Node
            var previousNode = graph.singleWhere(
                (element) => element.id == event.peer.id,
                orElse: () => null);

            // Remove Peer Node
            graph.remove(previousNode);
            break;
        }
// Initialize Pathfinder
        PathFinder pathFinder = new PathFinder(graph, user.node);

        // Yield Searching
        yield Searching(pathfinder: pathFinder);
        break;
      case UpdateType.STATUS:
        //add(Load());
        user.node.status = event.newStatus;
        break;
    }
  }

// *******************
// ** Invite Event ***
// *******************
  Stream<WebState> _mapInviteToState(Invite event) async* {
    // Update Node and Device State
    add(Update(UpdateType.STATUS, newStatus: PeerStatus.Busy));
    add(Search());

    // Set Session Id
    session.id = user.node.id + "-" + event.match.id;

    // Initialize RTC Peer Connection
    session.initPeerConnection(event.match.id).then((pc) {
      // Set Peer Connection
      session.peerConnections[event.match.id] = pc;

      // Create DataChannel
      session.createDataChannel(event.match.id, pc);

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
    // User ACCEPTED Transfer Request
    if (event.decision) {
      // Get Message
      var msg = event.message;

      // Add Incoming File Info
      data.add(QueueFile(
        info: msg["file_info"],
      ));

      // Extract Message Info
      var id = msg['from'];
      var description = msg['description'];
      session.id = msg["session_id"];

      // Set New State Change
      if (session.onStateChange != null) {
        session.onStateChange(SignalingState.CallStateNew);
      }

      // Initialize Peer Connection
      var pc = await session.initPeerConnection(id);
      await pc.setRemoteDescription(
          new RTCSessionDescription(description['sdp'], description['type']));

      add(Create(MessageKind.ANSWER, pc: pc, match: event.match));

      yield Transferring();
    }
    // User DECLINED Transfer Request
    else {
      // Send Decision
      socket.emit("DECLINE", event.match.id);
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
            'session_id': session.id,
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
            'session_id': session.id,
          });
        } catch (e) {
          print(e.toString());
        }

        // Add Candidates to PC
        if (session.remoteCandidates.length > 0) {
          session.remoteCandidates.forEach((candidate) async {
            await event.pc.addCandidate(candidate);
          });
          session.remoteCandidates.clear();
        }
        yield Transferring();
        break;
      default:
        yield Active();
        break;
    }
  }

// ***************************************** //
// ** Handle Event = OFFER/ANSWER/DECLINE ** //
// ***************************************** //
  Stream<WebState> _mapHandleToState(Handle event) async* {
    // Get Message
    var msg = event.message;

    // Check Event Type
    switch (event.type) {
      case MessageKind.CONNECTED:
        // Setup Beacons
        add(Update(UpdateType.NODE));
        break;
      case MessageKind.OFFER:
        // Update Device Status
        add(Update(UpdateType.STATUS, newStatus: PeerStatus.Busy));

        // Send Node
        add(Search());
        yield Pending(
          match: event.match,
        );
        break;
      case MessageKind.ANSWER:
        // Handle Answer
        var id = msg['from'];
        var description = msg['description'];

        // Update Session Info
        var pc = session.peerConnections[id];
        if (pc != null) {
          await pc.setRemoteDescription(new RTCSessionDescription(
              description['sdp'], description['type']));
        }
        // Begin Transfer
        data.add(SendChunks());
        yield Transferring();
        break;
      case MessageKind.DECLINED:
        add(Fail());
        break;
      case MessageKind.COMPLETE:
        add(Complete());
        break;
      default:
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
    add(Update(UpdateType.STATUS, newStatus: PeerStatus.Active));
    add(Update(UpdateType.NODE));

    // Set Delay
    await new Future.delayed(Duration(seconds: 1));

    // Yield Ready
    yield Active();
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
