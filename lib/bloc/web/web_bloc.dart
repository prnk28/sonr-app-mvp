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
    socketSub = new SocketSubscriber(user, this);

    // ** Device BLoC Subscription ** //
    directionSub = device.directionCubit.listen((newDir) {
      // Check Diff Direction
      if (newDir != user.node.direction && this.state is! Loading) {
        // Device is Searching
        if (this.state is Searching) {
          // Update Direction
          user.node.direction = newDir;

          // Update WebBloc State
          add(Update(Status.Searching));
        }
        // Send with 500ms delay
        else if (this.state is Available) {
          // Update Direction
          user.node.direction = newDir;

          // Update WebBloc State
          add(Update(Status.Available));
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
    } else if (event is Invite) {
      yield* _mapInviteToState(event);
    } else if (event is Authorize) {
      yield* _mapAuthorizeToState(event);
    } else if (event is Load) {
      yield* _mapLoadToState(event);
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

// *****************
// ** Load Event ***
// *****************
  Stream<WebState> _mapLoadToState(Load load) async* {
    // Check General Message
    if (load.event == 'UPDATED') {
      // Update Graph
      user.node.updateGraph(load.from);
      add(Update(user.node.status));
      yield Loading();
    } else if (load.event == 'EXITED') {
      // Update Graph
      user.node.exitGraph(load.from);
      add(Update(user.node.status));
      yield Loading();
    } else if (load.event == 'DECLINED') {
      // Reset Connection
      user.node.reset(match: load.from);
      add(Update(user.node.status));
      yield Loading();
    } else if (load.event == 'COMPLETED') {
      log.i("COMPLETED: " + data.toString());
      data.add(WriteFile());
      add(End(EndType.Complete));
      yield Loading();
    } else if (load.event == 'ERROR') {
      log.e("ERROR: " + load.error.toString());
      yield Loading();
    }
    yield Loading();
  }

// ******************
// ** Invite Event **
// ******************
  Stream<WebState> _mapInviteToState(Invite event) async* {
    // Send Offer
    await user.node.offer(event.to, data.currentFile.metadata);

    // Change Status
    add(Update(Status.Pending, to: event.to));
  }

// **********************
// ** Authorize Event ***
// **********************
  Stream<WebState> _mapAuthorizeToState(Authorize event) async* {
    if (event.decision) {
      // Handle Offer from Requested Peer
      await user.node.handleOffer(event.to, event.offer);

      // Add File to Queue
      data.traffic.addIncoming(event.offer.metadata);

      // Change State
      user.node.status = Status.Transferring;
      add(Update(Status.Transferring, from: event.offer.from));
    } else {
      user.node.decline(event.offer.from);
      user.node.status = Status.Available;
      add(Update(Status.Available));
    }
  }

// *******************
// ** Update Event ***
// *******************
  Stream<WebState> _mapUpdateToState(Update event) async* {
    // Action by Status
    switch (event.newStatus) {
      case Status.Offline:
        // Update User Peer Node
        user.node.update(event.newStatus);
        yield Disconnected();
        break;
      case Status.Available:
        // Update User Peer Node
        user.node.update(event.newStatus);
        yield Available(user.node);
        break;
      case Status.Searching:
        // Update User Peer Node
        user.node.update(event.newStatus);
        yield Searching(user.node);
        break;
      case Status.Pending:
        // Update User Peer Node
        user.node.update(event.newStatus);
        yield Pending(match: event.to);
        break;
      case Status.Offered:
        // Update User Peer Node
        user.node.update(event.newStatus);
        yield Requested(
            offer: event.offer, metadata: event.metadata, from: event.from);
        break;
      case Status.Answered:
        // Handle Answer from Answered Peer
        await user.node.handleAnswer(event.from, event.answer);

        // Begin Transfer
        data.add(Transfer(event.from));

        // Change State
        user.node.status = Status.Transferring;
        yield Transferring(event.from);
        break;
      case Status.Transferring:
        // Update User Peer Node
        user.node.update(event.newStatus);
        yield Transferring(event.from);
        break;
      default:
        yield Loading();
        break;
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
