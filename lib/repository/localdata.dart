import 'repository.dart';
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

// ********************************
// ** Read Local Data of Assets ***
// ********************************
  Future<Uint8List> getBytesFromPath(String path) async {
    Uri myUri = Uri.parse(path);
    File audioFile = new File.fromUri(myUri);
    Uint8List bytes;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      log.i('reading of bytes is completed');
    }).catchError((onError) {
      log.w('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes;
  }

// ****************************************
// ** Get File Object from Assets Folder **
// ****************************************
  Future<File> getAssetFileByPath(String path) async {
    // Get Application Directory
    Directory directory = await getApplicationDocumentsDirectory();

    // Get File Extension and Set Temp DB Extenstion
    var dbPath = join(directory.path, "temp" + extension(path));

    // Get Byte Data
    ByteData data = await rootBundle.load(path);

    // Get Bytes as Int
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Return File Object
    return await File(dbPath).writeAsBytes(bytes);
  }
}
