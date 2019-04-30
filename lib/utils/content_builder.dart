import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonar_frontend/model/contact_model.dart';

enum NamePart { FirstName, LastName }

class ContentBuilder {
  static String getNamePart(NamePart p, m) {
    // Initialization
    var nameData = m.name.split(" ");

    // Verify Model has Data
    if (m != null) {
      switch (p) {
        case NamePart.FirstName:
          // Check if only one name given
          if (nameData[0] != null) {
            return nameData[0];
          }
          return m.name;
        case NamePart.LastName:
          // If no last name return blank
          if (nameData[1] != null) {
            return nameData[1];
          }
          return "";
      }
    } else {
      // If model is empty return dummy text
      switch (p) {
        case NamePart.FirstName:
          return "Firstname";
        case NamePart.LastName:
          return "Lastname";
      }
    }
  }

  static String getPhone(m){
    if (m != null) {
      return m.phone.toString();
    } else {
      return "703-666-5555";
    }
  }

  static String getGreeting(String name) {
    var firstname = name.split(" ");
    return "Hello, " + firstname[0] + ".";
  }

  static String getTodayDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('LLLL dd, yyyy');
    return formatter.format(now);
  }

  static Future<String> getCurrentLocation() async {
    if (await Geolocator().checkGeolocationPermissionStatus() ==
        GeolocationStatus.granted) {
      var position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(position.longitude, position.latitude);
      for (var p in placemark) {
        print("Location: " + p.name);
      }
      return placemark[0].subLocality;
    } else {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationWhenInUse]);
      return "Location Unavailible";
    }
  }
}
