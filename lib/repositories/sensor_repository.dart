// Get Device Compass Direction
import 'package:sensors/sensors.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

class SensorRepository {

  getPosition() {
    
  }

  getDeviceState(AccelerometerEvent position){
    // Set Sonar State by Accelerometer
    if (position.x > 7.5 || position.x < -7.5) {
      return SonarState.RECEIVE;
    } else {
      // Detect Position for Zero and Send
      if (position.y > 4.1) {
        return SonarState.ZERO;
      } else {
        return SonarState.SEND;
      }
    }
  }
}