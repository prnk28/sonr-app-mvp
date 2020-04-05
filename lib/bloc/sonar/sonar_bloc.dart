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

  // Constructer
  SonarBloc() {
    // ** Connected **
    socket.on('connect', (_) {
      print("Connected to Socket");
    });

    // ** INFO **
    socket.on('INFO', (data) {
      // Add to Process
      print("Lobby Id: " + data);
    });

    // ** NEW_SENDER **
    socket.on('NEW_SENDER', (data) {
      // Send Last Recorded Direction to New Sender
      socket.emit("RECEIVING", [_lastDirection.toReceiveMap()]);

      // Add to Process
      print("NEW_SENDER: " + data);
    });

    // ** SENDER_UPDATE **
    socket.on('SENDER_UPDATE', (data) {
      _circle.status = "Receiver";
      _circle.update(_lastDirection, data);
      // Add to Process
      print("SENDER_UPDATE: " + data);
    });

    // ** SENDER_EXIT **
    socket.on('SENDER_EXIT', (id) {
      // Remove Sender from Circle
      _circle.exit(id);

      // Add to Process
      print("SENDER_EXIT: " + id);
    });

    // ** NEW_RECEIVER **
    socket.on('NEW_RECEIVER', (data) {
      // Send Last Recorded Direction to New Receiver
      socket.emit("SENDING", [_lastDirection.toReceiveMap()]);

      // Add to Process
      print("NEW_RECEIVER: " + data);
    });

    // ** RECEIVER_UPDATE **
    socket.on('RECEIVER_UPDATE', (data) {
      print("RECEIVER_UPDATE: " + data.toString());
      _circle.status = "Sender";
      _circle.update(_lastDirection, data);
      // Add to Process
    });

    // ** RECEIVER_EXIT **
    socket.on('RECEIVER_EXIT', (id) {
      // Remove Receiver from Circle
      _circle.exit(id);

      // Add to Process
      print("RECEIVER_EXIT: " + id);
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
    } else if (event is CompareDirections) {
      yield* _mapCompareDirectionsToState(event);
    } else if (event is Load) {
      yield* _mapLoadingToState(event, this.state);
    }
    // } else if (event is Offered) {
    //   yield* _mapOfferedToState(event);
    // } else if (event is StartTransfer) {
    //   yield* _mapStartTransferToState(event);
    // } else if (event is CompleteTransfer) {
    //   yield* _mapCompleteTransferState(event);
    // } else if (event is CancelSonar) {
    //   yield* _mapCancelSonarToState(event);
    // } else if (event is ResetSonar) {
    //   yield* _mapResetSonarToState(event);
    // }
  }

// ***************************
// ** Close Streams on End ***
// ***************************
  @override
  Future<void> close() {
    return super.close();
  }

// ***********************
// ** Initialize Event ***
// ***********************
  Stream<SonarState> _mapInitializeToState(
      Initialize initializeEvent, Direction direction, Motion motion) async* {
    // Initialize Variables
    Location fakeLocation = Location.fakeLocation();
    Profile fakeProfile = Profile.fakeProfile();

    // Emit to Socket.io
    socket.emit("INITIALIZE", [fakeLocation.toMap(), fakeProfile.toMap()]);

    // Device Pending State
    yield Ready();
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

// *****************
// ** Loading Event ***
// *****************
  Stream<SonarState> _mapLoadingToState(
      Load loadEvent, SonarState lastState) async* {
    add(Refresh(newDirection: _lastDirection));
    yield Loading();
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

  // On InMotion Event ->
  Stream<SonarState> _mapRefreshInputToState(Refresh updateSensors) async* {
    // Check State
    if (_currentMotion.state == Orientation.Tilt ||
        _currentMotion.state == Orientation.LandscapeLeft ||
        _currentMotion.state == Orientation.LandscapeRight) {
      // Compare Directions
      add(CompareDirections(_lastDirection, updateSensors.newDirection));
      // Pending State
    } else {
      yield Ready(
          currentDirection: updateSensors.newDirection,
          currentMotion: _currentMotion);
    }
  }

  // On InMotion Event ->
  Stream<SonarState> _mapCompareDirectionsToState(
      CompareDirections compareDirections) async* {
    // Check Directions
    if (compareDirections.lastDirection != compareDirections.newDirection) {
      // Set as new direction
      _lastDirection = compareDirections.newDirection;
    }
    // Check State
    if (_currentMotion.state == Orientation.Tilt) {
      // Update State
      socket.emit("SENDING", [compareDirections.newDirection.toSendMap()]);
      _circle.status = "Sender";

      // Post Update
      add(Update(
          currentDirection: _lastDirection,
          currentMotion: _currentMotion,
          map: _circle));
    }
    // Receive State
    else if (_currentMotion.state == Orientation.LandscapeLeft ||
        _currentMotion.state == Orientation.LandscapeRight) {
      // Update State
      socket.emit("RECEIVING", [compareDirections.newDirection.toReceiveMap()]);
      _circle.status = "Receiver";

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
  }
}

// *******************
// ** Select Event ***
// *******************
// Stream<SonarState> _mapSelectState(Select selectEvent) async* {
//     // Set Suspend state with lastState
//     yield Sending();
// }

// ********************
// ** Request Event ***
// ********************
// Stream<SonarState> _mapRequestToState(Request requestEvent) async* {
//     // Set Suspend state with lastState
//     yield Sending();
// }

// ********************************
// ** Receiver Gets Offer Event ***
// ********************************
// Stream<SonarState> _mapOfferedToState(Offered offeredEvent) async* {
//     // Set Suspend state with lastState
//     yield Sending();
// }

// ***************************
// ** Begin Transfer Event ***
// ***************************
// Stream<SonarState> _mapStartTransferToState(StartTransfer startTransferEvent) async* {
//     // Set Suspend state with lastState
//     yield Sending();
// }

// ******************************
// ** Complete Transfer Event ***
// ******************************
// Stream<SonarState> _mapCompleteTransferState(CompleteTransfer completeTransferEvent) async* {
//     // Set Suspend state with lastState
//     yield Sending();
// }

// ****************************
// ** Cancel Transfer Event ***
// ****************************
// Stream<SonarState> _mapCancelSonarToState(CancelSonar cancelSonarEvent) async* {
//     // Set Suspend state with lastState
//     yield Sending();
// }

// ************************
// ** Reset Sonar Event ***
// ************************
// Stream<SonarState> _mapResetSonarToState(ResetSonar resetSonarEvent) async* {
//     // Set Suspend state with lastState
//     yield Sending();
// }
