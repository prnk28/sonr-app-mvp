import 'dart:async';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';

class SensorProvider {
  // Stream of Accelerometer Movement
  Stream<AccelerometerEvent> motion() {
    return accelerometerEvents;
  }

  // Stream of Compass Direction
  Stream<double> direction() {
    return FlutterCompass.events;
  }

  // Stream of Location Change
  Stream<Position> location() {
    // Stream Options
    const LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 10);
    
    // Return Stream
    return Geolocator().getPositionStream(locationOptions);
  }

  // Current Location
  Future<Position> currentLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }
}
