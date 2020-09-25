import 'package:hive/hive.dart';
import 'package:sonar_app/models/models.dart';

class LocalData {
  // ** -- Class Constants -- **
  static const String CONTACT_BOX = "contactBox";
  static const String FILE_BOX = "fileBox";
  static const String PREFERENCES_BOX = "preferencesBox";
  static const String PROFILE_BOX = "profileBox";

  // ** -- Class Constructer -- **
  LocalData() {
    Hive.registerAdapter(ProfileAdapter());
  }

  // ******************************** //
  // ** Add/Update Persistent Data ** //
  // ******************************** //
  Future<void> addContact(Map contact) async {
    var box = await Hive.openBox(CONTACT_BOX);

    box.put(contact["id"], contact);

    print('Contact: ${box.get(contact["id"])}');

    await box.close();
  }

  Future<void> addFileMetadata(Map fileMetadata) async {
    var box = await Hive.openBox(FILE_BOX);

    box.put(fileMetadata["id"], fileMetadata);

    print('FileMetadata: ${box.get(fileMetadata["id"])}');

    await box.close();
  }

  Future<void> updatePreferences(Map preferences) async {
    var box = await Hive.openBox(PREFERENCES_BOX);

    box.put("preferences", preferences);

    print('Preferences: ${box.get("preferences")}');

    await box.close();
  }

  Future<void> updateProfile(Profile profile) async {
    var box = await Hive.openBox(PROFILE_BOX);

    box.put("profile", profile);

    print('Profile: ${box.get("profile")}');

    await box.close();
  }

  // ****************************** //
  // ** Retrieve Persistent Data ** //
  // ****************************** //
  Future<Map> getContact(String id) async {
    var box = await Hive.openBox(CONTACT_BOX);

    return box.get(id);
  }

  Future<Map> getFileMetadata(String id) async {
    var box = await Hive.openBox(FILE_BOX);

    return box.get(id);
  }

  Future<Map> getPreferences() async {
    var box = await Hive.openBox(PREFERENCES_BOX);

    return box.get("preferences", defaultValue: {});
  }

  Future<Map> getProfile() async {
    var box = await Hive.openBox(PROFILE_BOX);

    return box.get("profile", defaultValue: {});
  }

  // **************************** //
  // ** Delete Persistent Data ** //
  // **************************** //
  Future<void> clearPreferences() async {
    var box = await Hive.openBox(PREFERENCES_BOX);

    // Clear Existing Settings
    box.delete("preferences");

    await box.close();
  }

  Future<void> clearProfile() async {
    var box = await Hive.openBox(PROFILE_BOX);

    // Clear Existing Profile
    box.delete("profile");

    await box.close();
  }

  Future<void> deleteContact(String id) async {
    var box = await Hive.openBox(CONTACT_BOX);

    // Delete by ID
    box.delete(id);

    await box.close();
  }

  Future<void> deleteFileMetadata(String id) async {
    var box = await Hive.openBox(FILE_BOX);

    // Delete by ID
    box.delete(id);

    await box.close();
  }
}
