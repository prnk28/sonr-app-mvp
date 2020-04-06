import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sensors/sensors.dart';
import 'package:sonar_app/models/models.dart';
import '../bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/controllers/controllers.dart';
import 'package:socket_io_client/socket_io_client.dart';

// *********************
// ** Initialization ***
// *********************
Socket socket = io('http://match.sonr.io', <String, dynamic>{
  'transports': ['websocket'],
});

class SonarBloc extends Bloc<SonarEvent, SonarState> {
  // Data Provider
  Direction _lastDirection;
  Motion _currentMotion = Motion.create();
  Circle _circle = new Circle();

  // Variables
  Process _currentProcess;
  bool initialized = false;
  bool requested = false;

  // Constructer
  SonarBloc() {
    // ** Connected **
    socket.on('connect', (_) {
      print("Connected to Socket");
    });

    // ** INFO **
    socket.on('INFO', (data) {
      add(Refresh(newDirection: _lastDirection));
      // Add to Process
      print("Lobby Id: " + data);
    });

    // ** NEW_SENDER **
    socket.on('NEW_SENDER', (data) {
      // Send Last Recorded Direction to New Sender
      socket.emit("RECEIVING", [_lastDirection.toReceiveMap()]);
      add(Refresh(newDirection: _lastDirection));
      // Add to Process
      print("NEW_SENDER: " + data);
    });

    // ** SENDER_UPDATE **
    socket.on('SENDER_UPDATE', (data) {
      _circle.status = "Receiver";
      _circle.update(_lastDirection, data);
      add(Refresh(newDirection: _lastDirection));

      // Add to Process
      print("SENDER_UPDATE: " + data);
    });

    // ** SENDER_EXIT **
    socket.on('SENDER_EXIT', (id) {
      // Remove Sender from Circle
      _circle.exit(id);
      add(Refresh(newDirection: _lastDirection));

      // Add to Process
      print("SENDER_EXIT: " + id);
    });

    // ** NEW_RECEIVER **
    socket.on('NEW_RECEIVER', (data) {
      // Send Last Recorded Direction to New Receiver
      socket.emit("SENDING", [_lastDirection.toReceiveMap()]);
      add(Refresh(newDirection: _lastDirection));

      // Add to Process
      print("NEW_RECEIVER: " + data);
    });

    // ** RECEIVER_UPDATE **
    socket.on('RECEIVER_UPDATE', (data) {
      print("RECEIVER_UPDATE: " + data.toString());
      _circle.status = "Sender";
      _circle.update(_lastDirection, data);
      add(Refresh(newDirection: _lastDirection));
      // Add to Process
    });

    // ** RECEIVER_EXIT **
    socket.on('RECEIVER_EXIT', (id) {
      // Remove Receiver from Circle
      _circle.exit(id);
      add(Refresh(newDirection: _lastDirection));

      // Add to Process
      print("RECEIVER_EXIT: " + id);
    });

    // ** SENDER_OFFERED **
    socket.on('SENDER_OFFERED', ([matchProfile, fileData]) {
      // Remove Sender from Circle
      add(Refresh(newDirection: _lastDirection));

      // Add to Process
      print("SENDER_OFFERED: " + matchProfile + ", " + fileData);
    });

    // ** ERROR **
    socket.on('ERROR', (error) {
      // Remove Receiver from Circle

      // Add to Process
      print("ERROR: " + error);
    });

    // Listen to Stream and Add UpdateInput Event every update
    accelerometerEvents.listen((newData) {
      // Update Motion Var
      _currentMotion = Motion.create(a: newData);
    });

    // Subscribe to Motion BLoC Updates
    FlutterCompass.events.listen((newData) {
      // Initialize Direction
      var newDirection = Direction.create(
          degrees: newData, accelerometerX: _currentMotion.accelX);
      // Modify Circle
      _circle.modify(newDirection);

      // Refresh Inputs
      add(Refresh(newDirection: newDirection));
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
      Profile fakeProfile = Profile.fakeProfile();

      // Emit to Socket.io
      socket.emit("INITIALIZE", [fakeLocation.toMap(), fakeProfile.toMap()]);
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
      var dummyFileData = {"type": "Image", "size": 20};
      // Emit to Socket.io
      socket.emit("REQUEST", [_circle.closest()["id"], dummyFileData]);
      requested = true;

      // Device Pending State
      yield Pending(match: _circle.closest());
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
        // Check Init Status
        if (initialized) {
          // Emit Send
          socket.emit("SENDING", [updateSensors.newDirection.toSendMap()]);
          _circle.status = "Sender";
        }

        // Post Update
        add(Update(
            currentDirection: _lastDirection,
            currentMotion: _currentMotion,
            map: _circle));
      }
      // Receive State
      else if (_currentMotion.state == Orientation.LandscapeLeft ||
          _currentMotion.state == Orientation.LandscapeRight) {
        // Check Init Status
        if (initialized) {
          // Emit Receive
          socket.emit("RECEIVING", [updateSensors.newDirection.toReceiveMap()]);
          _circle.status = "Receiver";
        }
        // Post Update
        add(Update(
            currentDirection: _lastDirection,
            currentMotion: _currentMotion,
            map: _circle));
      } else {
        // Update State Dont Duplicate Call
        if (_currentProcess.currentStage != SonarStage.READY) {
          // _sonarRepository.setReset();
        }
      }
      // Pending State
    } else {
      yield Ready(
          currentDirection: updateSensors.newDirection,
          currentMotion: _currentMotion);
    }
  }
}
