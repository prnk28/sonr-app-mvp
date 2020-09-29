import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:graph_collection/graph.dart';

part 'web_event.dart';
part 'web_state.dart';

// ***********************
// ** Sonar Bloc Class ***
// ***********************
class WebBloc extends Bloc<WebEvent, WebState> {
  // Data Providers
  Circle circle;
  Connection connection;
  Graph graph;

  // Required Blocs
  final DataBloc dataBloc;
  final DeviceBloc deviceBloc;

  // Device State Subscription
  StreamSubscription deviceSubscription;

  // Constructer
  WebBloc(this.dataBloc, this.deviceBloc) : super(null) {
    // ** Verify Both Blocs Connected
    if (deviceBloc == null || dataBloc == null) return;

    // ** Subscribe to Device BLoC State Changes
    deviceSubscription = deviceBloc.listen((DeviceState currDeviceState) {
      // Device can Record Data/ Portrait
      if (currDeviceState is Ready) {
        log.i("DeviceBloc State: Ready <- from WebBloc");
      }
      // Device is Tilted or Landscape
      else if (currDeviceState is Sending || currDeviceState is Receiving) {
        add(SendSearch(peer: currDeviceState.user));
      }
      // Interacting with another Peer
      else if (currDeviceState is Busy) {
        log.i("DeviceBloc State: Busy <- from WebBloc");
      }
      // Refreshing Sensors
      else if (currDeviceState is Refreshing) {
        log.i("DeviceBloc State: Refreshing <- from WebBloc");
      }
      // Inactive
      else {
        log.i("DeviceBloc State: Inactive <- from WebBloc");
      }
    });

    // ** Repo Initialization **
    circle = new Circle(this);
    connection = new Connection(this);
    graph = new Graph();
  }

  // Initial State
  WebState get initialState => Disconnected();

  // On Bloc Close
  void dispose() {
    deviceSubscription.cancel();
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
    } else if (event is SendSearch) {
      yield* _mapSendPeerToState(event);
    } else if (event is SendInvite) {
      yield* _mapInviteToState(event);
    } else if (event is HandleOffer) {
      yield* _mapOfferedToState(event);
    } else if (event is SendAuthorization) {
      yield* _mapAuthorizeToState(event);
    } else if (event is HandleAnswer) {
      yield* _mapAcceptedToState(event);
    } else if (event is HandleDecline) {
      yield* _mapDeclinedToState(event);
    } else if (event is BeginTransfer) {
      yield* _mapTransferToState(event);
    } else if (event is HandleReceived) {
      yield* _mapReceivedToState(event);
    } else if (event is HandleComplete) {
      yield* _mapCompletedToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState(event);
    }
  }

// ********************
// ** Connect Event ***
// ********************
  Stream<WebState> _mapConnectToState(Connect initializeEvent) async* {
    // Check Status
    if (connection.needSetup()) {
      // Emit to Socket.io from User Peer Node
      socket.emit("INITIALIZE",
          [deviceBloc.user.locationToMap(), deviceBloc.user.toMap()]);
      connection.initialized = true;

      // Fake Select File in Queue
      File transferToSend =
          await localData.getAssetFileByPath("assets/images/fat_test.jpg");
      dataBloc.add(QueueFile(receiving: false, file: transferToSend));

      // Device Pending State
      yield Connected();
    }
  }

// **************************
// ** SendSearching Event ***
// **************************
  Stream<WebState> _mapSendPeerToState(SendSearch event) async* {
    // Check Init Status
    if (connection.ready()) {
      // Emit Send
      const delay = const Duration(milliseconds: 500);
      new Timer(delay, () => {socket.emit("SENDING", [])});
    }

    // Set Suspend state with lastState
    yield Searching();
  }

// ***********************
// ** SendInvite Event ***
// ***********************
  Stream<WebState> _mapInviteToState(SendInvite event) async* {
    // Check Status
    if (connection.ready()) {
      // Set Invited
      connection.invited = true;

      // Set Peer
      rtcSession.peerId = circle.closestId();

      // Create Offer and Emit
      rtcSession.invite(
          this.circle.closestId(), dataBloc.outgoing.first.toString());

      // Device Pending State
      yield Pending(match: circle.closestProfile());
    }
  }

// ********************
// ** Offered Event ***
// ********************
  Stream<WebState> _mapOfferedToState(HandleOffer event) async* {
    // Check Status
    if (connection.ready()) {
      // Set Offered and Peer
      connection.offered = true;
      rtcSession.peerId = event.profile["id"];

      // Add Incoming File Info
      dataBloc.add(QueueFile(
        receiving: true,
      ));

      // Device Pending State
      yield Pending(match: circle.closestProfile(), offer: event.offer);
    }
  }

// ******************************
// ** SendAuthorization Event ***
// ******************************
  Stream<WebState> _mapAuthorizeToState(SendAuthorization event) async* {
    // Check Status
    if (connection.initialized) {
      // Yield Receiver Decision
      if (event.decision) {
        // Create Answer
        rtcSession.handleOffer(event.offer);
        yield Transferring();
      }
      // Receiver Declined
      else {
        // Reset Peer
        rtcSession.resetPeer();

        // Send Decision
        socket.emit("DECLINE", event.matchId);
        add(Reset());
      }
    }
  }

// *************************
// ** HandleAnswer Event ***
// *************************
  Stream<WebState> _mapAcceptedToState(HandleAnswer event) async* {
    // Check Status
    if (connection.initialized) {
      // Handle Answer
      rtcSession.handleAnswer(event.answer);

      // Begin Transfer

      yield Transferring();
    }
  }

// **************************
// ** HandleDecline Event ***
// **************************
  Stream<WebState> _mapDeclinedToState(HandleDecline event) async* {
    // Check Status
    if (connection.initialized) {
      // Reset Peer
      rtcSession.resetPeer();

      // Emit Decision to Server
      yield Failed(profile: event.profile, matchId: event.matchId);
    }
  }

// *********************
// ** Transfer Event ***
// *********************
  Stream<WebState> _mapTransferToState(BeginTransfer event) async* {
    // Check Status
    if (connection.initialized) {
      // Begin Transfer
      dataBloc.add(SendChunks());

      // Emit Decision to Server
      yield Transferring();
    }
  }

// *********************
// ** Received Event ***
// *********************
  Stream<WebState> _mapReceivedToState(HandleReceived event) async* {
    // Check Status
    if (connection.initialized) {
      // Emit Decision to Server
      yield Complete("RECEIVER", file: event.data);
    }
  }

// *********************
// ** Completed Event ***
// *********************
  Stream<WebState> _mapCompletedToState(HandleComplete event) async* {
    // Check Status
    if (connection.initialized) {
      // Emit Decision to Server
      yield Complete("SENDER");
    }
  }

// *********************
// ** Reset Event ***
// *********************
  Stream<WebState> _mapResetToState(Reset event) async* {
    // Check Status
    if (connection.initialized) {
      // Reset Connection
      connection.reset();

      // Reset RTC
      rtcSession.close();
      rtcSession.resetPeer();

      // Reset Circle
      circle.reset();

      // Set Delay
      await new Future.delayed(Duration(seconds: 1));

      // Yield Ready
      yield Connected();
    } else {
      add(Connect());
    }
  }
}
