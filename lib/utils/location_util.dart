import 'package:geolocator/geolocator.dart';

class LocationUtility {
  // Generate PlaceMark
  static placemarkFromLatLon() async {
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);

    // Check Placemark Validity
    if (placemarks != null && placemarks.isNotEmpty) {
      return placemarks[0];
    }
  }

  // Get Positional Data
  static positionFromDevice() async {
      var position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return position;
  }
}

class LocationData {
  // POSITIONAL DATA
  // ===============
  double accuracy;
  double altitude;
  double direction; // Known as Heading
  double latitude;
  double longitude;

  // PLACEMARK DATA
  // ==============
  String city; // Known as Sub-Admin
  String country;
  String locality;
  String neighborhood; // Known as Sub-Locality
  String state; // Known as Admin
  String street; // Known as Name

  // Constructor (11 Parameters)
  LocationData({this.accuracy, this.altitude, this.direction,
  this.latitude, this.longitude, this.city, this.country,
  this.locality, this.neighborhood, this.state, this.street});

  // Create from Current Data
  factory LocationData.currentData() {
    Position pos = LocationUtility.positionFromDevice();
    Placemark mrk = LocationUtility.positionFromDevice();

    // Location Object
    return LocationData(
      accuracy: pos.accuracy,
      altitude: pos.altitude,
      direction: pos.heading,
      latitude: pos.latitude,
      longitude: pos.longitude,
      city: mrk.subAdministrativeArea,
      country: mrk.country,
      locality: mrk.locality,
      neighborhood: mrk.subAdministrativeArea,
      state: mrk.administrativeArea,
      street: mrk.locality,
    );
  }

  // Convert Object to Encodable (11 Parameters)
  toJSONEncodable() {
    var map = {
      // Position
      'accuracy': accuracy,
      'altitude': altitude,
      'direction' : direction,
      'latitude': latitude,
      'longitude' : longitude,

      // Placemark
      'city' : city,
      'country': country,
      'locality': locality,
      'neighborhood' : neighborhood,
      'state': state,
      'street' : street,
    };
    return map;
  }

    // Display Object
  toPrint() {
    var locMap = this.toJSONEncodable();
    locMap.forEach((k,v) {
      print("LOCATION DATA = " + k + " : " + v);
    });
  }
}