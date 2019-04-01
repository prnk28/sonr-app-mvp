import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
// Class Used to Create Strings
// Utilized in Profile_info widget

String getGreeting(String name){
  var firstname = name.split(" ");
  return "Hello, " + firstname[0] + ".";
}

String getTodayDate(){
   var now = new DateTime.now();
  var formatter = new DateFormat('LLLL dd, yyyy');
  return formatter.format(now);
}

Future<String> getCurrentLocation() async {
  if (await Geolocator().checkGeolocationPermissionStatus() ==
        GeolocationStatus.granted) {
      var position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.longitude, position.latitude);
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