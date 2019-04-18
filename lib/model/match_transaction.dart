import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sonar_frontend/model/profile_model.dart';
import 'package:sonar_frontend/utils/location_util.dart';
import 'package:uuid/uuid.dart';

class MatchTransaction {
  // Paramaters
  final LocationData position;
  final ProfileModel userData;
  //final Placemark placemark;
  var documentID;

  // Initialization
  MatchTransaction(this.userData, this.position){
    var _uuid = new Uuid();
    documentID = _uuid.v4();
  }

  // Generation Method
  toJSONEncodable() {
    // Create Map
    var map = {
      'created': DateTime.now().toString(),
      'longitude': position.longitude,
      'latitude' : position.latitude,
      'documentID': documentID,
      'userData' : userData.toJSONEncodable(),
      'message' : _generateMessage()
    };

    return map;
  }

  // Create Message
  _generateMessage(){
    // Get Data
    var dayPart = _partOfDay();
    var yearPart = DateFormat("MMMMd").format(DateTime.now());
    // Message Outline
    return " and you met on the " + dayPart + " of "
     + yearPart + " at " + placemark.subLocality + ".";
  }
}