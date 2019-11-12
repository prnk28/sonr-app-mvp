// Remote Packages
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';

// Local Classes
import '../core/sonar_client.dart';
import '../model/location_model.dart';
import '../model/direction_model.dart';

class LocationUtility {
  // Check Location Permissions
  checkLocationPermission() async {
    if (await Geolocator().checkGeolocationPermissionStatus() ==
        GeolocationStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  // Check State by Position
  checkDevicePosition(List<double> _accelerometerValues) {
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

  // Get Direction Data
  currentDirection() async {
    var lastDirection = await FlutterCompass.events.last;
    return lastDirection;
  }

  // Get Direction Model
  currentDirectionModel() async {
    // Get Data
    double dir = await currentDirection();

    // Create Object
    return DirectionModel(dir);
  }

  // Get Location Data
  currentLocation() async {
    var p = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return p;
  }

  // Get Location Model
  currentLocationModel() async {
    // Get Data
    Position p = await currentLocation();
    Placemark m = await placemarkFromPosition(p);

    // Create Object
    return LocationModel(p, m);
  }

  // Generate PlaceMark from Given Position
  placemarkFromPosition(Position p) async {
    List<Placemark> placemarks =
        await Geolocator().placemarkFromCoordinates(p.latitude, p.longitude);
    // Check Placemark Validity
    if (placemarks != null && placemarks.isNotEmpty) {
      var m = placemarks[0];
      return m;
    }
  }
}
