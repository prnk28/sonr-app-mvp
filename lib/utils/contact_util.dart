import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sonar_frontend/model/profile_model.dart';

class ProfileStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    var profile = File('$path/contacts.json');

    // Create Blank if Non-existent
    if (profile == null) {
      writeProfile(ProfileModel.blank());
    }

    return profile;
  }

  Future<ProfileModel> readProfile() async {
    try {
      final file = await _localFile;

      // Read the file
      String jsonData = await file.readAsString();
      Map userMap = jsonDecode(jsonData);

      // Return as Model
      return ProfileModel.fromJson(userMap);
    } catch (e) {
      // If encountering an error, return 0
      return ProfileModel.blank();
    }
  }

  Future<File> writeProfile(ProfileModel profile) async {
    final file = await _localFile;

    // Write the file
    print("Profile Written to Disk");
    return file.writeAsString(profile.toString());
  }
}
