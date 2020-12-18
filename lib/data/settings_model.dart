import 'package:geolocator/geolocator.dart';
import 'package:sonr_core/sonr_core.dart';
import 'dart:convert';

// ** Current Device User Model **
class Settings {
  // ^ Properties ^
  final String username;
  final List<SettingItem> items;

  // Get User Position
  Future<Position> get position =>
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  // Default Constructer
  Settings(this.username, this.items);

  // ^ Method Constructs Profile from JSON String ^
  factory Settings.fromJson(String jsonData) {
    // Initialize
    var map = json.decode(jsonData);
    Settings p = new Settings(map["username"], map["items"]);
    return p;
  }

  // ^ Method converts Profile to JSON String ^
  String toJson() {
    var map = {
      "username": this.username,
      "items": this.items,
    };
    return json.encode(map);
  }
}

class SettingItem {
  final String name;
  final bool isActive;
  final String value;

  SettingItem(this.name, {this.isActive, this.value});

  // ^ Method Constructs Profile from JSON String ^
  factory SettingItem.fromJson(String jsonData) {
    // Initialize
    var map = json.decode(jsonData);
    SettingItem si = new SettingItem(map["name"],
        isActive: map["active"], value: map["value"]);
    return si;
  }

  // ^ Method converts Profile to JSON String ^
  String toJson() {
    var map = {
      "name": this.name,
      "active": this.isActive,
      "value": this.value,
    };
    return json.encode(map);
  }
}
