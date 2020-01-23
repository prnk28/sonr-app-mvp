import 'dart:async';

import 'package:sonar_app/core/sonar_client.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sensors/sensors.dart';

class PositionRepository {

  getPosition(){
    
  }

  _getDeviceState(Position position){
    // Set Sonar State by Accelerometer
    if (position.accelX > 7.5 || position.accelX < -7.5) {
      return SonarState.RECEIVE;
    } else {
      // Detect Position for Zero and Send
      if (position.accelY > 4.1) {
        return SonarState.ZERO;
      } else {
        return SonarState.SEND;
      }
    }
  }
}