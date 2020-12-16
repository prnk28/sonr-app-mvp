import 'package:sonr_core/sonr_core.dart';
import 'dart:convert';

// ** Current Device User Model **
class User {
  // ^ Properties ^
  Contact contact;
  String username;

  // Default Constructer
  User(this.contact);

  // ^ Method Constructs Profile from JSON String ^
  static User fromJson(String jsonData) {
    // Initialize
    var map = json.decode(jsonData);
    User p = new User(Contact.fromJson(map["contact"]));
    return p;
  }

  // ^ Method converts Profile to JSON String ^
  String toJson() {
    var map = {"contact": this.contact.writeToJson()};
    return json.encode(map);
  }
}
