import 'package:geolocator/geolocator.dart';

class LocationUtility {
  // Get Location Data
  static createLocationData() async {
    // Get Data
    Position p = await currentPosition();
    Placemark m = await placemarkFromPosition(p);

    // Create Object
   return LocationData.fromData(p, m);
  }

  // Get Positional Data
  static currentPosition() async {
      var p = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return p;
  }

  // Generate PlaceMark from Given Position
  static placemarkFromPosition(Position p) async {
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(p.latitude, p.longitude);
    // Check Placemark Validity
    if (placemarks != null && placemarks.isNotEmpty) {
      var m = placemarks[0];
      return m;
    }
  }

  // Check Location Permissions
  static activeLocationPermission() async {
    if (await Geolocator().checkGeolocationPermissionStatus() ==
        GeolocationStatus.granted) {
          return true;
    }else{
      return false;
    }
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

  // Create Location Data Object
  factory LocationData.fromData(Position pos, Placemark mrk) {
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
      var ks = k.toString();
      var vs = v.toString();
      print("LOCATION DATA = " + ks + " : " + vs);
    });
  }
}