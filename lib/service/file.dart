import 'package:sonr_app/data/model/model_file.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:file_picker/file_picker.dart';

// ^ List of Allowed Types ^ //
const K_ALLOWED_FILE_TYPES = ['pdf', 'doc', 'docx', 'ttf', 'mp3', 'xml', 'csv', 'key', 'ppt', 'pptx', 'xls', 'xlsm', 'xlsx', 'rtf', 'txt'];

// ^ Class for Managing Files ^ //
class FileService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<FileService>();
  static FileService get to => Get.find<FileService>();

  // Properties
  final _hasFile = RxBool(false);

  // ^ Initialize Service ^ //
  Future<FileService> init() async {
    return this;
  }

  // @ Select Audio File //
  static Future<Tuple<bool, FileItem>> selectAudio() async => _processSelectedItem(await _handleSelectRequest(FileType.audio));

  // @ Select Media File //
  static Future<Tuple<bool, FileItem>> selectMedia() async => _processSelectedItem(await _handleSelectRequest(FileType.media));

  // @ Select Other File //
  static Future<Tuple<bool, FileItem>> selectFile() async => _processSelectedItem(await _handleSelectRequest(FileType.custom));

  // # Generic Method for Different File Types
  static Future<FilePickerResult> _handleSelectRequest(FileType type) async {
    // @ Check if File Already Queued
    if (!to._hasFile.value) {
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
    } else {
      return null;
    }
  }

  // # Helper Method to Check File Picker Result
  static Tuple<bool, FileItem> _processSelectedItem(FilePickerResult result) {
    // Check File
    if (result != null) {
      to._hasFile(true);
      return Tuple(!to._hasFile.value, FileItem.file(result));
    }

    // Cancelled Picker
    else {
      to._hasFile(false);
      return Tuple(!to._hasFile.value, null);
    }
  }
}
