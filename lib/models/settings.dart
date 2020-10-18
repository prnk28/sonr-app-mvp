import 'package:hive/hive.dart';

// HiveDB Box Name
const SETTINGS_BOX = "preferencesBox";

// ************************
// ** User Settings Model **
// ************************
class Settings extends HiveObject {
  // ** Constructer **
  Settings();

  // ** HiveDB Direct Method: (Update) **
  static Future<void> update(Map preferences) async {
    var box = await Hive.openBox(SETTINGS_BOX);

    box.put("preferences", preferences);

    print('Preferences: ${box.get("preferences")}');

    await box.close();
  }

  // ** HiveDB Direct Method: (Retrieve) **
  static Future<Map> retrieve() async {
    var box = await Hive.openBox(SETTINGS_BOX);
    final preferences = box.get("preferences");
    await box.close();

    return preferences;
  }

  // ** HiveDB Direct Method: (Clear) **
  static Future<void> clear() async {
    var box = await Hive.openBox(SETTINGS_BOX);

    // Clear Existing Settings
    box.delete("preferences");

    await box.close();
  }
}

// ******************
// ** Hive Adapter **
// ******************
// class SettingsAdapter extends TypeAdapter<Settings> {
//   @override
//   final typeId = 2;

//   @override
//   Settings read(BinaryReader reader) {
//     var numOfFields = reader.readByte();
//     var fields = <int, dynamic>{
//       for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Settings(
//       fields[0] as String,
//       fields[1] as String,
//       fields[2] as String,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, Settings obj) {
//     writer
//       ..writeByte(3)
//       ..writeByte(0)
//       ..write(obj.firstName)
//       ..writeByte(1)
//       ..write(obj.lastName)
//       ..writeByte(2)
//       ..write(obj.profilePicture);
//   }
// }
