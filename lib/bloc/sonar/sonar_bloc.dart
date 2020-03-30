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

  // Variables
  Process _currentProcess;

  // Constructer
  SonarBloc() {
    // Create Socket
    // ** Connected **
    socket.on('connect', (_) {
      print("Connected to Socket");
      //_currentProcess = new Process(Client.fromMap(_));
    });

    // ** Info **
    socket.on('INFO', (data) {
      // Add to Process
      //_currentProcess.lobby = Lobby.fromMap(message.data);
      print("Lobby Id: " + data);

      // Update Status
      _currentProcess.currentStage = SonarStage.READY;
    });

    // Listen to Stream and Add UpdateInput Event every update
    accelerometerEvents.listen((newData) {
      // Update Motion Var
      _currentMotion = Motion.create(a: newData);
    });

    // Subscribe to Motion BLoC Updates
    FlutterCompass.events.listen((newData) {
      // Refresh Inputs
      add(Refresh(
          newDirection: Direction.create(
              degrees: newData, accelerometerX: _currentMotion.accelX)));
    });
  }

  // Initial State
  @override
  SonarState get initialState => Initial();

_socketStatus(dynamic data) { 
	print("Socket status: " + data); 
}

// *********************
// ** Read Server Msg **
// *********************
  // Subscribe to Sonar Websockets Messages
  _onMessageReceived(Message message) {
    print(message.data);
    switch (message.code) {
      // Connected
      case 0:
        // Create Client and Initialize Process
        _currentProcess = new Process(Client.fromMap(message.data));
        break;
      // Ready
      case 1:
        break;
      // Sending
      case 10:
        // Update Status
        _currentProcess.currentStage = SonarStage.SENDING;

        // Set Map
        Map map = message.data["receivers"];

        // Check Null
        if (map.values.length != 0) {
          add(Update(map: Circle.fromMap(map, _lastDirection, true)));
        } else {
          add(Update(map: Circle.fromMap(null, _lastDirection, true)));
        }
        break;
      // Receiving
      case 20:
        // Update Status
        _currentProcess.currentStage = SonarStage.RECEIVING;

        // Set Map
        Map map = message.data["senders"];

        // Check Null
        if (map.values.length != 0) {
          add(Update(map: Circle.fromMap(map, _lastDirection, false)));
        } else {
          add(Update(map: Circle.fromMap(null, _lastDirection, false)));
        }
        break;
      default:
    }
  }

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

    // Connect to WS Join/Create Lobby
    // _sonarRepository.initializeSonar(fakeLocation, fakeProfile);

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
          currentDirection: _lastDirection,
          closestMatch: sendEvent.map.closestMatch);
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
          currentDirection: _lastDirection,
          closestMatch: receiveEvent.map.closestMatch);
    } else {
      yield Receiving(currentMotion: motion, currentDirection: _lastDirection);
    }
  }

// ********************
// ** Update Event ***
// ********************
  Stream<SonarState> _mapUpdateToState(
      Update updateEvent, Direction direction, Motion motion) async* {
    if (updateEvent.map.sender) {
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
      // _sonarRepository.setSending(compareDirections.newDirection);
    }
    // Receive State
    else if (_currentMotion.state == Orientation.LandscapeLeft ||
        _currentMotion.state == Orientation.LandscapeRight) {
      // Update State
      // _sonarRepository.setReceiving(compareDirections.newDirection);
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
