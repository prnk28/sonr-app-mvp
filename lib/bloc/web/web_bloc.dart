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
  StreamSubscription directionSubscription;

  // Required Blocs
  final DataBloc data;
  final DeviceBloc device;
  final UserBloc user;
  Peer _node;

  // Initial State
  WebState get initialState => Disconnected();

  // On Bloc Close
  void dispose() {
    directionSubscription.cancel();
  }

  // Constructer
  WebBloc(this.data, this.device, this.user) : super(null) {
    // Initialize Objects
    _node = user.node;

    // ** SocketClient Event Subscription ** //
    // -- USER CONNECTED TO SERVER --
    socket.on('READY', (data) {
      // Log Event
      log.i("READY");

      // Change Status
      add(Update(Status.Available));
    });

    // -- UPDATE TO A NODE IN LOBBY --
    socket.on('ENTERED', (data) {
      log.i("Neighbor Entered Room");

      // Get Peer
      Peer neighbor = new Peer(map: data);

      // Update Graph
      _node.updateGraph(neighbor);
    });

    // -- UPDATE TO A NODE IN LOBBY --
    socket.on('UPDATED', (data) {
      // Check if Peer is Self
      if (data['id'] != _node.id) {
        // Get Peer
        Peer neighbor = new Peer(map: data);

        // Update Graph
        _node.updateGraph(neighbor);
      }
    });

    // -- NODE EXITED LOBBY --
    socket.on('EXITED', (data) {
      // Log Event
      log.i("EXITED: " + data.toString());

      // Get Peer
      Peer neighbor = new Peer(map: data['from']);

      // Update Graph
      _node.exitGraph(neighbor);
    });

    // -- OFFER REQUEST --
    socket.on('OFFERED', (data) {
      // Log Event
      log.i("OFFERED: " + data.toString());

      // Set Status
      _node.status = Status.Requested;

      // Handle Offer
      _node.handleOffer(data);
    });

    // -- MATCH ACCEPTED REQUEST --
    socket.on('ANSWERED', (data) {
      // Log Event
      log.i("ANSWERED: " + data.toString());

      // Set Status
      _node.status = Status.Transferring;

      // Handle Answer
      _node.handleAnswer(data);
    });

    // -- MATCH DECLINED REQUEST --
    socket.on('DECLINED', (data) {
      // Log Event
      log.i("DECLINED: " + data.toString());
    });

    // -- MATCH ICE CANDIDATES --
    socket.on('CANDIDATE', (data) {
      // Log Event
      log.i("CANDIDATE: " + data.toString());

      // Handle Candidate
      _node.handleCandidate(data);
    });

    // -- MATCH RECEIVED FILE --
    socket.on('COMPLETED', (data) {
      // Log Event
      log.i("COMPLETED: " + data.toString());
    });

    // -- ERROR OCCURRED (Cancelled, Internal) --
    socket.on('ERROR', (error) {
      // Log Event
      log.e("ERROR: " + data.toString());
    });

    // ** Device BLoC Subscription ** //
    directionSubscription = device.directionCubit.listen((direction) {
      // Check Diff Direction
      if (direction != _node.direction && this.state is! Loading) {
        // Device is Searching
        if (this.state is Searching) {
          add(Update(Status.Searching));
        }
        // Send with 500ms delay
        else if (this.state is Available) {
          add(Update(Status.Available));
        }
        _node.direction = direction;
      }
    });
  }

// *********************************
// ** Map Events to State Method ***
// *********************************
  @override
  Stream<WebState> mapEventToState(
    WebEvent event,
  ) async* {
    if (event is Connect) {
      yield* _mapConnectToState(event);
    } else if (event is Load) {
      yield* _mapLoadToState(event);
    } else if (event is Update) {
      yield* _mapUpdateToState(event);
    } else if (event is Authorize) {
      yield* _mapAuthorizeToState(event);
    } else if (event is End) {
      yield* _mapEndToState(event);
    }
  }

// ********************
// ** Connect Event ***
// ********************
  Stream<WebState> _mapConnectToState(Connect event) async* {
    // Check if Peer Located
    if (_node.status == Status.Standby) {
      // Set Headers
      _node.connect();

      // Device Pending State
      add(Load());
    }
  }

// *****************
// ** Load Event ***
// *****************
  Stream<WebState> _mapLoadToState(Load event) async* {
    yield Loading();
  }

// *******************
// ** Update Event ***
// *******************
  Stream<WebState> _mapUpdateToState(Update event) async* {
    // Update Status
    _node.status = event.newStatus;

    // Emit to Server
    socket.emit("UPDATE", _node.toMap());

    // Action by Status
    switch (_node.status) {
      case Status.Offline:
        yield Disconnected();
        break;
      case Status.Available:
        yield Available(_node);
        break;
      case Status.Searching:
        yield Searching(_node);
        break;
      case Status.Pending:
        yield Pending();
        break;
      case Status.Requested:
        yield Requested();
        break;
      case Status.Transferring:
        yield Transferring();
        break;
      default:
        add(Load());
        break;
    }
  }

// **********************
// ** Authorize Event ***
// **********************
  Stream<WebState> _mapAuthorizeToState(Authorize event) async* {
    // User Agreed
    if (event.decision) {
      await _node.createAnswer(event.match.id, event.peerConnection);
    }
    // User Declined
    else {
      socket.emit("DECLINE");
    }
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
        _node.status = Status.Available;

        // Set Delay
        await new Future.delayed(Duration(seconds: 1));

        // Yield Ready
        yield Completed(_node);
        break;

      // ** Exit Graph **
      case EndType.Exit:
        log.i("Exited");
        break;

      // ** Internal Fail **
      case EndType.Fail:
        // Set Delay
        await new Future.delayed(Duration(seconds: 1));

        // Yield Ready
        yield Failed();
        break;
    }
  }
}
