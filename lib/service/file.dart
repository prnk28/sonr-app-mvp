import 'package:sonr_app/data/model/model_file.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:file_picker/file_picker.dart';

// ^ List of Allowed Types ^ //
const K_ALLOWED_FILE_TYPES = ['pdf', 'doc', 'docx', 'ttf', 'mp3', 'xml', 'csv', 'key', 'ppt', 'pptx', 'xls', 'xlsm', 'xlsx', 'rtf', 'txt'];

// ^ Status Enum ^ //
enum FileStatus {
  None,
  Loading,
  Ready,
}

// ^ Status Extension ^ //
extension FileStatusUtil on FileStatus {
  static FileStatus fromFilePickerStatus(FilePickerStatus s) {
    if (s == FilePickerStatus.picking) {
      return FileStatus.Loading;
    } else {
      return FileStatus.Ready;
    }
  }
}

// ^ Class for Managing Files ^ //
class FileService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<FileService>();
  static FileService get to => Get.find<FileService>();

  // Property Accessors
  static FileItem get current => to._current.value;
  static FileStatus get status => to._status.value;

  // Properties
  final _current = Rx<FileItem>(null);
  final _hasFile = RxBool(false);
  final _status = Rx<FileStatus>(FileStatus.None);

  // ^ Initialize Service ^ //
  Future<FileService> init() async {
    return this;
  }

  // @ Select Audio File //
  static Future<bool> selectAudio() async {
    // Check if File Already Queued
    if (!to._hasFile.value) {
      // Get File
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        withData: true,
        onFileLoading: (s) => _status(FileStatusUtil.fromFilePickerStatus(s)),
      );

      // Check File
      if (result != null) {
        to._current(FileItem.file(result));
        to._hasFile(true);
      }

      // Cancelled Picker
      else {
        to._current(null);
        to._hasFile(false);
      }
    }
    return !to._hasFile.value;
  }

  // @ Select Media File //
  static Future<bool> selectMedia() async {
    // Check if File Already Queued
    if (!to._hasFile.value) {
      // Get File
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        withData: true,
        onFileLoading: (s) => _status(FileStatusUtil.fromFilePickerStatus(s)),
      );

      // Check File
      if (result != null) {
        to._current(FileItem.file(result));
        to._hasFile(true);
      }

      // Cancelled Picker
      else {
        to._current(null);
        to._hasFile(false);
      }
    }
    return !to._hasFile.value;
  }

  // @ Select Other File //
  static Future<bool> selectFile() async {
    // Check if File Already Queued
    if (!to._hasFile.value) {
      // Get File
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: K_ALLOWED_FILE_TYPES,
        withData: true,
        onFileLoading: (s) => _status(FileStatusUtil.fromFilePickerStatus(s)),
      );

      // Check File
      if (result != null) {
        to._current(FileItem.file(result));
        to._hasFile(true);
      }

      // Cancelled Picker
      else {
        to._current(null);
        to._hasFile(false);
      }
    }
    return !to._hasFile.value;
  }
}
