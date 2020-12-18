import 'dart:convert';

// ** Current Device Settings **
class Settings {
  // ^ Properties ^
  final String username;
  final List<SettingItem> items;

  // Default Constructer
  Settings(this.username, {this.items});

  // ^ Method Constructs Settings from JSON String ^
  factory Settings.fromJson(String jsonData) {
    // Initialize
    var map = json.decode(jsonData);

    // Decode Items
    List<String> itemsJson = map["items"];
    var itemsList = <SettingItem>[];
    itemsJson.forEach((i) {
      itemsList.add(SettingItem.fromJson(i));
    });

    // Return Object
    Settings p = new Settings(map["username"], items: itemsList);
    return p;
  }

  // ^ Method converts Settings to JSON String ^
  String toJson() {
    // Convert Items to Json
    var itemsJson = <String>[];
    this.items.forEach((i) {
      itemsJson.add(i.toJson());
    });

    // Convert to Json Object
    var map = {
      "username": this.username,
      "items": itemsJson,
    };
    return json.encode(map);
  }
}

// ** An option in Settings ** //
// TODO: Name should be enum //
class SettingItem {
  final String name;
  final bool isActive;
  final String value;

  SettingItem(this.name, {this.isActive, this.value});

  // ^ Method Constructs SettingItem from JSON String ^
  factory SettingItem.fromJson(String jsonData) {
    // Initialize
    var map = json.decode(jsonData);
    SettingItem si = new SettingItem(map["name"],
        isActive: map["active"], value: map["value"]);
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
