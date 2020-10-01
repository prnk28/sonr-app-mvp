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
  Graph graph;
  StreamSubscription deviceSubscription;

  // Required Blocs
  final DataBloc data;
  final DeviceBloc device;
  final UserBloc user;

  // Constructer
  WebBloc(this.data, this.device, this.user) : super(null) {
    // ** Initialization
    graph = new Graph();

    // ****************************** //
    // ** Device BLoC Subscription ** //
    // ****************************** //
    deviceSubscription = device.listen((DeviceState deviceState) {
      // Device can Record Data/ Portrait
      if (deviceState is Ready) {
        log.i("DeviceBloc State: Ready <- from WebBloc");
      }
      // Device is Tilted or Landscape
      else if (deviceState is Sending || deviceState is Receiving) {
        add(UpdateNode());
      }
      // Interacting with another Peer
      else if (deviceState is Busy) {
      }
      // Inactive
      else {}
    });

    // ***************************** //
    // ** Socket Message Listener ** //
    // ***************************** //
    // -- USER CONNECTED TO SOCKET SERVER --
    socket.on('CONNECTED', (data) {
      user.node.id = socket.id;
      //bloc.add(Reload(newDirection: bloc.device.
    });

    // -- NODE APPEARED IN LOBBY --
    socket.on('NODE_ENTER', (data) {
      Peer peer = Peer.fromMap(data);
      add(UpdateGraph(GraphUpdate.ENTER, peer));
    });

    // -- UPDATE TO A NODE IN LOBBY --
    socket.on('NODE_UPDATE', (data) {
      Peer peer = Peer.fromMap(data);
      add(UpdateGraph(GraphUpdate.UPDATE, peer));
    });

    // -- NODE EXITED LOBBY --
    socket.on('NODE_EXIT', (data) {
      Peer peer = Peer.fromMap(data);
      add(UpdateGraph(GraphUpdate.EXIT, peer));
    });

    // -- OFFER REQUEST --
    socket.on('PEER_OFFERED', (data) {
      //bloc.add(HandleOffer(offer: data[0], profile: data[1]));
    });

    // -- MATCH ACCEPTED REQUEST --
    socket.on('PEER_ANSWERED', (data) {
      //bloc.add(Reload(newDirection: bloc.device.
    });

    // -- MATCH DECLINED REQUEST --
    socket.on('PEER_DECLINED', (data) {
      //bloc.add(Reload(newDirection: bloc.device.direction));
    });

    // -- MATCH ICE CANDIDATES --
    socket.on('PEER_CANDIDATE', (data) {
      //bloc.add(Reload(newDirection: bloc.device.
      rtcSession.handleCandidate(data);
    });

    // -- MATCH RECEIVED FILE --
    socket.on('COMPLETE', (data) {
      //bloc.add(Reload(newDirection: bloc.device.direction));
    });

    // -- ERROR OCCURRED (Cancelled, Internal) --
    socket.on('ERROR', (error) {
      // Add to Process
      log.e("ERROR: " + error);
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
    } else if (event is UpdateNode) {
      yield* _mapUpdateNodeToState(event);
    } else if (event is UpdateGraph) {
      yield* _mapUpdateGraphToState(event);
    } else if (event is SendOffer) {
      yield* _mapSendOfferToState(event);
    } else if (event is Authorize) {
      yield* _mapAuthorizeToState(event);
    } else if (event is HandleOffer) {
      yield* _mapOfferedToState(event);
    } else if (event is HandleAnswer) {
      yield* _mapAcceptedToState(event);
    } else if (event is HandleDecline) {
      yield* _mapDeclinedToState(event);
    } else if (event is BeginTransfer) {
      yield* _mapBeginTransferToState(event);
    } else if (event is HandleComplete) {
      yield* _mapHandleCompleteToState(event);
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
    data.add(QueueFile(receiving: false, file: transferToSend));

    // Device Pending State
    yield Connected();
  }

// ***********************
// ** UpdateNode Event ***
// ***********************
  Stream<WebState> _mapUpdateNodeToState(UpdateNode event) async* {
    // Set Delay
    await new Future.delayed(Duration(milliseconds: 500));

    // Send to Server
    socket.emit("UPDATE", user.node.toMap());

    // Set Suspend state with lastState
    yield Searching();
  }

// ************************
// ** UpdateGraph Event ***
// ************************
  Stream<WebState> _mapUpdateGraphToState(UpdateGraph event) async* {
    // -- Modify Graph Relations --
    switch (event.updateType) {
      // -- Peer has Appeared --
      case GraphUpdate.ENTER:
        // Check Node Status: Senders are From
        if (user.node.status == PeerStatus.Sending &&
            event.peer.status == PeerStatus.Receiving) {
          // Calculate Difference
          double difference =
              user.node.direction - event.peer.antipodalDirection;

          // Create Edge
          graph.setToBy(user.node, event.peer, difference);
        }
        // Check Node Status: Receivers are To
        else if (user.node.status == PeerStatus.Receiving &&
            event.peer.status == PeerStatus.Sending) {
          // Calculate Difference
          double difference =
              user.node.antipodalDirection - event.peer.direction;

          // Create Edge
          graph.setToBy(event.peer, user.node, difference);
        }
        break;

      // -- Peer Updated Sensory Input --
      case GraphUpdate.UPDATE:
        // Check Node Status: Senders are From
        if (user.node.status == PeerStatus.Sending &&
            event.peer.status == PeerStatus.Receiving) {
          // Calculate Difference
          double difference =
              user.node.direction - event.peer.antipodalDirection;

          // Remove Peer Node
          graph.remove(event.peer);

          // Create Edge
          graph.setToBy(user.node, event.peer, difference);
        }
        // Check Node Status: Receivers are To
        else if (user.node.status == PeerStatus.Receiving &&
            event.peer.status == PeerStatus.Sending) {
          // Calculate Difference
          double difference =
              user.node.antipodalDirection - event.peer.direction;

          // Remove Peer Node
          graph.remove(event.peer);

          // Create Edge
          graph.setToBy(event.peer, user.node, difference);
        }
        break;

      // Peer Left Lobby
      case GraphUpdate.EXIT:
        // Remove Edge and Object
        graph.remove(event.peer);
        break;
    }

    // Update Closest Neighbor
    PathFinder finder = new PathFinder(graph, user.node);

    // Set Suspend state with lastState
    yield Searching(closest: finder.closestNeighbor);
  }

// ***********************
// ** SendOffer Event ***
// ***********************
  Stream<WebState> _mapSendOfferToState(SendOffer event) async* {
    // Update Node
    user.node.status = PeerStatus.Busy;
    add(UpdateNode());

    // Set Match
    // rtcSession.matchId = circle.closestId();

    // Create Offer and Emit
    // rtcSession.invite(this.circle.closestId(), data.outgoing.first.toString());

    // Device Pending State
    // yield Pending(match: circle.closestProfile());
  }

// ***********************
// ** Authorize Event ***
// ***********************
  Stream<WebState> _mapAuthorizeToState(Authorize event) async* {
    // Update Node
    user.node.status = PeerStatus.Busy;
    add(UpdateNode());

    // Set Peer
    //rtcSession.matchId = circle.closestId();

    // Create Offer and Emit
    //rtcSession.invite(this.circle.closestId(), data.outgoing.first.toString());

    // Device Pending State
    //yield Pending(match: circle.closestProfile());
  }

// *********************** //
// ** HandleOffer Event ** //
// *********************** //
  Stream<WebState> _mapOfferedToState(HandleOffer event) async* {
    // User ACCEPTED Transfer Request
    if (event.decision) {
      // Set Offered and Peer
      rtcSession.matchId = event.match.id;

      // Add Incoming File Info
      data.add(QueueFile(
        receiving: true,
      ));

      // Create Answer
      rtcSession.handleOffer(event.offer);
      yield Transferring();
    }
    // User DECLINED Transfer Request
    else {
      // Reset Peer
      rtcSession.matchId = null;

      // Send Decision
      socket.emit("DECLINE", event.match.id);
      add(Complete(resetSession: true));
    }
  }

// *************************
// ** HandleAnswer Event ***
// *************************
  Stream<WebState> _mapAcceptedToState(HandleAnswer event) async* {
    // Handle Answer
    rtcSession.handleAnswer(event.answer);

    // Begin Transfer
    yield Transferring();
  }

// **************************
// ** HandleDecline Event ***
// **************************
  Stream<WebState> _mapDeclinedToState(HandleDecline event) async* {
    // Reset Peer
    rtcSession.matchId = null;

    // Emit Decision to Server
    yield Failed();
  }

// *********************
// ** BeginTransfer Event ***
// *********************
  Stream<WebState> _mapBeginTransferToState(BeginTransfer event) async* {
    // Begin Transfer
    data.add(SendChunks());

    // Emit Decision to Server
    yield Transferring();
  }

// *********************
// ** HandleComplete Event ***
// *********************
  Stream<WebState> _mapHandleCompleteToState(HandleComplete event) async* {
    // Emit Decision to Server
    yield Completed("SENDER");
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
      rtcSession.close();
      rtcSession.matchId = null;
    }

    // Reset Node
    user.node.status = PeerStatus.Ready;
    add(UpdateNode());

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
      rtcSession.close();
      rtcSession.matchId = null;
    }

    // Set Delay
    await new Future.delayed(Duration(seconds: 1));

    // Yield Ready
    yield Failed();
  }
}
