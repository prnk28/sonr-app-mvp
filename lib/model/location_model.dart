import 'package:geolocator/geolocator.dart';

class LocationModel {
  // INITIAL Data
  final Position position;
  final Placemark mark;

  // POSITIONAL DATA
  // ===============
  double accuracy;
  double altitude;
  double direction; // Known as Heading
  double latitude;
  double longitude;

  // PLACEMARK DATA
  // ==============
  String address;
  String city; // Known as Sub-Admin
  String country;
  String locality;
  String neighborhood; // Known as Sub-Locality
  String state; // Known as Admin
  String street; // Known as Name

  // Constructor
  LocationModel(this.position, this.mark) {
    // Create Readable Address
    address = _generateAddressString(mark);

    // Set Variables
    accuracy = position.accuracy;
    altitude = position.altitude;
    direction = position.heading;
    latitude = position.latitude;
    longitude = position.longitude;
    city = mark.subAdministrativeArea;
    country = mark.country;
    locality = mark.locality;
    neighborhood = mark.subAdministrativeArea;
    state = mark.administrativeArea;
    street = mark.locality;
  }

  // JSON Generation
  toJSON() {
    var map = {
      // Position
      'accuracy': accuracy,
      'altitude': altitude,
      'direction': direction,
      'latitude': latitude,
      'longitude': longitude,

      // Placemark
      'address': address,
      'city': city,
      'country': country,
      'locality': locality,
      'neighborhood': neighborhood,
      'state': state,
      'street': street,
    };
    return map;
  }

  // Creates Readable Address
  _generateAddressString(Placemark placemark) {
    final String name = placemark.name ?? '';
    final String city = placemark.locality ?? '';
    final String state = placemark.administrativeArea ?? '';
    final String country = placemark.country ?? '';

    return '$name, $city, $state, $country';
  }
}
