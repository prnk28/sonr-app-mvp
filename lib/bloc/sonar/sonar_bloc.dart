import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sensor_compass/flutter_sensor_compass.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:logger/logger.dart';
import 'package:sensors/sensors.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repositories/repositories.dart';
import '../bloc.dart';
import 'package:sonar_app/core/core.dart';

// ***********************
// ** Sonar Bloc Class ***
// ***********************
class SonarBloc extends Bloc<SonarEvent, SonarState> {
  // Data Provider
  Session session;
  Connection connection;
  Device device;
  RTCDataChannel _dataChannel;
  Circle circle;

  // Constructer
  SonarBloc() : super(null) {
    // ** RTC::Initialization **
    session = new Session();
    connection = new Connection(this);
    circle = new Circle();
    device = new Device(this);

    session.onDataChannel = (channel) {
      _dataChannel = channel;
    };

    // ** RTC::Data Message **
    session.onDataChannelMessage = (dc, RTCDataChannelMessage data) async {
      add(Received(data));
    };
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
                socket.emit("SENDING", [device.lastDirection.toSendMap()])
              });
    }

    // Set Suspend state with lastState
    if (sendEvent.map != null) {
      yield Sending(
          matches: sendEvent.map,
          currentMotion: device.currentMotion,
          currentDirection: device.lastDirection);
    } else {
      yield Sending(
          currentMotion: device.currentMotion,
          currentDirection: device.lastDirection);
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
                socket.emit("RECEIVING", [device.lastDirection.toReceiveMap()])
              });
    }

    // Set Suspend state with lastState
    if (receiveEvent.map != null) {
      yield Receiving(
          matches: receiveEvent.map,
          currentMotion: device.currentMotion,
          currentDirection: device.lastDirection);
    } else {
      yield Receiving(
          currentMotion: device.currentMotion,
          currentDirection: device.lastDirection);
    }
  }

// ***********************
// ** Invite Event ***
// ***********************
  Stream<SonarState> _mapInviteToState(Invite requestEvent) async* {
    // Check Status
    if (connection.ready()) {
      // Emit to Socket.io
      connection.invited = true;

      // Create Offer and Emit
      session.invite(circle.closest()["id"]);

      // Device Pending State
      yield Pending("SENDER", match: circle.closest());
    }
  }

// ***********************
// ** Offered Event ***
// ***********************
  Stream<SonarState> _mapOfferedToState(Offered offeredEvent) async* {
    // Check Status
    if (connection.ready()) {
      // Set Offered
      connection.offered = true;

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
    if (connection.initialized) {
      // Yield Receiver Decision
      if (authorizeEvent.decision) {
        // Create Answer
        session.handleOffer(authorizeEvent.offer);
        yield Transferring();
      }
      // Receiver Declined
      else {
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
      session.handleAnswer(acceptedEvent.answer);
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
      // Audio as bytes

      ByteData bytes = await rootBundle.load('assets/images/headers/1.jpg');

      String text = 'Say hello ' + ' times, from [' + socket.id + ']';
      _dataChannel.send(RTCDataChannelMessage(text));
      _dataChannel
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
    if (connection.initialized) {
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
      socket.emit(
          "COMPLETE", [circle.closest()["id"], circle.closest()["profile"]]);

      // Emit Decision to Server
      yield Complete("RECEIVER", file: receivedEvent.data.binary);
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
      session.close();

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
    if (connection.noContact()) {
      // Check State
      if (device.isSearching()) {
        // Check Directions
        if (device.lastDirection != updateSensors.newDirection) {
          // Set as new direction
          device.lastDirection = updateSensors.newDirection;
        }
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
