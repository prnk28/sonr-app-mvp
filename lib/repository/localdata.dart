import 'repository.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

class LocalData {
  // ******************************** //
  // ** Add/Update Persistent Data ** //
  // ******************************** //
  Future<void> addContact(Contact contact) async {
    var box = await Hive.openBox(CONTACT_BOX);

    box.put(contact.id, contact);

    print('Contact: ${box.get(contact.id)}');

    await box.close();
  }

  Future<void> addFileMetadata(Metadata fileMetadata, FileType type) async {
    var box = await Hive.openBox(FILE_BOX);
    var fileBox = await Hive.openBox(type.toString());

    // Put in All Files and File Type
    box.put(fileMetadata.id, fileMetadata);
    fileBox.put(fileMetadata.id, fileMetadata);

    print('FileMetadata: ${box.get(fileMetadata.id)}');

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
  Future<Contact> getContact(String id) async {
    var box = await Hive.openBox(CONTACT_BOX);
    final contact = box.get(id);

    await box.close();
    return contact;
  }

  Future<Metadata> getFileMetadata(String id) async {
    var box = await Hive.openBox(FILE_BOX);
    final file = box.get(id);
    await box.close();

    return file;
  }

  Future<Iterable<Metadata>> getAllFileMetadata(String id) async {
    var box = await Hive.openBox(FILE_BOX);
    final fileList = box.values;
    await box.close();

    return fileList;
  }

  Future<Iterable<Metadata>> getFileMetadataByType(FileType type) async {
    var box = await Hive.openBox(type.toString());
    final fileList = box.values;
    await box.close();

    return fileList;
  }

  Future<Map> getPreferences() async {
    var box = await Hive.openBox(PREFERENCES_BOX);
    final preferences = box.get("preferences");
    await box.close();

    return preferences;
  }

  Future<Profile> getProfile() async {
    var box = await Hive.openBox(PROFILE_BOX);
    final profile = box.get("profile");
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
