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
  Circle circle;
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
    circle = new Circle(this);

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
        add(RequestSearch(userNode: user.node));
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
    // -- Connected --
    socket.on('connect', (_) async {
      log.v("Connected to Socket");
      user.node.id = socket.id;
    });

    // -- USER CONNECTED TO SOCKET SERVER --
    socket.on('CONNECTED', (data) {
      //bloc.add(Reload(newDirection: bloc.device.
    });

    // -- NODE APPEARED IN LOBBY --
    socket.on('NODE_ENTER', (data) {
      //bloc.add(Reload(newDirection: bloc.device.
    });

    // -- UPDATE TO A NODE IN LOBBY --
    socket.on('NODE_UPDATE', (data) {
      //bloc.add(Reload(newDirection: bloc.device.
    });

    // -- NODE EXITED LOBBY --
    socket.on('NODE_EXIT', (data) {
      //bloc.add(Reload(newDirection: bloc.device.
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
    } else if (event is RequestSearch) {
      yield* _mapRequestSearchToState(event);
    } else if (event is UpdateGraph) {
      yield* _mapUpdateGraphToState(event);
    } else if (event is SendOffer) {
      yield* _mapSendOfferToState(event);
    } else if (event is HandlePeerUpdate) {
      yield* _mapHandlePeerUpdateToState(event);
    } else if (event is HandleOffer) {
      yield* _mapOfferedToState(event);
    } else if (event is HandleAnswer) {
      yield* _mapAcceptedToState(event);
    } else if (event is HandleCandidate) {
      yield* _mapHandleCandidateToState(event);
    } else if (event is HandleLeave) {
      yield* _mapHandleLeaveToState(event);
    } else if (event is HandleClose) {
      yield* _mapHandleCloseToState(event);
    } else if (event is HandleDecline) {
      yield* _mapDeclinedToState(event);
    } else if (event is BeginTransfer) {
      yield* _mapBeginTransferToState(event);
    } else if (event is HandleComplete) {
      yield* _mapHandleCompleteToState(event);
    } else if (event is Complete) {
      yield* _mapResetToState(event);
    }
  }

// ********************
// ** Connect Event ***
// ********************
  Stream<WebState> _mapConnectToState(Connect event) async* {
    // Emit to Socket.io from User Peer Node
    socket.emit("CONNECT", [user.node.locationToMap(), user.profile.toMap()]);

    // Fake Select File in Queue
    File transferToSend =
        await getAssetFileByPath("assets/images/fat_test.jpg");
    data.add(QueueFile(receiving: false, file: transferToSend));

    // Device Pending State
    yield Connected();
  }

// **************************
// ** RequestSearch Event ***
// **************************
  Stream<WebState> _mapRequestSearchToState(RequestSearch event) async* {
    // Check Init Status
    Map peerMap = user.node.toMap();

    // Set Delay
    await new Future.delayed(Duration(milliseconds: 500));

    // Send to Server
    socket.emit("REQUEST_SEARCH", peerMap);

    // Set Suspend state with lastState
    yield Searching();
  }

  // **************************
// ** UpdateGraph Event ***
// **************************
  Stream<WebState> _mapUpdateGraphToState(UpdateGraph event) async* {
    // Check Init Status
    Map peerMap = user.node.toMap();

    // Set Delay
    await new Future.delayed(Duration(milliseconds: 500));

    // Send to Server
    socket.emit("REQUEST_SEARCH", peerMap);

    // Set Suspend state with lastState
    yield Searching();
  }

// ***********************
// ** SendOffer Event ***
// ***********************
  Stream<WebState> _mapSendOfferToState(SendOffer event) async* {
    // Set Peer
    rtcSession.matchId = circle.closestId();

    // Create Offer and Emit
    rtcSession.invite(this.circle.closestId(), data.outgoing.first.toString());

    // Device Pending State
    yield Pending(match: circle.closestProfile());
  }

// *****************************
// ** HandlePeerUpdate Event ***
// *****************************
  Stream<WebState> _mapHandlePeerUpdateToState(HandlePeerUpdate event) async* {
    // Set Peer
    rtcSession.matchId = circle.closestId();

    // Create Offer and Emit
    rtcSession.invite(this.circle.closestId(), data.outgoing.first.toString());

    // Device Pending State
    yield Pending(match: circle.closestProfile());
  }

// *********************** //
// ** HandleOffer Event ** //
// *********************** //
  Stream<WebState> _mapOfferedToState(HandleOffer event) async* {
    // User ACCEPTED Transfer Request
    if (event.decision) {
      // Set Offered and Peer
      rtcSession.matchId = event.profile["id"];

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
      socket.emit("DECLINE", event.matchId);
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

// *************************
// ** HandleCandidate Event ***
// *************************
  Stream<WebState> _mapHandleCandidateToState(HandleCandidate event) async* {
    // Handle Answer
    //rtcSession.handleAnswer(event.answer);

    // Begin Transfer
    yield Transferring();
  }

// *************************
// ** HandleLeave Event ***
// *************************
  Stream<WebState> _mapHandleLeaveToState(HandleLeave event) async* {
    // Handle Answer
    //rtcSession.handleAnswer(event.answer);

    // Begin Transfer
    yield Transferring();
  }

// *************************
// ** HandleClose Event ***
// *************************
  Stream<WebState> _mapHandleCloseToState(HandleClose event) async* {
    // Handle Answer
    //rtcSession.handleAnswer(event.answer);

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
    yield Failed(profile: event.profile, matchId: event.matchId);
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
// ** Reset Event ***
// *********************
  Stream<WebState> _mapResetToState(Complete event) async* {
    // Check Reset Connection
    if (event.resetConnection) {
      socket.emit("RESET");
    }

    // Check Reset RTC Session
    if (event.resetSession) {
      rtcSession.close();
      rtcSession.matchId = null;
    }

    // Reset Graph
    circle.reset();

    // Set Delay
    await new Future.delayed(Duration(seconds: 1));

    // Yield Ready
    yield Connected();
  }
}
