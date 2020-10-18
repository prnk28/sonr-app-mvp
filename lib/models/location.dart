import 'package:sonar_app/core/core.dart';

class Location {
  // ** Class Variables **
  Position position;
  String olc;

  // ** Faux Constructor **
  static initialize() async {
    Location loc;
    // Get Current Position
    loc.position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // Get OLC
    loc.olc = OLC.encode(loc.position.latitude, loc.position.longitude);
  }

  // ** Method to Create Map **
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
  }
}
