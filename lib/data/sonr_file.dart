import 'dart:io';
import 'package:path/path.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/models/models.dart';

class SonrFile {
  // Default Properties
  DateTime lastModified;
  String name;
  int size;
  FileType type;
  int chunksTotal;
  bool isSender;

  // Transmission Properties
  double sendingProgress;
  double receivingProgress;
  bool isComplete;
  Profile sender;
  Profile receiver;

  // ** CONSTRUCTER **
  SonrFile(bool sending, dynamic info, {File file}) {
    // Check if File is Local
    if (sending) {
      // Set Default Properties
      this.isSender = true;
      this.lastModified = file.lastModifiedSync();
      this.name = basename(file.path);
      this.size = file.lengthSync();
      this.type = getFileType(file.path);
    }
  }
}
