import 'package:geolocator/geolocator.dart' as Pkg;
import 'package:sonr_core/sonr_core.dart';
import 'dart:convert';

// ******************************* //
// ** Current Device User Model ** //
// ******************************* //
class User {
  // ^ Properties ^
  final String username;
  Contact contact;
  List<SettingsItem> settings = <SettingsItem>[];

  // Get User Position
  Future<Pkg.Position> get position => Pkg.Geolocator.getCurrentPosition(desiredAccuracy: Pkg.LocationAccuracy.high);

  // Default Constructer
  User(this.contact, this.username, {this.settings});

  // ^ Method Constructs Profile from JSON String ^
  factory User.fromJson(String jsonData) {
    // Initialize
    User user;
    var map = json.decode(jsonData);

    // Decode settings
    if (map["settings"] != null) {
      // Decode Settings
      List<String> itemsJson = map["settings"];
      var settings = <SettingsItem>[];
      itemsJson.forEach((i) {
        settings.add(SettingsItem.fromJson(i));
      });

      // Set User
      user = new User(Contact.fromJson(map["contact"]), map["username"], settings: settings);
    } else {
      user = new User(Contact.fromJson(map["contact"]), map["username"]);
    }

    return user;
  }

  // ^ Method converts Profile to JSON String ^
  String toJson() {
    // Convert Items to Json based on length
    if (this.settings != null) {
      var settingsJson = <String>[];
      this.settings.forEach((i) {
        settingsJson.add(i.toJson());
      });

      var map = {
        "contact": this.contact.writeToJson(),
        "username": this.username,
        "settings": settingsJson,
      };
      return json.encode(map);
    }
    // No user settings
    else {
      var map = {
        "contact": this.contact.writeToJson(),
        "username": this.username,
      };
      return json.encode(map);
    }
  }
}

// ***************************** //
// ** Current Device Settings ** //
// ***************************** //
// TODO: Name should be enum //
class SettingsItem {
  final String name;
  final bool isActive;
  final String value;

  SettingsItem(this.name, {this.isActive, this.value});

  // ^ Method Constructs SettingItem from JSON String ^
  factory SettingsItem.fromJson(String jsonData) {
    // Initialize
    var map = json.decode(jsonData);
    SettingsItem si = new SettingsItem(map["name"], isActive: map["active"], value: map["value"]);
    return si;
  }

  // ^ Method converts SettingItem to JSON String ^
  String toJson() {
    var map = {
      "name": this.name,
      "active": this.isActive,
      "value": this.value,
    };
    return json.encode(map);
  }
}
