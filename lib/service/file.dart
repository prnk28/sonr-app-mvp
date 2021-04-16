import 'package:sonr_app/data/model/model_file.dart';
import 'package:sonr_app/theme/form/theme.dart';
import 'package:file_picker/file_picker.dart';

// ^ List of Allowed Types ^ //
const K_ALLOWED_FILE_TYPES = ['pdf', 'doc', 'docx', 'ttf', 'mp3', 'xml', 'csv', 'key', 'ppt', 'pptx', 'xls', 'xlsm', 'xlsx', 'rtf', 'txt'];

// ^ Class for Managing Files ^ //
class FileService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<FileService>();
  static FileService get to => Get.find<FileService>();

  // ^ Initialize Service ^ //
  Future<FileService> init() async {
    return this;
  }

  // @ Select Audio File //
  static Future<Tuple<bool, FileItem>> selectAudio() async {
    var result = await _handleSelectRequest(FileType.audio);
    // Check File
    if (result != null) {
      return Tuple(true, FileItem.media(result));
    }

    // Cancelled Picker
    else {
      return Tuple(false, null);
    }
  }

  // @ Select Media File //
  static Future<Tuple<bool, FileItem>> selectMedia() async {
    // Load Picker
    var result = await _handleSelectRequest(FileType.media);

    // Check File
    if (result != null) {
      return Tuple(true, FileItem.media(result));
    }

    // Cancelled Picker
    else {
      return Tuple(false, null);
    }
  }

  // @ Select Other File //
  static Future<Tuple<bool, FileItem>> selectFile() async {
    // Load Picker
    var result = await _handleSelectRequest(FileType.custom);

    // Check File
    if (result != null) {
      return Tuple(true, FileItem.file(result));
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
        type: type,
        withData: true,
      );
    }
  }
}

// @ Helper Extension to Retreive Items
extension FileItemTupleUtils on Tuple<bool, FileItem> {
  bool get hasItem => this.item1;
  FileItem get fileItem => this.item2;
}
