import 'package:sonar_app/utils/utils.dart';
class LocationModel {
  // INITIAL Data
  final Position position;
  final Placemark placemark;

  // POSITIONAL DATA
  // ===============
  double accuracy;
  double altitude;
  double direction; // Known as Heading
  double latitude;
  double longitude;
  bool positionValid;

  // PLACEMARK DATA
  // ==============
  String address;
  String city; // Known as Sub-Admin
  String country;
  String locality;
  String neighborhood; // Known as Sub-Locality
  String state; // Known as Admin
  String street; // Known as Name
  bool placemarkValid;

  // Constructor
  LocationModel(this.position, this.placemark) {
    // Check if Position is Valid
    if (position != null) {
      accuracy = position.accuracy;
      altitude = position.altitude;
      direction = position.heading;
      latitude = position.latitude;
      longitude = position.longitude;
      positionValid = true;

    // Position Unavailible
    } else {
      accuracy = 0;
      altitude = 0;
      direction = 0;
      latitude = 0;
      longitude = 0;
      positionValid = false;
    }

    // Check if Placemark is Valid
    if (placemark != null) {
      // Create Readable Address
      address = LocationUtility.getAddressString(placemark);

      // Set Placemark Data
      city = placemark.subAdministrativeArea;
      country = placemark.country;
      locality = placemark.locality;
      neighborhood = placemark.subAdministrativeArea;
      state = placemark.administrativeArea;
      street = placemark.locality;
      placemarkValid = true;

      // Placemark Unavailible
    } else {
      address = "N/A";
      city = "N/A";
      country = "N/A";
      locality = "N/A";
      neighborhood = "N/A";
      state = "N/A";
      street = "N/A";
      placemarkValid = false;
    }
    print(this.toJSON());
  }

  // JSON Generation
  toJSON() {
    var map;
    // Check Validity
    if (positionValid && placemarkValid) {
      map = {
        // Status
        'status': 'FULL',

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
    } else if (positionValid && !placemarkValid) {
      map = {
        // Status
        'status': 'POSITION-ONLY',

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
    } else {
      map = {
        // Status
        'status': 'UNAVAILIBLE',

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

    // Return Map
    return map;
  }
}
