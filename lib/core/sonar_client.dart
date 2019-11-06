// Import Utilities
import '../core/sonar_ws.dart';
import '../utils/location_util.dart';
import '../utils/time_util.dart';

SonarClient sonar = new SonarClient();

class SonarClient {
  // Variables
  WSClient ws;
  LocationUtility location;
  TimeUtility time;

  // Initialize
  SonarClient() {
    // WS Setup
    ws = new WSClient();

    // Utilities Setup
    location = new LocationUtility();
    time = new TimeUtility();
  }

  // WebSockets Info
  String websocketsID;

  // Getter/Setter Variables
  String get wsID {
    return websocketsID;
  }

  set wsID(String clientWsID) {
    websocketsID = clientWsID;
  }
}
