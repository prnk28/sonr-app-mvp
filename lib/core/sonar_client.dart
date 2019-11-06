// Import Utilities
import '../core/sonar_ws.dart';
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

  // Initialize
  SonarClient() {
    // WS Setup
    ws = new WSClient();

    // Utilities Setup
    location = new LocationUtility();
    time = new TimeUtility();
  }

  // Getter/Setter Variables
  String get wsID {
    return _websocketsID;
  }

  set wsID(String clientWsID) {
    _websocketsID = clientWsID;
  }

  SonarState get wsStatus {
    return _currentState;
  }

  set wsStatus(SonarState clientWsStatus) {
    // Set New State
    _currentState = clientWsStatus;
  }
}
