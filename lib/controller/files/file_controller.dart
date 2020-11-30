import 'package:sonar_app/database/database.dart';
import 'dart:io';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/sonr_core.dart';

class FileController extends GetxController {
  var allFiles = new List<Metadata>().obs;
  File currentFile;
  Metadata currentMetadata;

  getAllFiles() async {
    // Open Provider
    MetadataProvider metadataProvider = new MetadataProvider();
    await metadataProvider.open();

    // Set List
    List<Metadata> result = await metadataProvider.getAllFiles();

    if (result == null) {
      throw OpenFilesError("Couldnt open DB at Path");
    } else {
      allFiles(result);
    }
  }

  getFile(Metadata meta) async {
    // Set Data
    currentMetadata = meta;
    currentFile = File(meta.path);

    // Emit Update
    update();
  }
}
