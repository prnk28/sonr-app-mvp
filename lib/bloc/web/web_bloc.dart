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
  WebState get initialState => Disconnected();

  // Constructer
  WebBloc(this.data, this.device, this.user) : super(null) {
    // ** Initialize ** //
    socketSub = new SocketSubscriber(user, this);

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
        add(Update(Status.Searching));
      }
      // Send with 500ms delay
      else if (this.state is Available) {
        // Update Direction
        user.node.direction = newDir;

        // Update WebBloc State
        add(Update(Status.Available));
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
    if (event is Connect) {
      yield* _mapConnectToState(event);
    } else if (event is Update) {
      yield* _mapUpdateToState(event);
    } else if (event is Handle) {
      yield* _mapHandleToState(event);
    } else if (event is PeerInvited) {
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
      default:
        log.i("User-Node = " + user.node.status.toString());
        break;
    }
  }

// *******************
// ** Handle Event ***
// *******************
  Stream<WebState> _mapHandleToState(Handle event) async* {
    // Handle Offer
    if (event.offerData != null) {
      // Get Objects
      Peer from = Peer.fromMap(event.offerData[0]);
      dynamic offer = event.offerData[1];
      Metadata meta = Metadata.fromMap(offer['metadata']);

      // Update User Peer Node
      user.node.update(Status.Offered);
      yield Requested(from, offer, meta);
    }

    // Handle Answer
    if (event.answerData != null) {
      // Get Objects
      Peer from = Peer.fromMap(event.answerData[0]);
      dynamic answer = event.answerData[1];

      // Handle Answer from Answered Peer
      await user.node.handleAnswer(from, answer);

      // Change Status
      user.node.update(Status.Transferring);

      // Begin Transfer
      data.add(PeerSentChunk(from));
      yield Transferring(from);
    }
  }

// ******************
// ** Invite Event **
// ******************
  Stream<WebState> _mapInviteToState(PeerInvited event) async* {
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
      await user.node.handleOffer(event.match, event.offer);

      // Add File to Queue
      data.traffic.addIncoming(event.metadata);

      // Update User Peer Node
      user.node.update(Status.Transferring);
      yield Transferring(event.match);
    } else {
      // Send Decline
      user.node.decline(event.match);

      // Change Status
      add(Update(Status.Available));
    }
  }

// *****************
// ** Load Event ***
// *****************
  Stream<WebState> _mapLoadToState(Load load) async* {
    // Check Type of Load
    switch (load.type) {
      case LoadType.Updated:
        if (user.node.isNotBusy()) {
          // Update Graph
          user.node.updateGraph(load.from);
          add(Update(user.node.status));
          yield Loading();
        }
        break;
      case LoadType.Exited:
        // Check if Node is Busy
        if (user.node.isNotBusy()) {
          // Update Graph
          user.node.exitGraph(load.from);
          add(Update(user.node.status));
          yield Loading();
        }
        break;
      case LoadType.Declined:
        // Reset Connection
        user.node.reset(match: load.from);
        add(Update(Status.Searching));
        yield Loading();
        break;
      case LoadType.Error:
        log.e("ERROR: " + load.error.toString());
        add(End(EndType.Fail));
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
        add(Update(Status.Available));

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
