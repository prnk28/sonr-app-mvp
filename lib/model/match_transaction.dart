
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

class MatchTransaction {
  // Paramaters
  final Position position;
  final Map userData;
  var _uuid = new Uuid();
  var documentID;
  var transactionID;

  // Initialization
  MatchTransaction(this.userData, this.position){
    documentID = _uuid.v4();
    transactionID = _uuid.v1();
  }

  // Generation Method
  createTransaction() {
    // Create Map
    var map = {
      'created': DateTime.now(),
      'location': GeoPoint(position.latitude, position.longitude),
      'transactionID': transactionID
    };

    // Add User Data
    map.addAll(userData);
    return map;
  }
}