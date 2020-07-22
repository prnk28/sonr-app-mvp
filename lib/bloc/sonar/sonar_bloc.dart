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
  RTCDataChannel _dataChannel;
  Direction lastDirection;
  Motion currentMotion = Motion.create();
  Circle circle = new Circle();

  // Transfer Variables
  bool initialized = false;
  bool requested = false;
  bool offered = false;

  // Constructer
  SonarBloc() : super(null) {
    // ** RTC::Initialization **
    session = new Session();
    connection = new Connection(this);

    session.onDataChannel = (channel) {
      _dataChannel = channel;
    };

    // ** RTC::Data Message **
    session.onDataChannelMessage = (dc, RTCDataChannelMessage data) async {
      add(Received(data));
    };

    // ** Accelerometer Events **
    accelerometerEvents.listen((newData) {
      // Update Motion Var
      currentMotion = Motion.create(a: newData);
    });

    // ** Directional Events **
    Compass()
        .compassUpdates(interval: Duration(milliseconds: 400))
        .listen((newData) {
      // Check Status
      if (!offered && !requested) {
        // Initialize Direction
        var newDirection = Direction.create(
            degrees: newData, accelerometerX: currentMotion.accelX);

        // Check Sender Threshold
        if (currentMotion.state == Orientation.Tilt) {
          // Set Sender
          circle.status = "Sender";

          // Check Valid
          if (lastDirection != null) {
            // Generate Difference
            var difference = newDirection.degrees - lastDirection.degrees;

            // Threshold
            if (difference.abs() > 5) {
              // Modify Circle
              circle.modify(newDirection);

              // Refresh Inputs
              add(Refresh(newDirection: newDirection));
            }
          }
          add(Refresh(newDirection: newDirection));
        }
        // Check Receiver Threshold
        else if (currentMotion.state == Orientation.LandscapeLeft ||
            currentMotion.state == Orientation.LandscapeRight) {
          // Set Receiver
          circle.status = "Receiver";

          // Check Valid
          if (lastDirection != null) {
            // Generate Difference
            var difference = newDirection.degrees - lastDirection.degrees;
            if (difference.abs() > 10) {
              // Modify Circle
              circle.modify(newDirection);
              // Refresh Inputs
              add(Refresh(newDirection: newDirection));
            }
          }
          add(Refresh(newDirection: newDirection));
        }
      }
    });
  }

  // Initial State
  @override
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
      yield* _mapInitializeToState(event, lastDirection, currentMotion);
    } else if (event is Send) {
      yield* _mapSendToState(event, lastDirection, currentMotion);
    } else if (event is Receive) {
      yield* _mapReceiveToState(event, lastDirection, currentMotion);
    } else if (event is Update) {
      yield* _mapUpdateToState(event, lastDirection, currentMotion);
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
    if (!initialized) {
// Initialize Variables
      Location fakeLocation = Location.fakeLocation();
      // Emit to Socket.io
      socket.emit("INITIALIZE",
          [fakeLocation.toMap(), initializeEvent.userProfile.toMap()]);
      initialized = true;

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
    if (initialized && !requested) {
      // Emit Send
      const delay = const Duration(milliseconds: 500);
      new Timer(
          delay,
          () => {
                socket.emit("SENDING", [lastDirection.toSendMap()])
              });
    }

    // Set Suspend state with lastState
    if (sendEvent.map != null) {
      yield Sending(
          matches: sendEvent.map,
          currentMotion: motion,
          currentDirection: lastDirection);
    } else {
      yield Sending(currentMotion: motion, currentDirection: lastDirection);
    }
  }

// ********************
// ** Receive Event ***
// ********************
  Stream<SonarState> _mapReceiveToState(
      Receive receiveEvent, Direction direction, Motion motion) async* {
    // Check Init Status
    if (initialized && !offered) {
      const delay = const Duration(milliseconds: 750);
      new Timer(
          delay,
          () => {
                // Emit Receive
                socket.emit("RECEIVING", [lastDirection.toReceiveMap()])
              });
    }

    // Set Suspend state with lastState
    if (receiveEvent.map != null) {
      yield Receiving(
          matches: receiveEvent.map,
          currentMotion: motion,
          currentDirection: lastDirection);
    } else {
      yield Receiving(currentMotion: motion, currentDirection: lastDirection);
    }
  }

// ***********************
// ** Invite Event ***
// ***********************
  Stream<SonarState> _mapInviteToState(Invite requestEvent) async* {
    // Check Status
    if (initialized && !requested) {
      // Emit to Socket.io
      requested = true;

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
    if (initialized & !offered) {
      // Set Offered
      offered = true;

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
    if (initialized) {
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
    if (initialized) {
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
    if (initialized) {
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
    if (initialized) {
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
    if (initialized) {
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
    if (initialized) {
      // Emit Decision to Server
      yield Complete("SENDER");
    }
  }

// *********************
// ** Reset Event ***
// *********************
  Stream<SonarState> _mapResetToState(Reset resetEvent) async* {
    // Check Status
    if (initialized) {
      // Reset Vars
      offered = false;
      requested = false;

      // Reset circle
      socket.emit("RESET");
      circle.status = "Default";

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
  Stream<SonarState> _mapUpdateToState(
      Update updateEvent, Direction direction, Motion motion) async* {
    if (initialized) {
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
    if (!offered && !requested) {
      // Check State
      if (currentMotion.state == Orientation.Tilt ||
          currentMotion.state == Orientation.LandscapeLeft ||
          currentMotion.state == Orientation.LandscapeRight) {
        // Check Directions
        if (lastDirection != updateSensors.newDirection) {
          // Set as new direction
          lastDirection = updateSensors.newDirection;
        }
        // Check State
        if (currentMotion.state == Orientation.Tilt) {
          // Post Update
          add(Update(
              currentDirection: lastDirection,
              currentMotion: currentMotion,
              map: circle));
        }
        // Receive State
        else if (currentMotion.state == Orientation.LandscapeLeft ||
            currentMotion.state == Orientation.LandscapeRight) {
          // Post Update
          add(Update(
              currentDirection: lastDirection,
              currentMotion: currentMotion,
              map: circle));
        }
        // Pending State
      } else {
        yield Ready(
            currentDirection: updateSensors.newDirection,
            currentMotion: currentMotion);
      }
    }
  }
}
