import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repositories/broadcast.dart';
import 'package:sonar_app/repositories/device.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repositories/repositories.dart';

import '../bloc.dart';

// ***********************
// ** Sonar Bloc Class ***
// ***********************
class SonarBloc extends Bloc<SonarEvent, SonarState> {
  // Data Provider
  Circle circle = new Circle();
  Connection conn;
  Device device;

  // Constructer
  SonarBloc() : super(null) {
    conn = new Connection(this);
    device = new Device(this, conn);
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
      yield* _mapInitializeToState(
          event, device.lastDirection, device.currentMotion);
    } else if (event is Send) {
      yield* _mapSendToState(event, device.lastDirection, device.currentMotion);
    } else if (event is Receive) {
      yield* _mapReceiveToState(
          event, device.lastDirection, device.currentMotion);
    } else if (event is Update) {
      yield* _mapUpdateToState(
          event, device.lastDirection, device.currentMotion);
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
  Stream<SonarState> _mapInitializeToState(
      Initialize initializeEvent, Direction direction, Motion motion) async* {
    // Check Status
    if (conn.needSetup()) {
      // Initialize Variables
      Location fakeLocation = Location.fakeLocation();

      // Emit to Socket.io
      conn.emit(SocketEvent.INITIALIZE,
          data: [fakeLocation.toMap(), initializeEvent.userProfile.toMap()]);

      // Device Pending State
      yield Ready();
    }
  }

// *****************
// ** Send Event ***
// *****************
  Stream<SonarState> _mapSendToState(
      Send sendEvent, Direction direction, Motion motion) async* {
    // Check Init Status
    if (conn.ready()) {
      // Emit Send
      const delay = const Duration(milliseconds: 500);
      new Timer(
          delay,
          () => {
                conn.emit(SocketEvent.SENDING,
                    data: device.lastDirection.toSendMap())
              });
    }

    // Set Suspend state with lastState
    if (sendEvent.map != null) {
      yield Sending(
          matches: sendEvent.map,
          currentMotion: motion,
          currentDirection: device.lastDirection);
    } else {
      yield Sending(
          currentMotion: motion, currentDirection: device.lastDirection);
    }
  }

// ********************
// ** Receive Event ***
// ********************
  Stream<SonarState> _mapReceiveToState(
      Receive receiveEvent, Direction direction, Motion motion) async* {
    // Check Init Status
    if (conn.ready()) {
      const delay = const Duration(milliseconds: 750);
      new Timer(
          delay,
          () => {
                // Emit Receive
                conn.emit(SocketEvent.RECEIVING,
                    data: device.lastDirection.toReceiveMap())
              });
    }

    // Set Suspend state with lastState
    if (receiveEvent.map != null) {
      yield Receiving(
          matches: receiveEvent.map,
          currentMotion: motion,
          currentDirection: device.lastDirection);
    } else {
      yield Receiving(
          currentMotion: motion, currentDirection: device.lastDirection);
    }
  }

// ***********************
// ** Invite Event ***
// ***********************
  Stream<SonarState> _mapInviteToState(Invite inviteEvent) async* {
    // Check Status
    if (conn.ready()) {
      // Create Offer and Emit
      conn.signal(RTCEvent.Invite, data: circle.closest()["id"]);

      // Device Pending State
      yield Pending("SENDER", match: circle.closest());
    }
  }

// ***********************
// ** Offered Event ***
// ***********************
  Stream<SonarState> _mapOfferedToState(Offered offeredEvent) async* {
    // Check Status
    if (conn.ready()) {
      // Device Pending State
      yield Pending("RECEIVER",
          match: offeredEvent.profileData,
          file: offeredEvent.fileData,
          offer: offeredEvent.offer);
    }
  }

// **********************
// ** Authorize Event ***
// **********************
  Stream<SonarState> _mapAuthorizeToState(Authorize authorizeEvent) async* {
    // Check Status
    if (conn.initialized) {
      // Yield Receiver Decision
      if (authorizeEvent.decision) {
        // Create Answer
        conn.signal(RTCEvent.Offer, data: authorizeEvent.offer);
        yield Transferring();
      }
      // Receiver Declined
      else {
        conn.emit(SocketEvent.DECLINE);
        add(Reset(0));
      }
    }
  }

// **********************
// ** Accepted Event ***
// **********************
  Stream<SonarState> _mapAcceptedToState(Accepted acceptedEvent) async* {
    // Check Status
    if (conn.initialized) {
      conn.signal(RTCEvent.Answer, data: acceptedEvent.answer);

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
    if (conn.initialized) {
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
    if (conn.initialized) {
      // Audio as bytes
      ByteData bytes = await rootBundle.load('assets/images/headers/1.jpg');

      String text = 'Say hello ' + ' times, from [' + conn.id + ']';
      conn.session.send(RTCDataChannelMessage(text));
      conn.session
          .send(RTCDataChannelMessage.fromBinary(bytes.buffer.asUint8List()));
      // Emit Decision to Server
      yield Transferring();
    }
  }

// *********************
// ** Received Event ***
// *********************
  Stream<SonarState> _mapReceivedToState(Received receivedEvent) async* {
    // Check Status
    if (conn.initialized) {
      // Read Data
      if (receivedEvent.data.isBinary) {
        log.i("Got Binary!" +
            receivedEvent.data.binary.buffer.lengthInBytes.toString());
        //var bdata = new ByteData.view(data.binary.buffer);
        //int soundId = await _soundpool.load(bdata);
        //_soundpool.play(soundId);
      } else {
        log.i(receivedEvent.data.text);
      }
      // Emit Completed
      conn.emit(SocketEvent.COMPLETE,
          data: [circle.closest()["id"], circle.closest()["profile"]]);

      // Emit Decision to Server
      yield Complete("RECEIVER", file: receivedEvent.data.binary);
    }
  }

// *********************
// ** Completed Event ***
// *********************
  Stream<SonarState> _mapCompletedToState(Completed completedEvent) async* {
    // Check Status
    if (conn.initialized) {
      // Emit Decision to Server
      yield Complete("SENDER");
    }
  }

// *********************
// ** Reset Event ***
// *********************
  Stream<SonarState> _mapResetToState(Reset resetEvent) async* {
    // Check Status
    if (conn.initialized) {
      // Reset Circle, Connection
      circle.status = "Default";
      conn.reset();

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
  Stream<SonarState> _mapUpdateToState(
      Update updateEvent, Direction direction, Motion motion) async* {
    if (conn.initialized) {
      if (updateEvent.map.status == "Sender") {
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
    if (conn.noContact()) {
      // Check State
      if (device.isSearching()) {
        // Update Current Direction
        device.updateDirection(updateSensors.newDirection);
        // Check State
        if (device.isSending()) {
          // Post Update
          add(Update(
              currentDirection: device.lastDirection,
              currentMotion: device.currentMotion,
              map: circle));
        }
        // Receive State
        else if (device.isReceiving()) {
          // Post Update
          add(Update(
              currentDirection: device.lastDirection,
              currentMotion: device.currentMotion,
              map: circle));
        }
        // Pending State
      } else {
        yield Ready(
            currentDirection: updateSensors.newDirection,
            currentMotion: device.currentMotion);
      }
    }
  }
}
