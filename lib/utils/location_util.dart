// Remote Packages
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';

// Local Classes
import '../core/sonar_client.dart';
import '../models/models.dart';

class LocationUtility {
  // Check Location Permissions
  static checkLocationPermission() async {
    if (await Geolocator().checkGeolocationPermissionStatus() ==
        GeolocationStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  // Check State by Position
  static getSonarState(List<double> _accelerometerValues) {
    if (_accelerometerValues[0] > 7.5 || _accelerometerValues[0] < -7.5) {
      return SonarState.RECEIVE;
    } else {
      // Detect Position for Zero and Send
      if (_accelerometerValues[1] > 4.1) {
        return SonarState.ZERO;
      } else {
        return SonarState.SEND;
      }
    }
  }
}
