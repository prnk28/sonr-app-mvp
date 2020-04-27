import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sensor_compass/flutter_sensor_compass.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:logger/logger.dart';
import 'package:sensors/sensors.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repositories/repositories.dart';
import 'package:soundpool/soundpool.dart';
import '../bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:path_provider/path_provider.dart';

// *********************
// ** Initialization ***
// *********************
// SocketIO Connection
Socket socket = io('http://match.sonr.io', <String, dynamic>{
  'transports': ['websocket'],
});

var logger = Logger();

// ***********************
// ** Sonar Bloc Class ***
// ***********************
class SonarBloc extends Bloc<SonarEvent, SonarState> {
  // Data Provider
  RTCRepository _rtcSignaler;
  RTCDataChannel _dataChannel;
  Direction _lastDirection;
  Motion _currentMotion = Motion.create();
  Circle _circle = new Circle();
  Soundpool _soundpool = new Soundpool(streamType: StreamType.music);

  // Transfer Variables
  bool initialized = false;
  bool requested = false;
  bool offered = false;

  // Constructer
  SonarBloc() {
    // ** SOCKET::Connected **
    socket.on('connect', (_) async {
      logger.v("Connected to Socket");
    });

    // ** SOCKET::INFO **
    socket.on('INFO', (data) {
      add(Refresh(newDirection: _lastDirection));
      // Add to Process
      logger.v("Lobby Id: " + data);
    });

    // ** SOCKET::NEW_SENDER **
    socket.on('NEW_SENDER', (data) {
      // Send Last Recorded Direction to New Sender
      socket.emit("RECEIVING", [_lastDirection.toReceiveMap()]);
      add(Refresh(newDirection: _lastDirection));
      // Add to Process
      logger.i("NEW_SENDER: " + data);
    });

    // ** SOCKET::SENDER_UPDATE **
    socket.on('SENDER_UPDATE', (data) {
      _circle.update(_lastDirection, data);
      add(Refresh(newDirection: _lastDirection));
    });

    // ** SOCKET::SENDER_EXIT **
    socket.on('SENDER_EXIT', (id) {
      // Remove Sender from Circle
      _circle.exit(id);
      add(Refresh(newDirection: _lastDirection));

      // Add to Process
      logger.w("SENDER_EXIT: " + id);
    });

    // ** SOCKET::NEW_RECEIVER **
    socket.on('NEW_RECEIVER', (data) {
      // Send Last Recorded Direction to New Receiver
      if (_lastDirection != null) {
        socket.emit("SENDING", [_lastDirection.toReceiveMap()]);
      }

      add(Refresh(newDirection: _lastDirection));

      // Add to Process
      logger.i("NEW_RECEIVER: " + data);
    });

    // ** SOCKET::RECEIVER_UPDATE **
    socket.on('RECEIVER_UPDATE', (data) {
      //print("RECEIVER_UPDATE: " + data.toString());
      _circle.update(_lastDirection, data);
      add(Refresh(newDirection: _lastDirection));
    });

    // ** SOCKET::RECEIVER_EXIT **
    socket.on('RECEIVER_EXIT', (id) {
      // Remove Receiver from Circle
      _circle.exit(id);
      add(Refresh(newDirection: _lastDirection));

      // Add to Process
      logger.w("RECEIVER_EXIT: " + id);
    });

    // ** SOCKET::SENDER_OFFERED **
    socket.on('SENDER_OFFERED', (data) async {
      logger.i("SENDER_OFFERED: " + data.toString());

      dynamic _offer = data[0];

      // Remove Sender from Circle
      add(Offered(profileData: _circle.closest(), offer: _offer));
    });

    // ** SOCKET::NEW_CANDIDATE **
    socket.on('NEW_CANDIDATE', (data) async {
      logger.i("NEW_CANDIDATE: " + data.toString());

      _rtcSignaler.handleCandidate(data);
    });

    // ** SOCKET::RECEIVER_ANSWERED **
    socket.on('RECEIVER_ANSWERED', (data) async {
      logger.i("RECEIVER_ANSWERED: " + data.toString());

      dynamic _answer = data[0];

      add(Accepted(_circle.closest(), _circle.closest()["id"], _answer));
    });

    // ** SOCKET::RECEIVER_DECLINED **
    socket.on('RECEIVER_DECLINED', (data) {
      dynamic matchId = data[0];

      add(Declined(_circle.closest(), matchId));
      // Add to Process
      logger.w("RECEIVER_DECLINED: " + data.toString());
    });

    // ** SOCKET::RECEIVER_COMPLETED **
    socket.on('RECEIVER_COMPLETED', (data) {
      dynamic matchId = data[0];

      add(Completed(_circle.closest(), matchId));
      // Add to Process
      logger.i("RECEIVER_COMPLETED: " + data.toString());
    });

    // ** SOCKET::ERROR **
    socket.on('ERROR', (error) {
      // Add to Process
      logger.e("ERROR: " + error);
    });

    // ** RTC::Initialization **
    _rtcSignaler = new RTCRepository();

    _rtcSignaler.onDataChannel = (channel) {
      _dataChannel = channel;
    };

    // ** RTC::Data Message **
    _rtcSignaler.onDataChannelMessage = (dc, RTCDataChannelMessage data) async {
      if (data.isBinary) {
        logger.i('Got binary [' + data.binary.toString() + ']');
      } else {
        logger.i(data.text);
      }
    };

    // ** Accelerometer Events **
    accelerometerEvents.listen((newData) {
      // Update Motion Var
      _currentMotion = Motion.create(a: newData);
    });

    // ** Directional Events **
    Compass()
        .compassUpdates(interval: Duration(milliseconds: 400))
        .listen((newData) {
      // Check Status
      if (!offered && !requested) {
        // Initialize Direction
        var newDirection = Direction.create(
            degrees: newData, accelerometerX: _currentMotion.accelX);

        // Check Sender Threshold
        if (_currentMotion.state == Orientation.Tilt) {
          // Set Sender
          _circle.status = "Sender";

          // Check Valid
          if (_lastDirection != null) {
            // Generate Difference
            var difference = newDirection.degrees - _lastDirection.degrees;

            // Threshold
            if (difference.abs() > 5) {
              // Modify Circle
              _circle.modify(newDirection);

              // Refresh Inputs
              add(Refresh(newDirection: newDirection));
            }
          }
          add(Refresh(newDirection: newDirection));
        }
        // Check Receiver Threshold
        else if (_currentMotion.state == Orientation.LandscapeLeft ||
            _currentMotion.state == Orientation.LandscapeRight) {
          // Set Receiver
          _circle.status = "Receiver";

          // Check Valid
          if (_lastDirection != null) {
            // Generate Difference
            var difference = newDirection.degrees - _lastDirection.degrees;
            if (difference.abs() > 10) {
              // Modify Circle
              _circle.modify(newDirection);
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
      yield* _mapInitializeToState(event, _lastDirection, _currentMotion);
    } else if (event is Send) {
      yield* _mapSendToState(event, _lastDirection, _currentMotion);
    } else if (event is Receive) {
      yield* _mapReceiveToState(event, _lastDirection, _currentMotion);
    } else if (event is Update) {
      yield* _mapUpdateToState(event, _lastDirection, _currentMotion);
    } else if (event is Refresh) {
      yield* _mapRefreshInputToState(event);
    } else if (event is Request) {
      yield* _mapRequestToState(event);
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
                socket.emit("SENDING", [_lastDirection.toSendMap()])
              });
    }

    // Set Suspend state with lastState
    if (sendEvent.map != null) {
      yield Sending(
          matches: sendEvent.map,
          currentMotion: motion,
          currentDirection: _lastDirection);
    } else {
      yield Sending(currentMotion: motion, currentDirection: _lastDirection);
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
                socket.emit("RECEIVING", [_lastDirection.toReceiveMap()])
              });
    }

    // Set Suspend state with lastState
    if (receiveEvent.map != null) {
      yield Receiving(
          matches: receiveEvent.map,
          currentMotion: motion,
          currentDirection: _lastDirection);
    } else {
      yield Receiving(currentMotion: motion, currentDirection: _lastDirection);
    }
  }

// ***********************
// ** Request Event ***
// ***********************
  Stream<SonarState> _mapRequestToState(Request requestEvent) async* {
    // Check Status
    if (initialized && !requested) {
      // Emit to Socket.io
      requested = true;

      // Create Offer and Emit
      _rtcSignaler.invite(_circle.closest()["id"]);

      // Device Pending State
      yield Pending("SENDER", match: _circle.closest());
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
        _rtcSignaler.handleOffer(authorizeEvent.offer);
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
      _rtcSignaler.handleAnswer(acceptedEvent.answer);
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
      ByteData asset = await rootBundle.load('assets/audio/truck.mp3');
      var binary = asset.buffer.asUint8List();
      String text = 'Say hello ' + ' times, from [' + socket.id + ']';
      _dataChannel.send(RTCDataChannelMessage(text));
      _dataChannel.send(RTCDataChannelMessage.fromBinary(binary));
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
      var buffer = receivedEvent.file.buffer;
      var bdata = new ByteData.view(buffer);
      int soundId = await _soundpool.load(bdata);
      _soundpool.play(soundId);

      // Emit Completed
      socket.emit(
          "COMPLETE", [_circle.closest()["id"], _circle.closest()["profile"]]);

      // Emit Decision to Server
      yield Complete();
    }
  }

// *********************
// ** Completed Event ***
// *********************
  Stream<SonarState> _mapCompletedToState(Completed completedEvent) async* {
    // Check Status
    if (initialized) {
      // Emit Decision to Server
      yield Complete();
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
      _circle.status = "Default";

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
    if (updateEvent.map.status == "Sender") {
      add(Send(map: updateEvent.map));
    } else {
      add(Receive(map: updateEvent.map));
    }
    yield Loading();
  }

// **************************
// ** Refresh Input Event ***
// **************************
  Stream<SonarState> _mapRefreshInputToState(Refresh updateSensors) async* {
// Check Status
    if (!offered && !requested) {
      // Check State
      if (_currentMotion.state == Orientation.Tilt ||
          _currentMotion.state == Orientation.LandscapeLeft ||
          _currentMotion.state == Orientation.LandscapeRight) {
        // Check Directions
        if (_lastDirection != updateSensors.newDirection) {
          // Set as new direction
          _lastDirection = updateSensors.newDirection;
        }
        // Check State
        if (_currentMotion.state == Orientation.Tilt) {
          // Post Update
          add(Update(
              currentDirection: _lastDirection,
              currentMotion: _currentMotion,
              map: _circle));
        }
        // Receive State
        else if (_currentMotion.state == Orientation.LandscapeLeft ||
            _currentMotion.state == Orientation.LandscapeRight) {
          // Post Update
          add(Update(
              currentDirection: _lastDirection,
              currentMotion: _currentMotion,
              map: _circle));
        }
        // Pending State
      } else {
        yield Ready(
            currentDirection: updateSensors.newDirection,
            currentMotion: _currentMotion);
      }
    }
  }
}
