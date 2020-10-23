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
  // Required Blocs
  final DataBloc data;
  final DeviceBloc device;
  final UserBloc user;

  // Initial State
  SignalState get initialState => SocketInitial();

  // Constructer
  SignalBloc(this.data, this.device, this.user) : super(null) {
    // ** Socket Event Subscription ** //
    // ** ======================================= ** //
    socket.on('connect', (_) {
      // Get/Set Socket Id
      user.node.id = socket.id;
      // Change Status
      user.add(NodeAvailable());
    });

    // ** ======================================= ** //
    socket.on('UPDATED', (data) {
      // Update Graph
      user.add(GraphUpdated(Node.fromMap(data)));
    });

    // ** ======================================= ** //
    socket.on('EXITED', (data) {
      // Get Peer Data
      Node from = Node.fromMap(data);

      // Exit Graph Graph
      user.add(GraphExited(from));
    });

    // ** ======================================= ** //
    socket.on('OFFERED', (data) {
      // Get Objects
      Node from = Node.fromMap(data[0]);
      dynamic offer = data[1];
      Metadata meta = Metadata.fromMap(offer['metadata']);

      // Handle Offer
      user.add(NodeRequested(from, offer, meta));
    });

    // ** ======================================= ** //
    socket.on('ANSWERED', (data) {
      // Get Objects
      Node from = Node.fromMap(data[0]);
      dynamic answer = data[1];

      // Handle Answer from Peer
      user.add(NodeAuthorized(from, answer));
    });

    // ** ======================================= ** //
    socket.on('DECLINED', (data) {
      // Handle Rejection
      user.add(NodeRejected());
    });

    // ** ======================================= ** //
    socket.on('CANDIDATE', (data) {
      // Get Objects
      Node from = Node.fromMap(data[0]);
      dynamic candidate = data[1];

      // Add Ice Candidate
      user.add(NodeCandidate(from, candidate));
    });

    // ** ======================================= ** //
    socket.on('ERROR', (data) {
      // Log Error
      log.e("ERROR: " + data.toString());
    });
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
      yield SocketSuccess();
    }
    // Incorrect status
    else {
      log.e("User node not located");
      yield SocketFailure();
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
        break;

      // ** Exit Graph **
      case EndType.Exit:
        log.i("Exited");
        break;

      // ** Internal Fail **
      case EndType.Fail:
        break;
    }
  }
}
