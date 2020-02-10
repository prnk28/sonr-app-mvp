import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/models/models.dart';

class LocationRepository {
  // Constructer
  LocationRepository();

  // Get Current Location
  Future<Location> getLocation() async {
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

    // Return Location Object
    return Location.create(currentPosition, placemarkList.first);
  }

  // Readable Address from Placemark
  String getAddress(Placemark placemark) {
    final String name = placemark.name ?? '';
    final String city = placemark.locality ?? '';
    final String state = placemark.administrativeArea ?? '';
    final String country = placemark.country ?? '';

    return '$name, $city, $state, $country';
  }
}
