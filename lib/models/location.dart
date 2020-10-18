import 'package:sonar_app/core/core.dart';

class Location {
  String olc; // Open Location Code
  Position position; // From Geolocator

  // ** Constructer **
  Location(this.olc, this.position);

  // ** Create Location **
  static initialize() async {
    Location loc;
    // Get Current Position
    loc.position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Get OLC
    loc.olc = OLC.encode(loc.position.latitude, loc.position.longitude);
  }

  // ** Return Location from Map **
  static Location fromMap(Map data) {
    // Check if Not Empty
    if (data != null) {
      return new Location(
          data['olc'],
          new Position(
              accuracy: data['accuracy'].toDouble(),
              altitude: data['altitude'].toDouble(),
              latitude: data['latitude'].toDouble(),
              longitude: data['longitude'].toDouble()));
    }
    // Location not in map
    log.e("Location: No data in map");
    return null;
  }

  // ** Convert Object to Map **
  toMap() {
    // Check if Not Empty
    if (this.olc != null && this.position != null) {
      return {
        'olc': this.olc,
        'accuracy': this.position.accuracy.toDouble(),
        'altitude': this.position.altitude.toDouble(),
        'latitude': this.position.latitude.toDouble(),
        'longitude': this.position.longitude.toDouble()
      };
    }
    // Location isnt Initialized
    log.e("Location: Position and OLC not set");
    return null;
  }
}
