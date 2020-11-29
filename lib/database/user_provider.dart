import 'package:flutter/widgets.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// ** Wraps Around SharedPreferences to Retreive User Basic Info  **
class User {
  // ^ Properties ^
  Contact contact;
  String platform;

  // Default Constructer
  User();

  // ^ Method that checks profile existence, returns if contains otherwise returns false ^
  static Future<User> get() async {
    // @ Get SharedPreferences Instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // @ Check for Profile
    if (prefs.containsKey("user")) {
      // Get Json Value
      var profileJson = prefs.getString("user");

      // Get Profile object
      return User.fromJson(profileJson);
    }
    return null;
  }

  // ^ Method Constructs Profile ^
  static Future<User> create(Contact contact, BuildContext context) async {
    // Initialize
    User p = new User();

    // Set Contact
    p.contact = contact;

    // Save in SharedPreferences Instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", p.toJson());
    return p;
  }

  // ^ Method Constructs Profile from JSON String ^
  static Future<User> fromJson(String jsonData) async {
    // Initialize
    var map = json.decode(jsonData);
    User p = new User();

    // Set Values
    p.platform = map["platform"];
    p.contact = Contact.fromJson(map["contact"]);

    // Save in SharedPreferences Instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", p.toJson());
    return p;
  }

  // ^ Method converts Profile to JSON String ^
  String toJson() {
    var map = {
      "contact": this.contact.writeToJson(),
      "platform": this.platform
    };
    return json.encode(map);
  }
}
