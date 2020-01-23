// Import Utilities
import 'package:geolocator/geolocator.dart';
import 'package:sonar_app/models/models.dart';

import '../core/sonar_ws.dart';
import '../utils/utils.dart';

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
  Direction _currentDirectionModel;

  // Initialize
  SonarClient() {
    // WS Setup
    ws = new WSClient();

    // Utilities Setup
    location = new LocationUtility();
    time = new TimeUtility();
  }

// Current Device Direction
  Direction get currentDirection {
    return _currentDirectionModel;
  }

  set currentDirection(Direction currDir) {
    // Set New State
    _currentDirectionModel = currDir;
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
