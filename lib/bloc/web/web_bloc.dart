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
  StreamSubscription directionSub;
  SocketSubscriber socketSub;

  // Required Blocs
  final DataBloc data;
  final DeviceBloc device;
  final UserBloc user;

  // Initial State
  WebState get initialState => Disconnected();

  // Constructer
  WebBloc(this.data, this.device, this.user) : super(null) {
    // ** Initialize ** //
    socketSub = new SocketSubscriber(user.node, this);

    // ** Device BLoC Subscription ** //
    directionSub = device.directionCubit.listen((direction) {
      // Check Diff Direction
      if (direction != user.node.direction && this.state is! Loading) {
        // Device is Searching
        if (this.state is Searching) {
          // Update WebBloc State
          add(Update(Status.Available, newDirection: direction));
        }
        // Send with 500ms delay
        else if (this.state is Available) {
          // Update WebBloc State
          add(Update(Status.Available, newDirection: direction));
        }
      }
    });
  }

  // On Bloc Close
  void dispose() {
    directionSub.cancel();
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
    if (user.node.connect()) {
      // Wait for Server
      yield Loading();
    }
  }

// *******************
// ** Update Event ***
// *******************
  Stream<WebState> _mapUpdateToState(Update event) async* {
    // Update User Peer Node
    user.node.update(Status.Available, newDirection: event.newDirection);

    // Action by Status
    switch (user.node.status) {
      case Status.Offline:
        yield Disconnected();
        break;
      case Status.Available:
        yield Available(user.node);
        break;
      case Status.Searching:
        yield Searching(user.node);
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
        yield Loading();
        break;
    }
  }

// **********************
// ** Authorize Event ***
// **********************
  Stream<WebState> _mapAuthorizeToState(Authorize event) async* {
    // User Agreed
    if (event.decision) {
      await user.node.answer(event.match, event.peerConnection);
    }
    // User Declined
    else {
      user.node.decline(event.match);
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
        user.node.status = Status.Available;

        // Set Delay
        await new Future.delayed(Duration(seconds: 1));

        // Yield Ready
        yield Completed(user.node);
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
