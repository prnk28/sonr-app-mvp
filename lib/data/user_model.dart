import 'package:geolocator/geolocator.dart';
import 'package:sonr_core/sonr_core.dart';
import 'dart:convert';

// ** Current Device User Model **
class User {
  // ^ Properties ^
  final Contact contact;
  final String username;

  // Get User Position
  Future<Position> get position =>
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  // Default Constructer
  User(this.contact, this.username);

  // ^ Method Constructs Profile from JSON String ^
  factory User.fromJson(String jsonData) {
    // Initialize
    var map = json.decode(jsonData);
    User p = new User(Contact.fromJson(map["contact"]), map["username"]);
    return p;
  }

  // ^ Method converts Profile to JSON String ^
  String toJson() {
    var map = {
      "contact": this.contact.writeToJson(),
      "username": this.username
    };
    return json.encode(map);
  }
}

// ** Current Device User Settings **
class Settings {}
