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
      user.node.role = Role.Zero;

      // Wait for Server
      yield Loading();
    }
  }

// *****************
// ** Load Event ***
// *****************
  Stream<WebState> _mapLoadToState(Load load) async* {
    // Check General Message
    if (load.event != null) {
      switch (load.event.subject) {
        case GeneralMessage.UPDATED:
          // Update Graph
          user.node.updateGraph(load.event.from);
          add(Update(user.node.status));
          break;
        case GeneralMessage.EXITED:
          // Update Graph
          user.node.exitGraph(load.event.from);
          add(Update(user.node.status));
          break;
        case GeneralMessage.DECLINED:
          // Reset Connection
          user.node.reset(match: load.event.from);
          add(Update(user.node.status));
          break;
        case GeneralMessage.COMPLETED:
          user.node.role = Role.Zero;
          log.i("COMPLETED: " + data.toString());
          data.add(WriteFile());
          add(End(EndType.Complete));
          break;
        case GeneralMessage.ERROR:
          user.node.role = Role.Zero;
          log.e("ERROR: " + load.event.error.toString());
          break;
      }
    }
    // Wait for Server
    yield Loading();
  }

// ******************
// ** Invite Event **
// ******************
  Stream<WebState> _mapInviteToState(Invite event) async* {
    await user.node.offer(event.to, event.meta);

    // Change Status
    add(Update(Status.Pending, match: event.to));
  }

// **********************
// ** Authorize Event ***
// **********************
  Stream<WebState> _mapAuthorizeToState(Authorize event) async* {
    if (event.decision) {
      // Handle Offer from Requested Peer
      await user.node.handleOffer(event.offer);

      // Change State
      user.node.status = Status.Transferring;
      add(Update(Status.Transferring, match: event.offer.from));
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
    // Update User Peer Node
    user.node.update(event.newStatus);

    // Action by Status
    switch (user.node.status) {
      case Status.Offline:
        yield Disconnected();
        break;
      case Status.Available:
        user.node.role = Role.Receiver;
        yield Available(user.node);
        break;
      case Status.Searching:
        user.node.role = Role.Sender;
        yield Searching(user.node);
        break;
      case Status.Pending:
        user.node.role = Role.Sender;
        yield Pending(match: event.match);
        break;
      case Status.Offered:
        user.node.role = Role.Receiver;
        // Add File to Queue
        data.add(Queue(QueueType.IncomingFile, metadata: event.offer.metadata));

        yield Requested(offer: event.offer);
        break;
      case Status.Answered:
        user.node.role = Role.Sender;
        // Handle Answer from Answered Peer
        await user.node.handleAnswer(event.answer);

        // Begin Transfer
        data.add(Transfer(event.match));

        // Change State
        user.node.status = Status.Transferring;
        yield Transferring(event.match);
        break;
      case Status.Transferring:
        yield Transferring(event.match);
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
