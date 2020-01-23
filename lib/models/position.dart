import 'package:sensors/sensors.dart';
import 'package:sonar_app/core/sonar_client.dart';

class Position {
  // *********************
  // ** Constructor Var **
  // *********************
  final AccelerometerEvent accelerometerEvent;
  final GyroscopeEvent gyroscopeEvent;

  // *********************
  // ** Sonar State  *****
  // *********************
  SonarState state;

  // *******************
  // ** Sensor Values **
  // *******************
  // Accelerometer
  double accelX;
  double accelY;
  double accelZ;
  List<double> accelData = new List();

  // Gyroscope
  double gyroX;
  double gyroY;
  double gyroZ;
  List<double> gyroData = new List();

  Position(this.accelerometerEvent, this.gyroscopeEvent) {
    // Set Accelerometer Positional Data
    accelX = accelerometerEvent.x;
    accelY = accelerometerEvent.y;
    accelZ = accelerometerEvent.z;
    accelData = [accelX, accelY, accelZ];

    // Set Gyroscope Positional Data
    gyroX = gyroscopeEvent.x;
    gyroY = gyroscopeEvent.y;
    gyroZ = gyroscopeEvent.z;
    gyroData = [gyroX, gyroY, gyroZ];

    // Set Sonar State by Accelerometer
    if (accelX > 7.5 || accelX < -7.5) {
      state = SonarState.RECEIVE;
    } else {
      // Detect Position for Zero and Send
      if (accelY > 4.1) {
        state = SonarState.ZERO;
      } else {
        state = SonarState.SEND;
      }
    }
  }

  // Generation Method
  toJSON() {
    return {
      'state': state,
      'accelX': accelX,
      'accelY': accelY,
      'accelZ': accelZ,
      'gyroX': gyroX,
      'gyroY': gyroY,
      'gyroZ': gyroZ,
    };
  }
}
