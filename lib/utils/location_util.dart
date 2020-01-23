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

  // Get Direction Data
  static currentDirection() async {
    var lastDirection = await FlutterCompass.events.last;
    return lastDirection;
  }

  static Future<LocationModel> getCurrentLocation() async {
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

  // Generate PlaceMark from Given Position
  static getPlacemarkFromPosition(Position p) {
    // Await for List of Placemarks
    Geolocator().placemarkFromCoordinates(p.latitude, p.longitude).then(
        (placemarkList) {
      // Check Placemark Validity
      if (placemarkList != null && placemarkList.isNotEmpty) {

        // Return Placemark
        return placemarkList[0];
      } else {
        // No Placemark
        return null;
      }
    },
    // Error Finding Placemark
    onError: (error) {
      print(error);
      return null;
    });
  }

  // Creates Readable Address
  static getAddressString(Placemark placemark) {
    final String name = placemark.name ?? '';
    final String city = placemark.locality ?? '';
    final String state = placemark.administrativeArea ?? '';
    final String country = placemark.country ?? '';

    return '$name, $city, $state, $country';
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
