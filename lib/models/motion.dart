import 'package:equatable/equatable.dart';
import 'package:sensors/sensors.dart';
import 'package:sonar_app/core/sonar_client.dart';

class Motion extends Equatable {
  // *******************
  // ** Sensor Values **
  // *******************
  // Accelerometer
  final double accelX;
  final double accelY;
  final double accelZ;

  // Interpreted Values
  final SonarState state;
  final DateTime lastUpdated;

  // *********************
  // ** Constructor Var **
  // *********************

  const Motion({
    this.accelX,
    this.accelY,
    this.accelZ,
    this.state,
    this.lastUpdated,
  });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
        accelX,
        accelY,
        accelZ,
        state,
        lastUpdated,
      ];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Motion create({AccelerometerEvent a}) {
    // Both Events Provided
    if (a != null) {
// Return Object
      return Motion(
          accelX: a.x,
          accelY: a.y,
          accelZ: a.z,
          state: _getStateFromAccelerometer(a.x, a.y),
          lastUpdated: DateTime.now());
    }
    // No Data Provided
    else {
// Return Blank Object
      return Motion(
          accelX: 0,
          accelY: 0,
          accelZ: 0,
          state: SonarState.ZERO,
          lastUpdated: DateTime.now());
    }
  }

  static SonarState _getStateFromAccelerometer(double x, double y) {
    // Set Sonar State by Accelerometer
    if (x > 7.5 || x < -7.5) {
      return SonarState.RECEIVE;
    } else {
      // Detect Position for Zero and Send
      if (y > 4.1) {
        return SonarState.ZERO;
      } else {
        return SonarState.SEND;
      }
    }
  }

  // *********************
  // ** JSON Conversion **
  // *********************
  // Generation Method
  toJSON() {
    return {
      'state': state,
      'accelX': accelX,
      'accelY': accelY,
      'accelZ': accelZ,
      'last_updated': lastUpdated
    };
  }
}
