
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sonar_frontend/model/profile_model.dart';
import 'package:uuid/uuid.dart';

class MatchTransaction {
  // Paramaters
  final Position position;
  final ProfileModel userData;
  var _uuid = new Uuid();
  var documentID;
  var transactionID;

  // Initialization
  MatchTransaction(this.userData, this.position){
    documentID = _uuid.v4();
  }

  // Generation Method
  createTransaction() {
    // Create Map
    var map = {
      'created': DateTime.now().toString(),
      'longitude': position.longitude,
      'latitude' : position.latitude,
      'documentID': documentID,
      'userData' : userData.toJSONEncodable()
    };

    return map;
  }
}