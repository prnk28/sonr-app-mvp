import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

class Location extends Equatable {
  // *********************
  // ** POSITIONAL DATA **
  // *********************
  final double accuracy;
  final double altitude;
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

    // Create Object from Events
  static Location fromMap(Map data) {
    // Check if Position is Valid
    return Location(
      accuracy: data["accuracy"],
      altitude: data["altitude"],
      latitude: data["latitude"],
      longitude: data["longitude"],
      city: data["city"],
      country: data["country"],
      locality: data["locality"],
      neighborhood: data["neighborhood"],
      state: data["state"],
      street: data["street"],
    );
  }
  
  // Fake Data Method
  static Location fakeLocation() {
    // Create Map
   return Location(
      accuracy: 12345,
			altitude: 123,
			latitude: 123,
			longitude: 800,
			address: "Ex",
			city: "Ex",
			country: "Ex",
			locality: "Ex",
			neighborhood: "Ex",
			state: "Ex",
			street: "Ex"
    );
  }

  // *********************
  // ** JSON Conversion **
  // *********************
  toMap() {
    return {
      // Position
      'accuracy': accuracy,
      'altitude': altitude,
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
