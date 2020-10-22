import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

part 'web_event.dart';
part 'web_state.dart';

// ***********************
// ** Sonar Bloc Class ***
// ***********************
class WebBloc extends Bloc<WebEvent, WebState> {
  // Data Providers
  StreamSubscription dataSub;
  StreamSubscription directionSub;
  SocketSubscriber socketSub;

  // Required Blocs
  final DataBloc data;
  final DeviceBloc device;
  final UserBloc user;

  // Initial State
  WebState get initialState => SocketInitial();

  // Constructer
  WebBloc(this.data, this.device, this.user) : super(null) {
    // ** Listen to CallBack on SocketSubscriber ** //
    socketSub = new SocketSubscriber((Incoming event, dynamic data) {
      add(SocketEmission(event, data));
    });

    // ** Data BLoC Subscription ** //
    dataSub = data.listen((DataState state) {
      if (state is PeerReceiveComplete) {
        add(End(EndType.Complete, file: state.file));
      }
    });

    // ** Device BLoC Subscription ** //
    directionSub = device.directionCubit.listen((newDir) {
      // Device is Searching
      if (this.state is Searching) {
        // Update Direction
        user.node.direction = newDir;

        // Update WebBloc State
        add(PeerUpdated(Status.Searching));
      }
      // Send with 500ms delay
      else if (this.state is Available) {
        // Update Direction
        user.node.direction = newDir;

        // Update WebBloc State
        add(PeerUpdated(Status.Available));
      }
    });
  }

