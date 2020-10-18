import 'repository.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

// ** HiveDB Box Constants **
const PREFERENCES_BOX = "preferencesBox";
const PROFILE_BOX = "profileBox";

// ******************************** //
// ** Add/Update Persistent Data ** //
// ******************************** //
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
    log.w(
        'Exception Error while reading audio from path:' + onError.toString());
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

// **************************
// ** Write File to a Path **
// **************************
Future<File> writeToFile(Uint8List data, String path) {
  final buffer = data.buffer;
  return new File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
