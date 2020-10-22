import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

part 'signal_event.dart';
part 'signal_state.dart';

// ***********************
// ** Sonar Bloc Class ***
// ***********************
class SignalBloc extends Bloc<SignalEvent, SignalState> {
  // Data Providers
  StreamSubscription dataSub;
  StreamSubscription directionSub;
  SocketSubscriber socketSub;

  // Required Blocs
  final DataBloc data;
  final DeviceBloc device;
  final UserBloc user;

  // Initial State
  SignalState get initialState => SocketInitial();

  // Constructer
  SignalBloc(this.data, this.device, this.user) : super(null) {
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
        user.add(NodeSearch());
      }
      // Send with 500ms delay
      else if (this.state is Available) {
        // Update Direction
        user.node.direction = newDir;

        // Update WebBloc State
        user.add(NodeSearch());
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
  Stream<SignalState> mapEventToState(
    SignalEvent event,
  ) async* {
    if (event is SocketStarted) {
      yield* _mapSocketStartedToState(event);
    } else if (event is SocketEmission) {
      yield* _mapSocketEmissionToState(event);
    } else if (event is End) {
      yield* _mapEndToState(event);
    }
  }

// **************************
// ** SocketStarted Event ***
// **************************
  Stream<SignalState> _mapSocketStartedToState(SocketStarted event) async* {
    // Check if Peer Located
    if (user.node.olc != null) {
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
  Stream<SignalState> _mapSocketEmissionToState(SocketEmission message) async* {
    switch (message.event) {
      // ** ======================================= ** //
      case Incoming.Connected:
        // Get/Set Socket Id
        user.node.id = message.data;

        // Change Status
        user.add(NodeAvailable());
        break;

      // ** ======================================= ** //
      case Incoming.Disconnected:
        // Todo: Handle Disconnection
        break;

      // ** ======================================= ** //
      case Incoming.Updated:
        // Get Peer Data
        Peer from = Peer.fromMap(message.data);

        // Update Graph
        user.add(GraphUpdated(from));
        yield SocketLoadInProgress();
        break;

      // ** ======================================= ** //
      case Incoming.Exited:
        // Get Peer Data
        Peer from = Peer.fromMap(message.data);

        // Exit Graph Graph
        user.add(GraphExited(from));
        yield SocketLoadInProgress();
        break;

      // ** ======================================= ** //
      case Incoming.Offered:
        // Get Objects
        Peer from = Peer.fromMap(message.data[0]);
        dynamic offer = message.data[1];
        Metadata meta = Metadata.fromMap(offer['metadata']);

        // Handle Offer
        user.add(NodeRequested(from, offer, meta));

        // Yield State
        yield SocketLoadInProgress();
        break;

      // ** ======================================= ** //
      case Incoming.Answered:
        // Get Objects
        Peer from = Peer.fromMap(message.data[0]);
        dynamic answer = message.data[1];

        // Handle Answer from Peer
        user.add(NodeAuthorized(from, answer));

        // Begin Transfer
        data.add(PeerSentChunk(from));
        yield Transferring(from);
        break;

      // ** ======================================= ** //
      case Incoming.Declined:
        // Handle Rejection
        user.add(NodeRejected());
        yield SocketLoadInProgress();
        break;

      // ** ======================================= ** //
      case Incoming.Candidate:
        // Get Objects
        Peer from = Peer.fromMap(message.data[0]);
        dynamic candidate = message.data[1];

        // Add Ice Candidate
        user.add(NodeCandidate(from, candidate));
        break;

      // ** ======================================= ** //
      case Incoming.Error:
        // Log Error
        log.e("ERROR: " + message.data.toString());
        yield SocketLoadInProgress();
        break;
    }
  }

// *******************************************
// ** End Event: Cancel/Complete/Exit/Fail ***
// *******************************************
  Stream<SignalState> _mapEndToState(End event) async* {
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
        user.add(NodeAvailable());

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