  // On Bloc Close
  void dispose() {
    directionSub.cancel();
    dataSub.cancel();
  }

// *********************************
// ** Map Events to State Method ***
// *********************************
  @override
  Stream<WebState> mapEventToState(
    WebEvent event,
  ) async* {
    if (event is SocketStarted) {
      yield* _mapSocketStartedToState(event);
    } else if (event is SocketEmission) {
      yield* _mapSocketEmissionToState(event);
    } else if (event is SocketEmit) {
      yield* _mapSocketEmitToState(event);
    } else if (event is PeerUpdated) {
      yield* _mapPeerUpdatedToState(event);
    } else if (event is PeerInvited) {
      yield* _mapPeerInvitedToState(event);
    } else if (event is PeerAuthorized) {
      yield* _mapPeerAuthorizedToState(event);
    } else if (event is PeerDeclined) {
      yield* _mapPeerDeclinedToState(event);
    } else if (event is End) {
      yield* _mapEndToState(event);
    }
  }

// **************************
// ** SocketStarted Event ***
// **************************
  Stream<WebState> _mapSocketStartedToState(SocketStarted event) async* {
    // Check if Peer Located
    if (user.node.status == Status.Standby) {
      // Get Headers
      var headers = {
        'deviceId': user.node.id,
        'lobby': user.node.olc, // RoomId from Location
      };

      // Set on Socket
      socket.io.options['extraHeaders'] = headers;

      // Connect to Socket
      socket.connect();
    }
    // Incorrect status
    else {
      log.e("User node not located");
    }
  }

// ***************************
// ** SocketEmission Event ***
// ***************************
  Stream<WebState> _mapSocketEmissionToState(SocketEmission message) async* {
    switch (message.event) {
      // ** ======================================= ** //
      case Incoming.Connected:
        // Get/Set Socket Id
        user.node.id = message.data;

        // Change Status
        add(PeerUpdated(Status.Available));
        break;

      // ** ======================================= ** //
      case Incoming.Disconnected:
        // Todo: Handle Disconnection
        break;

      // ** ======================================= ** //
      case Incoming.Updated:
        // Get Peer Data
        Peer from = Peer.fromMap(message.data);

        // Check User Status
        if (user.node.isNotBusy()) {
          // Update Graph
          user.node.updateGraph(from);
          add(PeerUpdated(user.node.status));
          yield SocketLoadInProgress();
        }
        break;

      // ** ======================================= ** //
      case Incoming.Exited:
        // Get Peer Data
        Peer from = Peer.fromMap(message.data);

        // Check if Node is Busy
        if (user.node.isNotBusy()) {
          // Update Graph
          user.node.exitGraph(from);
          add(PeerUpdated(user.node.status));
          yield SocketLoadInProgress();
        }
        break;

      // ** ======================================= ** //
      case Incoming.Offered:
        // Get Objects
        Peer from = Peer.fromMap(message.data[0]);
        dynamic offer = message.data[1];
        Metadata meta = Metadata.fromMap(offer['metadata']);

        // Change/Send Status Update
        add(SocketEmit(Outgoing.Update, user.node, status: Status.Offered));

        // Yield State
        yield Requested(from, offer, meta);
        break;

      // ** ======================================= ** //
      case Incoming.Answered:
        // Get Objects
        Peer from = Peer.fromMap(message.data[0]);
        dynamic answer = message.data[1];

        // Handle Answer from Answered Peer
        await user.node.handleAnswer(from, answer);

        // Change/Send Status Update
        add(SocketEmit(Outgoing.Update, user.node,
            status: Status.Transferring));

        // Begin Transfer
        data.add(PeerSentChunk(from));
        yield Transferring(from);
        break;

      // ** ======================================= ** //
      case Incoming.Declined:
        // Get Peer Data
        Peer from = Peer.fromMap(message.data);

        // Reset Connection
        user.node.reset(match: from);

        // Change/Send Status Update
        add(SocketEmit(Outgoing.Update, user.node, status: Status.Searching));
        yield SocketLoadInProgress();
        break;

      // ** ======================================= ** //
      case Incoming.Candidate:
        // Get Objects
        Peer from = Peer.fromMap(message.data[0]);
        dynamic candidate = message.data[1];

        // Add Ice Candidate
        user.node.handleCandidate(from, candidate);
        break;

      // ** ======================================= ** //
      case Incoming.Error:
        // Log Error
        log.e("ERROR: " + message.data.toString());
        add(End(EndType.Fail));
        yield SocketLoadInProgress();
        break;
    }
  }

// ***********************
// ** SocketEmit Event ***
// ***********************
  Stream<WebState> _mapSocketEmitToState(SocketEmit message) async* {
    // Get Subject
    String subject = enumAsString(message.event).toUpperCase();
    dynamic data;

    // Send Message by Outgoing event
    switch (message.event) {
      // ** ======================================= ** //
      case Outgoing.Update:
        // Update Status
        message.from.status = message.status;

        // Set Data
        data = message.from.toMap();
        break;

      // ** ======================================= ** //
      case Outgoing.Offer:
        // Get Fields
        var s = message.session;

        // Create Data Map
        var from = message.from.toMap();
        var offer = {
          'description': {'sdp': s.sdp, 'type': s.type},
          'session_id': message.sessionId,
          'metadata': message.metadata.toMap()
        };

        // Set Data
        data = [from, message.to, offer];
        break;

      // ** ======================================= ** //
      case Outgoing.Answer:
        // Get Fields
        var s = message.session;

        // Create Data Map
        var from = message.from.toMap();
        var answer = {
          'description': {'sdp': s.sdp, 'type': s.type},
          'session_id': message.sessionId,
        };

        // Set Data
        data = [from, message.to, answer];
        break;

      // ** ======================================= ** //
      case Outgoing.Decline:
        // Set Data
        data = [message.from.toMap(), message.to];
        break;

      // ** ======================================= ** //
      case Outgoing.Candidate:
        // Get Fields
        var c = message.candidate;

        // Create Data Map
        var from = message.from.toMap();
        var candidate = {
          'candidate': {
            'sdpMLineIndex': c.sdpMlineIndex,
            'sdpMid': c.sdpMid,
            'candidate': c.candidate,
          },
          'session_id': message.sessionId,
        };

        // Set Data
        data = [from, message.to, candidate];
        break;

      // ** ======================================= ** //
      case Outgoing.Exited:
        // Set Data
        data = message.from.toMap();
        break;
    }

    // ** Send to Socket Server ** //
    socket.emit(subject, data);
  }

// ************************
// ** PeerUpdated Event ***
// ************************
  Stream<WebState> _mapPeerUpdatedToState(PeerUpdated event) async* {
    // Action by Status
    switch (event.newStatus) {
      case Status.Available:
        // Change/Send Status Update
        add(SocketEmit(Outgoing.Update, user.node, status: Status.Available));
        yield Available(user.node);
        break;
      case Status.Searching:
        // Change/Send Status Update
        add(SocketEmit(Outgoing.Update, user.node, status: Status.Searching));
        yield Searching(user.node);
        break;
      default:
        log.i("User-Node = " + user.node.status.toString());
        break;
    }
  }

// ***********************
// ** PeerInvited Event **
// ***********************
  Stream<WebState> _mapPeerInvitedToState(PeerInvited event) async* {
    // Send Offer
    await user.node.offer(event.to, data.currentFile.metadata);

    // Change/Send Status Update
    add(SocketEmit(Outgoing.Update, user.node, status: Status.Pending));
    yield Pending(match: event.to);
  }

// ***************************
// ** PeerAuthorized Event ***
// ***************************
  Stream<WebState> _mapPeerAuthorizedToState(PeerAuthorized event) async* {
    // Handle Offer from Requested Peer
    await user.node.handleOffer(event.match, event.offer);

    // Add File to Queue
    data.traffic.addIncoming(event.metadata);

    // Change/Send Status Update
    add(SocketEmit(Outgoing.Update, user.node, status: Status.Transferring));

    // Yield State
    yield Transferring(event.match);
  }

// *************************
// ** PeerDeclined Event ***
// *************************
  Stream<WebState> _mapPeerDeclinedToState(PeerDeclined event) async* {
    // Send Decline
    user.node.decline(event.match);

    // Change/Send Status Update
    add(SocketEmit(Outgoing.Update, user.node, status: Status.Available));

    // Yield State
    yield Available(user.node);
  }

// *******************************************
// ** End Event: Cancel/Complete/Exit/Fail ***
// *******************************************
  Stream<WebState> _mapEndToState(End event) async* {
    // TODO: Check Reset Connection
    //socket.emit("RESET");

    // TODO: Check Reset RTC Session
    //session.close();

    // Action By Type
    switch (event.type) {
      // ** Cancel in Transfer **
      case EndType.Cancel:
        log.i("Cancelled");
        break;

      // ** Transfer is Finished **
      case EndType.Complete:
        // Reset Node
        add(PeerUpdated(Status.Available));

        // Yield Ready
        yield Completed(user.node, file: event.file);
        break;

      // ** Exit Graph **
      case EndType.Exit:
        log.i("Exited");
        break;

      // ** Internal Fail **
      case EndType.Fail:
        // Yield Ready
        yield Failed();
        break;
    }
  }
}
