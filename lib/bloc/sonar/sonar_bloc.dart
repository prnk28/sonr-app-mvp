import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/core/core.dart';
import 'package:equatable/equatable.dart';

part 'sonar_event.dart';
part 'sonar_state.dart';

// ***********************
// ** Sonar Bloc Class ***
// ***********************
class SonarBloc extends Bloc<SonarEvent, SonarState> {
  // Data Providers
  Circle circle;
  Connection connection;
  Device device;

  // Constructer
  final DataBloc dataBloc;
  SonarBloc(this.dataBloc) : super(null) {
    // ** RTC::Initialization **
    circle = new Circle(this);
    connection = new Connection(this);
    device = new Device(this);
  }

  // Initial State
  SonarState get initialState => Initial();
// *********************************
// ** Map Events to State Method ***
// *********************************
  @override
  Stream<SonarState> mapEventToState(
    SonarEvent event,
  ) async* {
    // Device Can See Updates
    if (event is Initialize) {
      yield* _mapInitializeToState(event);
    } else if (event is Select) {
      yield* _mapSelectToState(event);
    } else if (event is Send) {
      yield* _mapSendToState(event);
    } else if (event is Receive) {
      yield* _mapReceiveToState(event);
    } else if (event is Update) {
      yield* _mapUpdateToState(event);
    } else if (event is Refresh) {
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

// ***********************
// ** Initialize Event ***
// ***********************
  Stream<SonarState> _mapInitializeToState(Initialize initializeEvent) async* {
    // Check Status
    if (connection.needSetup()) {
// Initialize Variables
      Location fakeLocation = Location.fakeLocation();

      // Emit to Socket.io
      socket.emit("INITIALIZE",
          [fakeLocation.toMap(), initializeEvent.userProfile.toMap()]);
      connection.initialized = true;

      // Fake Select File
      add(Select());

      // Device Pending State
      yield Ready();
    }
  }

// *****************
// ** Select Event ***
// *****************
  Stream<SonarState> _mapSelectToState(Select selectEvent) async* {
    // Check Init Status
    if (connection.ready()) {
      // Device Pending State
      yield Ready();
    }
  }

// *****************
// ** Send Event ***
// *****************
  Stream<SonarState> _mapSendToState(Send sendEvent) async* {
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
  Stream<SonarState> _mapReceiveToState(Receive receiveEvent) async* {
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
  Stream<SonarState> _mapInviteToState(Invite requestEvent) async* {
    // Check Status
    if (connection.ready()) {
      // Set Invited
      connection.invited = true;

      // Set Peer
      rtcSession.peerId = circle.closestId();

      // Create Offer and Emit
      rtcSession.invite(
          this.circle.closestId(), dataBloc.outgoing.first.getInfo());

      // Device Pending State
      yield Pending(match: circle.closestProfile());
    }
  }

// ***********************
// ** Offered Event ***
// ***********************
  Stream<SonarState> _mapOfferedToState(Offered offeredEvent) async* {
    // Check Status
    if (connection.ready()) {
      // Set Offered and Peer
      connection.offered = true;
      rtcSession.peerId = offeredEvent.profile["id"];

      // Add Incoming File Info
      dataBloc.add(QueueFile());

      // Device Pending State
      yield Pending(
          match: circle.closestProfile(),
          file: dataBloc.incoming.first,
          offer: offeredEvent.offer);
    }
  }

// **********************
// ** Authorize Event ***
// **********************
  Stream<SonarState> _mapAuthorizeToState(Authorize authorizeEvent) async* {
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
  Stream<SonarState> _mapAcceptedToState(Accepted acceptedEvent) async* {
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
  Stream<SonarState> _mapDeclinedToState(Declined declinedEvent) async* {
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
  Stream<SonarState> _mapTransferToState(Transfer transferEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Emit Decision to Server
      yield InProgress();
    }
  }

// *********************
// ** Received Event ***
// *********************
  Stream<SonarState> _mapReceivedToState(Received receivedEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Emit Decision to Server
      yield Complete("RECEIVER", file: receivedEvent.data);
    }
  }

// *********************
// ** Completed Event ***
// *********************
  Stream<SonarState> _mapCompletedToState(Completed completedEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Emit Decision to Server
      yield Complete("SENDER");
    }
  }

// *********************
// ** Reset Event ***
// *********************
  Stream<SonarState> _mapResetToState(Reset resetEvent) async* {
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
      yield Ready();
    } else {
      add(Initialize());
    }
  }

// ********************
// ** Update Event ***
// ********************
  Stream<SonarState> _mapUpdateToState(Update updateEvent) async* {
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
  Stream<SonarState> _mapRefreshInputToState(Refresh updateSensors) async* {
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
        yield Ready(
            currentDirection: updateSensors.newDirection,
            currentMotion: device.motion);
      }
    }
  }
}
