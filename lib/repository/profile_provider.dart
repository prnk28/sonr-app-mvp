import 'package:flutter/widgets.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// ** Wraps Around SharedPreferences to Retreive User Basic Info  **
class Profile {
  // ^ Properties ^
  Contact contact;
  String platform;

  // Default Constructer
  Profile();

  // ^ Method that checks profile existence, returns if contains otherwise returns false ^
  static Future<Profile> get() async {
    // @ Get SharedPreferences Instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // @ Check for Profile
    if (prefs.containsKey("profile")) {
      // Get Json Value
      var profileJson = prefs.getString("profile");
      print("Stored Profile: " + profileJson);

      // Get Profile object
      return Profile.fromJson(profileJson);
    }
    return null;
  }

  // ^ Method Constructs Profile ^
  static Future<Profile> create(Contact contact, BuildContext context) async {
    // Initialize
    Profile p = new Profile();

    // Set Contact
    p.contact = contact;

    // Save in SharedPreferences Instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("profile", p.toJson());
    return p;
  }

  // ^ Method Constructs Profile from JSON String ^
  static Future<Profile> fromJson(String jsonData) async {
    // Initialize
    var map = json.decode(jsonData);
    Profile p = new Profile();

    // Set Device
    p.platform = map["platform"];

    // Set Contact
    p.contact = Contact.fromJson(map["contact"]);

    // Save in SharedPreferences Instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("profile", p.toJson());
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
