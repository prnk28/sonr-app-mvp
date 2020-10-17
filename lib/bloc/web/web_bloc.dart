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

  // Required Blocs
  final DataBloc data;
  final DeviceBloc device;
  final UserBloc user;
  Peer _node;

  // Constructer
  WebBloc(this.data, this.device, this.user) : super(null) {
    // Initialize Objects
    _node = user.node;

    // ************************************* //
    // ** SocketClient Event Subscription ** //
    // ************************************* //
    // -- USER CONNECTED TO SOCKET SERVER --
    socket.on('CONNECTED', (data) {
      log.i("CONNECTED: " + data.toString());
      _node.handleEvent(IncomingEvent.CONNECTED, data);
    });

    // -- UPDATE TO A NODE IN LOBBY --
    socket.on('NODE_UPDATE', (data) {
      log.i("NODE_UPDATE: " + data.toString());
      _node.handleEvent(IncomingEvent.NODE_UPDATE, data);
    });

    // -- NODE EXITED LOBBY --
    socket.on('NODE_EXIT', (data) {
      log.i("NODE_EXIT: " + data.toString());
      _node.handleEvent(IncomingEvent.NODE_EXIT, data);
    });

    // -- OFFER REQUEST --
    socket.on('PEER_OFFERED', (data) {
      log.i("PEER_OFFERED: " + data.toString());
      _node.handleEvent(IncomingEvent.PEER_OFFERED, data);
    });

    // -- MATCH ACCEPTED REQUEST --
    socket.on('PEER_ANSWERED', (data) {
      log.i("PEER_ANSWERED: " + data.toString());
      _node.handleEvent(IncomingEvent.PEER_ANSWERED, data);
    });

    // -- MATCH DECLINED REQUEST --
    socket.on('PEER_DECLINED', (data) {
      log.i("PEER_DECLINED: " + data.toString());
      _node.handleEvent(IncomingEvent.PEER_DECLINED, data);
    });

    // -- MATCH ICE CANDIDATES --
    socket.on('PEER_CANDIDATE', (data) {
      log.i("PEER_CANDIDATE: " + data.toString());
      _node.handleEvent(IncomingEvent.PEER_CANDIDATE, data);
    });

    // -- MATCH RECEIVED FILE --
    socket.on('COMPLETED', (data) {
      log.i("COMPLETED: " + data.toString());
      _node.handleEvent(IncomingEvent.COMPLETED, data);
    });

    // -- ERROR OCCURRED (Cancelled, Internal) --
    socket.on('ERROR', (error) {
      _node.handleEvent(IncomingEvent.ERROR, data);
    });

    // ****************************** //
    // ** Device BLoC Subscription ** //
    // ****************************** //
    directionSubscription = device.directionCubit.listen((direction) {
      // Check Diff Direction
      if (direction != _node.direction && this.state is! Loading) {
        // Device is Searching
        if (this.state is Searching) {
          add(Search());
        }
        // Send with 500ms delay
        else if (this.state is Available) {
          add(Active());
        }
        _node.direction = direction;
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
    } else if (event is Authorize) {
      //yield* _mapAuthorizeToState(event);
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
    if (_node != null) {
      // Emit Peer Node
      _node.send(OutgoingEvent.CONNECT);

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
    _node.status = Status.Active;

    // Add Delay
    // await Future.delayed(const Duration(milliseconds: 500));

    // Emit to Server
    _node.send(OutgoingEvent.UPDATE);

    // Yield Searching with Closest Neighbor
    yield Available();
  }

// *********************
// ** Search Event ***
// *********************
  Stream<WebState> _mapSearchToState(Search event) async* {
    // Update Status
    _node.status = Status.Searching;

    // Add Delay
    // Future.delayed(const Duration(milliseconds: 250));

    // Emit to Server
    _node.send(OutgoingEvent.UPDATE);

    // Yield Searching with Closest Neighbor
    yield Searching(activePeers: _node.getZonedPeers());
  }

// *********************
// ** Complete Event ***
// *********************
  Stream<WebState> _mapCompleteToState(Complete event) async* {
    // Check Reset Connection
    if (event.resetConnection) {
      //socket.emit("CLOSE", user.node.toMap());
    }

    // Check Reset RTC Session
    if (event.resetSession) {
      //session.close();
    }

    // Reset Node
    _node.status = Status.Active;

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
      //socket.emit("RESET");
    }

    // Check Reset RTC Session
    if (event.resetSession) {
      //session.close();
    }

    // Set Delay
    await new Future.delayed(Duration(seconds: 1));

    // Yield Ready
    yield Failed();
  }
}
