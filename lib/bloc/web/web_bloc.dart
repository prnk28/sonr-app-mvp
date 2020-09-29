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
  Device device;
  Graph graph;

  // Required Blocs
  final DataBloc dataBloc;
  //final DeviceBloc deviceBloc;

  // Constructer
  WebBloc(
    this.dataBloc,
  ) : super(null) {
    // ** Repo Initialization **
    circle = new Circle(this);
    connection = new Connection(this);
    device = new Device(this);
    graph = new Graph();
  }

  // Initial State
  WebState get initialState => Initial();
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
    } else if (event is Send) {
      yield* _mapSendToState(event);
    } else if (event is Receive) {
      yield* _mapReceiveToState(event);
    } else if (event is Update) {
      yield* _mapUpdateToState(event);
    } else if (event is Reload) {
      yield* _mapRefreshInputToState(event);
    } else if (event is Invite) {
      yield* _mapInviteToState(event);
    } else if (event is Offered) {
      yield* _mapOfferedToState(event);
    } else if (event is Authorize) {
      yield* _mapAuthorizeToState(event);
    } else if (event is Accepted) {
      yield* _mapAcceptedToState(event);
    } else if (event is Declined) {
      yield* _mapDeclinedToState(event);
    } else if (event is Transfer) {
      yield* _mapTransferToState(event);
    } else if (event is Received) {
      yield* _mapReceivedToState(event);
    } else if (event is Completed) {
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
// Initialize Variables
      Location fakeLocation = Location.fakeLocation();

      // Emit to Socket.io
      socket.emit("INITIALIZE",
          [fakeLocation.toMap(), initializeEvent.userProfile.toMap()]);
      connection.initialized = true;

      // Fake Select File in Queue
      File transferToSend =
          await localData.getAssetFileByPath("assets/images/fat_test.jpg");
      dataBloc.add(QueueFile(receiving: false, file: transferToSend));

      // Device Pending State
      yield Connected();
    }
  }

// *****************
// ** Send Event ***
// *****************
  Stream<WebState> _mapSendToState(Send sendEvent) async* {
    // Check Init Status
    if (connection.ready()) {
      // Emit Send
      const delay = const Duration(milliseconds: 500);
      new Timer(
          delay,
          () => {
                socket.emit("SENDING", [device.direction.toSendMap()])
              });
    }

    // Set Suspend state with lastState
    if (sendEvent.map != null) {
      yield Sending(
          matches: sendEvent.map,
          currentMotion: device.motion,
          currentDirection: device.direction);
    } else {
      yield Sending(
          currentMotion: device.motion, currentDirection: device.direction);
    }
  }

// ********************
// ** Receive Event ***
// ********************
  Stream<WebState> _mapReceiveToState(Receive receiveEvent) async* {
    // Check Init Status
    if (connection.ready()) {
      const delay = const Duration(milliseconds: 750);
      new Timer(
          delay,
          () => {
                // Emit Receive
                socket.emit("RECEIVING", [device.direction.toReceiveMap()])
              });
    }

    // Set Suspend state with lastState
    if (receiveEvent.map != null) {
      yield Receiving(
          matches: receiveEvent.map,
          currentMotion: device.motion,
          currentDirection: device.direction);
    } else {
      yield Receiving(
          currentMotion: device.motion, currentDirection: device.direction);
    }
  }

// ***********************
// ** Invite Event ***
// ***********************
  Stream<WebState> _mapInviteToState(Invite requestEvent) async* {
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

// ***********************
// ** Offered Event ***
// ***********************
  Stream<WebState> _mapOfferedToState(Offered offeredEvent) async* {
    // Check Status
    if (connection.ready()) {
      // Set Offered and Peer
      connection.offered = true;
      rtcSession.peerId = offeredEvent.profile["id"];

      // Add Incoming File Info
      dataBloc.add(QueueFile(
        receiving: true,
      ));

      // Device Pending State
      yield Pending(match: circle.closestProfile(), offer: offeredEvent.offer);
    }
  }

// **********************
// ** Authorize Event ***
// **********************
  Stream<WebState> _mapAuthorizeToState(Authorize authorizeEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Yield Receiver Decision
      if (authorizeEvent.decision) {
        // Create Answer
        rtcSession.handleOffer(authorizeEvent.offer);
        yield InProgress();
      }
      // Receiver Declined
      else {
        // Reset Peer
        rtcSession.resetPeer();

        // Send Decision
        socket.emit("DECLINE", authorizeEvent.matchId);
        add(Reset(0));
      }
    }
  }

// **********************
// ** Accepted Event ***
// **********************
  Stream<WebState> _mapAcceptedToState(Accepted acceptedEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Handle Answer
      rtcSession.handleAnswer(acceptedEvent.answer);

      // Emit Decision to Server
      yield PreTransfer(
          profile: acceptedEvent.profile, matchId: acceptedEvent.matchId);
    }
  }

// **********************
// ** Declined Event ***
// **********************
  Stream<WebState> _mapDeclinedToState(Declined declinedEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Reset Peer
      rtcSession.resetPeer();

      // Emit Decision to Server
      yield Failed(
          profile: declinedEvent.profile, matchId: declinedEvent.matchId);
    }
  }

// *********************
// ** Transfer Event ***
// *********************
  Stream<WebState> _mapTransferToState(Transfer transferEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Begin Transfer
      dataBloc.add(SendChunks());

      // Emit Decision to Server
      yield InProgress();
    }
  }

// *********************
// ** Received Event ***
// *********************
  Stream<WebState> _mapReceivedToState(Received receivedEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Emit Decision to Server
      yield Complete("RECEIVER", file: receivedEvent.data);
    }
  }

// *********************
// ** Completed Event ***
// *********************
  Stream<WebState> _mapCompletedToState(Completed completedEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Emit Decision to Server
      yield Complete("SENDER");
    }
  }

// *********************
// ** Reset Event ***
// *********************
  Stream<WebState> _mapResetToState(Reset resetEvent) async* {
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
      await new Future.delayed(Duration(seconds: resetEvent.secondDelay));

      // Yield Ready
      yield Connected();
    } else {
      add(Connect());
    }
  }

// ********************
// ** Update Event ***
// ********************
  Stream<WebState> _mapUpdateToState(Update updateEvent) async* {
    if (connection.initialized) {
      if (device.status == PositionStatus.SENDER) {
        add(Send(map: updateEvent.map));
      } else {
        add(Receive(map: updateEvent.map));
      }
      yield Loading();
    }
  }

// **************************
// ** Refresh Input Event ***
// **************************
  Stream<WebState> _mapRefreshInputToState(Reload updateSensors) async* {
// Check Status
    if (connection.noContact()) {
      // Check State
      if (device.isSearching()) {
        // Check Directions
        if (device.direction != updateSensors.newDirection) {
          // Set as new direction
          device.direction = updateSensors.newDirection;
        }
        // Check State
        if (device.isSending()) {
          // Post Update
          add(Update(
              currentDirection: device.direction,
              currentMotion: device.motion,
              map: circle));
        }
        // Receive State
        else if (device.isReceiving()) {
          // Post Update
          add(Update(
              currentDirection: device.direction,
              currentMotion: device.motion,
              map: circle));
        }
        // Pending State
      } else {
        yield Connected(
            currentDirection: updateSensors.newDirection,
            currentMotion: device.motion);
      }
    }
  }
}
