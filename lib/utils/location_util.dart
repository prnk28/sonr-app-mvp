// Remote Packages
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';

// Local Classes
import '../core/sonar_client.dart';
import '../model/location_model.dart';
import '../model/direction_model.dart';

class LocationUtility {
  // Check Location Permissions
  checkLocationPermission() async {
    if (await Geolocator().checkGeolocationPermissionStatus() ==
        GeolocationStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  // Check State by Position
  checkDevicePosition(List<double> _accelerometerValues) {
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

  // Get Direction Data
  currentDirection() async {
    var lastDirection = await FlutterCompass.events.last;
    return lastDirection;
  }

  // Get Direction Model
  currentDirectionModel() async {
    // Get Data
    double dir = await currentDirection();

    // Create Object
    return DirectionModel(dir);
  }

  getCurrentLocation() {
    // Await for current Position
    _getCurrentLocationFuture().then((model) {
      return model;
    });
  }

  Future<LocationModel> _getCurrentLocationFuture() async {
    // Get Current Position
    Position currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .catchError((error) {
      print(error);
    });

    // Get Current Placemark
    List<Placemark> placemarkList = await Geolocator()
        .placemarkFromCoordinates(
            currentPosition.latitude, currentPosition.longitude)
        .catchError((error) {
      print(error);
    });

    // Check Placemark Validity
    if (placemarkList != null && placemarkList.isNotEmpty) {
      // Return Placemark
      // Return
    return LocationModel(currentPosition, placemarkList[0]);
    } else {
      // No Placemark
      return LocationModel(currentPosition, null);
    }
  }

  // Creates Readable Address
  generateAddressString(Placemark placemark) {
    final String name = placemark.name ?? '';
    final String city = placemark.locality ?? '';
    final String state = placemark.administrativeArea ?? '';
    final String country = placemark.country ?? '';

    return '$name, $city, $state, $country';
  }
}
