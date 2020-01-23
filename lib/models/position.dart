import 'package:sensors/sensors.dart';
import 'package:sonar_app/core/sonar_client.dart';

class PositionModel {
  // *********************
  // ** Constructor Var **
  // *********************
  final AccelerometerEvent accelerometerEvent;
  final GyroscopeEvent gyroscopeEvent;

  // *********************
  // ** Sonar State  *****
  // *********************
  final SonarState state;

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

  PositionModel(this.accelerometerEvent, this.gyroscopeEvent, this.state) {
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
