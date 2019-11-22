// Import Utilities
import 'package:geolocator/geolocator.dart';
import 'package:sonar_frontend/model/location_model.dart';

import '../core/sonar_ws.dart';
import '../model/direction_model.dart';
import '../model/location_model.dart';
import '../utils/location_util.dart';
import '../utils/time_util.dart';

SonarClient sonar = new SonarClient();

enum SonarState { ZERO, SEND, SEND_SEARCH, RECEIVE, RECEIVE_SEARCH }

class SonarClient {
  // Properties
  WSClient ws;
  LocationUtility location;
  TimeUtility time;

  // Variables
  String _websocketsID;
  SonarState _currentState;
  DirectionModel _currentDirectionModel;
  LocationModel _currentLocationModel;

  // Initialize
  SonarClient() {
    // WS Setup
    ws = new WSClient();

    // Utilities Setup
    location = new LocationUtility();
    time = new TimeUtility();

    // Set Location
    currentLocation = location.getCurrentLocation();
  }

// Current Device Direction
  DirectionModel get currentDirection {
    return _currentDirectionModel;
  }

  set currentDirection(DirectionModel currDir) {
    // Set New State
    _currentDirectionModel = currDir;
  }

  // Current Device Location
  LocationModel get currentLocation {
    return location.getCurrentLocation();
  }

  set currentLocation(LocationModel currLoc) {
    // Set New State
    _currentLocationModel = currLoc;
  }

  // WebSockets Client ID
  String get wsID {
    return _websocketsID;
  }

  set wsID(String clientWsID) {
    _websocketsID = clientWsID;
  }

// WebSockets Device Orientation
  SonarState get wsStatus {
    return _currentState;
  }

  set wsStatus(SonarState clientWsStatus) {
    // Set New State
    _currentState = clientWsStatus;

    switch (clientWsStatus) {
      case SonarState.ZERO:
        break;
      case SonarState.SEND:
        ws.msgSend(currentDirection);
        break;
      case SonarState.SEND_SEARCH:
        // TODO: Handle this case.
        break;
      case SonarState.RECEIVE:
        ws.msgReceive(currentDirection);
        break;
      case SonarState.RECEIVE_SEARCH:
        // TODO: Handle this case.
        break;
    }
  }
}
