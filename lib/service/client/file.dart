import 'dart:isolate';

import 'package:sonr_app/style/style.dart';
import 'package:file_picker/file_picker.dart';

// ^ Class for Managing Files ^ //
class FileService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<FileService>();
  static FileService get to => Get.find<FileService>();

  // References
  Isolate isolate;

  // ^ Initialize Service ^ //
  Future<FileService> init() async {
    return this;
  }

  // @ Select Audio File //
  static Future<Tuple<bool, SonrFile>> selectAudio() async {
    var result = await _handleSelectRequest(FileType.audio);
    // Check File
    if (result != null) {
      return Tuple(
          true,
          await SonrFileUtils.newWith(
            payload: Payload.MEDIA,
            path: result.files.first.path,
            size: result.files.first.size,
          ));
    }

    // Cancelled Picker
    else {
      return Tuple(false, null);
    }
  }

  // @ Select Media File //
  static Future<Tuple<bool, SonrFile>> selectMedia() async {
    // Load Picker
    var result = await _handleSelectRequest(FileType.media);

    // Check File
    if (result != null) {
      return Tuple(
          true,
          await SonrFileUtils.newWith(
            payload: Payload.MEDIA,
            path: result.files.first.path,
            size: result.files.first.size,
          ));
    }

    // Cancelled Picker
    else {
      return Tuple(false, null);
    }
  }

  // @ Select Other File //
  static Future<Tuple<bool, SonrFile>> selectFile() async {
    // Load Picker
    var result = await _handleSelectRequest(FileType.custom);

    // Check File
    if (result != null) {
      // Check If Single
      if (result.isSinglePick) {
        return Tuple(
            true,
            SonrFileUtils.newWith(
              payload: Payload.FILE,
              path: result.files.first.path,
              size: result.files.first.size,
            ));
      }
      // Multiple: Iterate Items
      else {
        // Initialize
        var file = SonrFile(direction: SonrFile_Direction.Outgoing, payload: Payload.MULTI_FILES);

        // Add Items
        result.files.forEach((e) {
          file.addItem(path: e.path, size: e.size);
        });

        return Tuple(true, file);
      }
    }

    // Cancelled Picker
    else {
      return Tuple(false, null);
    }
  }

  // # Generic Method for Different File Types
  static Future<FilePickerResult> _handleSelectRequest(FileType type) async {
    // @ Check if File Already Queued
    // Check Type for Custom Files
    if (type == FileType.custom) {
      return await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: K_ALLOWED_FILE_TYPES,
        withData: true,
      );
    }

    // For Media/Audio Files
    else {
      return await FilePicker.platform.pickFiles(
        type: FileType.media,
        withData: true,
      );
    }
  }
}
