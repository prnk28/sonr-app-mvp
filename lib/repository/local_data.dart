import 'package:hive/hive.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

class LocalData {
  // ** -- Class Constants -- **
  static const String CONTACT_BOX = "contactBox";
  static const String PREFERENCES_BOX = "preferencesBox";
  static const String PROFILE_BOX = "profileBox";

  // File Box's
  static const String FILE_BOX = "fileBox";

  // ** -- Class Constructer -- **
  LocalData() {
    Hive.registerAdapter(ProfileAdapter());
    Hive.registerAdapter(MetadataAdapter());
    Hive.registerAdapter(ContactAdapter());
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

  Future<void> addFileMetadata(Map fileMetadata, FileType type) async {
    var box = await Hive.openBox(FILE_BOX);
    var fileBox = await Hive.openBox(type.toString());

    // Put in All Files and File Type
    box.put(fileMetadata["id"], fileMetadata);
    fileBox.put(fileMetadata["id"], fileMetadata);

    print('FileMetadata: ${box.get(fileMetadata["id"])}');

    await box.close();
    await fileBox.close();
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
    final contact = box.get(id);

    await box.close();
    return contact;
  }

  Future<Map> getFileMetadata(String id) async {
    var box = await Hive.openBox(FILE_BOX);
    final file = box.get(id);
    await box.close();

    return file;
  }

  Future<Iterable> getAllFileMetadata(String id) async {
    var box = await Hive.openBox(FILE_BOX);
    final fileList = box.values;
    await box.close();

    return fileList;
  }

  Future<Iterable> getFileMetadataByType(FileType type) async {
    var box = await Hive.openBox(type.toString());
    final fileList = box.values;
    await box.close();

    return fileList;
  }

  Future<Map> getPreferences() async {
    var box = await Hive.openBox(PREFERENCES_BOX);
    final preferences = box.get("preferences", defaultValue: null);
    await box.close();

    return preferences;
  }

  Future<Map> getProfile() async {
    var box = await Hive.openBox(PROFILE_BOX);
    final profile = box.get("profile", defaultValue: null);
    await box.close();

    return profile;
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
