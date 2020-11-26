import 'package:flutter/widgets.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// ** Wraps Around SharedPreferences to Retreive User Basic Info  **
class Profile {
  // ^ Properties ^
  Contact contact;
  double screenWidth;
  double screenHeight;
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

      // Get Profile object
      return Profile.fromJson(profileJson);
    }
    return null;
  }

  // ^ Method Constructs Profile ^
  static Future<Profile> create(Contact contact, BuildContext context) async {
    // Initialize
    Profile p = new Profile();

    // Set Device
    p.screenWidth = MediaQuery.of(context).size.width;
    p.screenHeight = MediaQuery.of(context).size.height;

    // Set Contact
    p.contact = contact;

    // Save in SharedPreferences Instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("profile", p.toString());
    return p;
  }

  // ^ Method Constructs Profile from JSON String ^
  static Future<Profile> fromJson(String jsonData) async {
    // Initialize
    var map = json.decode(jsonData);
    Profile p = new Profile();

    // Set Device
    p.screenWidth = map["screenWidth"];
    p.screenHeight = map["screenHeight"];
    p.platform = map["platform"];

    // Set Contact
    p.contact = Contact.fromJson(map["contact"]);

    // Save in SharedPreferences Instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("profile", p.toString());
    return p;
  }


  // ^ Method converts Profile to JSON String ^
  String toJson() {
    var map = {
      "contact": this.contact.writeToJson(),
      "screenWidth": this.screenWidth,
      "screenHeight": this.screenHeight,
      "platform": this.platform
    };
    return json.encode(map);
  }
}
