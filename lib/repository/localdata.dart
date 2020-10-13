import 'repository.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

class LocalData {
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
}
