import 'package:sonar_app/utils/utils.dart';
import 'package:equatable/equatable.dart';

class Location extends Equatable {
  // *********************
  // ** POSITIONAL DATA **
  // *********************
  final double accuracy;
  final double altitude;
  final double direction; // Known as Heading
  final double latitude;
  final double longitude;

  // PLACEMARK DATA
  final String address;
  final String city; // Known as Sub-Admin
  final String country;
  final String locality;
  final String neighborhood; // Known as Sub-Locality
  final String state; // Known as Admin
  final String street; // Known as Name

  // *********************
  // ** Constructor Var **
  // *********************
  const Location(
      {
      // Position Data
      this.accuracy,
      this.altitude,
      this.direction,
      this.latitude,
      this.longitude,

      // Placemark Data
      this.address,
      this.city,
      this.country,
      this.locality,
      this.neighborhood,
      this.state,
      this.street});

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
        // Position Data
        accuracy,
        altitude,
        direction,
        latitude,
        longitude,

        // Placemark Data
        address,
        city,
        country,
        locality,
        neighborhood,
        state,
        street
      ];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Location create(Position pos, Placemark mark) {
    // Check if Position is Valid
    return Location(
      accuracy: pos.accuracy,
      altitude: pos.altitude,
      direction: pos.heading,
      latitude: pos.latitude,
      longitude: pos.longitude,
      city: mark.subAdministrativeArea,
      country: mark.country,
      locality: mark.locality,
      neighborhood: mark.subAdministrativeArea,
      state: mark.administrativeArea,
      street: mark.locality,
    );
  }

  // *********************
  // ** JSON Conversion **
  // *********************
  toJSON() {
    return {
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
  }
}
