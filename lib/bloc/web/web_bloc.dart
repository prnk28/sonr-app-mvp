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
  StreamSubscription deviceSubscription;

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
    deviceSubscription = device.listen((DeviceState deviceState) {
      // Device is Tilted or Landscape
      if (deviceState is Sending || deviceState is Receiving) {
        add(SendNode());
      }
      // Interacting with another Peer
      else if (deviceState is Busy) {
      }
      // Inactive
      else {}
    });
  }

  // Initial State
  WebState get initialState => Disconnected();

  // On Bloc Close
  void dispose() {
    deviceSubscription.cancel();
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
    } else if (event is SendNode) {
      yield* _mapSendNodeToState(event);
    } else if (event is UpdateGraph) {
      yield* _mapUpdateGraphToState(event);
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

    // Fake Select File in Queue
    File transferToSend =
        await getAssetFileByPath("assets/images/fat_test.jpg");
    data.add(QueueFile(file: transferToSend));

    // Device Pending State
    yield Connected();
  }

// *****************
// ** Load Event ***
// *****************
  Stream<WebState> _mapLoadToState(Load event) async* {
    // Device Pending State
    yield Loading();
  }

// *********************
// ** SendNode Event ***
// *********************
  Stream<WebState> _mapSendNodeToState(SendNode event) async* {
    // Load
    add(Load());

    // Send to Server
    socket.emit("UPDATE", user.node.toMap());

    // Initialize Pathfinder
    PathFinder pathFinder = new PathFinder(graph, user.node);

    // Yield Searching with Closest Neighbor
    yield Searching(pathfinder: pathFinder);
  }

// ************************
// ** UpdateGraph Event ***
// ************************
  Stream<WebState> _mapUpdateGraphToState(UpdateGraph event) async* {
    // Load
    add(Load());

    // -- Modify Graph Relations --
    switch (event.updateType) {
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
          graph.setToBy<double>(
              user.node, event.peer, Peer.getDifference(user.node, event.peer));
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
          graph.setToBy<double>(
              event.peer, user.node, Peer.getDifference(event.peer, user.node));
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
  }

// *******************
// ** Invite Event ***
// *******************
  Stream<WebState> _mapInviteToState(Invite event) async* {
    // Update Node and Device State
    device.add(Update(true));
    add(SendNode());

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
        yield Connected();
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
        add(SendNode());
        break;
      case MessageKind.OFFER:
        // Update Device Status
        device.add(Update(true));

        // Send Node
        add(SendNode());
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
    user.node.status = PeerStatus.Ready;
    add(SendNode());

    // Set Delay
    await new Future.delayed(Duration(seconds: 1));

    // Yield Ready
    yield Connected();
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
