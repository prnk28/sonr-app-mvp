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
  double _lastDirection;

  // Required Blocs
  final DataBloc data;
  final DeviceBloc device;
  final UserBloc user;
  Peer _node;

  // Constructer
  WebBloc(this.data, this.device, this.user) : super(null) {
    _node = user.node;
    // ****************************** //
    // ** Device BLoC Subscription ** //
    // ****************************** //
    directionSubscription = device.directionCubit.listen((direction) {
      // Check Diff Direction
      if (direction != _lastDirection && this.state is! Loading) {
        // Device is Searching
        if (this.state is Searching) {
          add(Search());
        }
        // Send with 500ms delay
        else if (this.state is Active) {
          add(Active());
        }
        _lastDirection = direction;
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
    if (user.node != null) {
      // Emit Peer Node
      _node.emit(OutgoingMessage.Connect);

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
    user.node.status = PeerStatus.Active;

    // Add Delay
    // await Future.delayed(const Duration(milliseconds: 500));

    // Yield Searching with Closest Neighbor
    yield Available();
  }

// *********************
// ** Search Event ***
// *********************
  Stream<WebState> _mapSearchToState(Search event) async* {
    // Update Status
    _node.status = PeerStatus.Searching;

    // Add Delay
    // Future.delayed(const Duration(milliseconds: 250));

    // Yield Searching with Closest Neighbor
    yield Searching(activePeers: user.node.getZonedPeers());
  }

// ***************************************** //
// ** Handle Event = OFFER/ANSWER/DECLINE ** //
// ***************************************** //
  // Stream<WebState> _mapHandleToState(Handle event) async* {
  //   // Get Message
  //   var msg = event.message;

  //   // Log Message
  //   log.i(enumAsString(event.type) + ": " + msg.toString());

  //   // Check Event Type
  //   switch (event.type) {
  //     case IncomingMessage.Connected:
  //       // Set Lobby Id
  //       _node.lobbyId = msg["lobbyId"];
  //       add(Active());
  //       break;
  //     case IncomingMessage.Updated:
  //       // Initialize Pathfinder
  //       PathFinder pathFinder = new PathFinder(graph, user.node);

  //       // Yield Searching
  //       yield Searching(pathfinder: pathFinder);
  //       break;
  //     case IncomingMessage.Exit:

  //       // Initialize Pathfinder
  //       PathFinder pathFinder = new PathFinder(graph, user.node);

  //       // Yield Searching
  //       yield Searching(pathfinder: pathFinder);
  //       break;
  //     case IncomingMessage.Offered:
  //       // Get Peer
  //       Peer peer = Peer.fromMap(msg["from"]);

  //       // Update Device Status
  //       user.node.status = PeerStatus.Busy;
  //       yield Pending();
  //       break;
  //     case IncomingMessage.Answered:
  //       data.add(SendChunks());
  //       yield Transferring();
  //       break;
  //     case IncomingMessage.Declined:
  //       add(Fail());
  //       break;
  //     case IncomingMessage.Completed:
  //       add(Complete());
  //       break;
  //     default:
  //       break;
  //   }
  // }

// *******************
// ** Invite Event ***
// *******************
  // Stream<WebState> _mapInviteToState(Invite event) async* {
  //   // Update Node and Device State
  //   _node.status = PeerStatus.Busy;
  //   add(Search());

  //   // Send Invite
  //   _node.invite(event.match, event.metadata);

  //   // Device Pending State
  //   yield Pending(match: event.match);
  // }

// ***********************
// ** Authorize Event ***
// ***********************
  // Stream<WebState> _mapAuthorizeToState(Authorize event) async* {
  //   // Get Message
  //   var msg = event.message;

  //   // Get Peer
  //   Peer match = Peer.fromMap(msg["from"]);

  //   // User ACCEPTED Transfer Request
  //   if (event.decision) {
  //     // Add Incoming File Info
  //     data.add(QueueFile(
  //       info: msg["file_info"],
  //     ));

  //     // Extract Message Info
  //     var description = msg['description'];
  //     session.session_id = msg["session_id"];

  //     // Set New State Change
  //     if (session.onStateChange != null) {
  //       session.onStateChange(SignalingState.CallStateNew);
  //     }

  //     // Initialize Peer Connection
  //     var pc = await session._createPeerConnection(match.id);
  //     await pc.setRemoteDescription(
  //         new RTCSessionDescription(description['sdp'], description['type']));

  //     add(Create(MessageKind.ANSWER, pc: pc, match: match));

  //     yield Transferring();
  //   }
  //   // User DECLINED Transfer Request
  //   else {
  //     // Send Decision
  //     socket.emit("DECLINE", match.id);
  //     add(Complete(resetSession: true));
  //   }
  // }

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
    user.node.status = PeerStatus.Active;

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
