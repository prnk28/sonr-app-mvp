import 'package:equatable/equatable.dart';
import 'package:sensors/sensors.dart';
import 'package:sonar_app/core/core.dart';

class Motion extends Equatable {
  // *******************
  // ** Sensor Values **
  // *******************
  // Accelerometer
  final double accelX;
  final double accelY;
  final double accelZ;

  // Interpreted Values
  final Orientation state;
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
          state: getOrientationFromAccelerometer(a.x, a.y),
          lastUpdated: DateTime.now());
    }
    // No Data Provided
    else {
// Return Blank Object
      return Motion(
          accelX: 0,
          accelY: 0,
          accelZ: 0,
          state: Orientation.Default,
          lastUpdated: DateTime.now());
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
