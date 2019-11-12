// Import Utilities
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
    return _currentLocationModel;
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
  }
}
