import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:sonr_core/sonr_core.dart';

class FileItem {
  final FilePickerResult file;
  final Payload payload;
  final MIME mime;

  // * Constructer * //
  FileItem(this.file, this.mime, this.payload);

  // @ Factory: File
  factory FileItem.file(FilePickerResult file) {
    var name = file.files[0].name;
    var ext = file.files[0].extension;
    return FileItem(file, _retreiveMime(name, ext), _retreivePayload(ext));
  }

  // @ Factory: Media - (Audio, Image, Video)
  factory FileItem.media(FilePickerResult file) {
    var name = file.files[0].name;
    var ext = file.files[0].extension;
    return FileItem(file, _retreiveMime(name, ext), Payload.MEDIA);
  }

  // # File Mime from Name
  static MIME _retreiveMime(String name, String ext) {
    // Get Mime
    var mimeValue = lookupMimeType(name);
    var mimeType = MIME_Type.values.firstWhere((e) => e.toString() == mimeValue);
    return MIME(type: mimeType, value: mimeValue, subtype: ext);
  }

  // # File Payload from Ext
  static Payload _retreivePayload(String ext) {
    if (ext == ".pdf") {
      return Payload.PDF;
    } else if (ext == ".ppt" || ext == ".pptx") {
      return Payload.PRESENTATION;
    } else if (ext == ".xls" || ext == ".xlsm" || ext == ".xlsx" || ext == ".csv") {
      return Payload.SPREADSHEET;
    } else if (ext == ".txt" || ext == ".doc" || ext == ".docx" || ext == ".ttf") {
      return Payload.TEXT;
    } else {
      return Payload.UNDEFINED;
    }
  }

  // @ Convert To String
  @override
  String toString() {
    return {
      'payload': payload.toString(),
      'mime': mime.toString(),
      'size': file.files[0].size.toString(),
      'name': file.files[0].name,
    }.toString();
  }
}
