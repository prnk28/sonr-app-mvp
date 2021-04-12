import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:sonr_core/sonr_core.dart';

class FileItem {
  final FilePickerResult file;
  final Payload payload;
  final MIME mime;

  // ^ Retreives Metadata Info ^
  int get size => file.files.first.size;
  String get name => file.files.first.name;
  String get path => file.paths.first;
  bool get isAudio => mime.type == MIME_Type.audio;
  bool get isImage => mime.type == MIME_Type.image;
  bool get isVideo => mime.type == MIME_Type.video;

  // ^ Retreives Metadata Protobuf ^
  Metadata_Properties get properties => Metadata_Properties(payload: payload, isAudio: isAudio, isImage: isImage, isVideo: isVideo);
  Metadata get metadata => Metadata(name: name, size: size, path: path, mime: mime, properties: properties);

  // * Constructer * //
  FileItem(this.file, this.mime, this.payload);

  // @ Factory: File
  factory FileItem.file(FilePickerResult file) {
    var name = file.files[0].name;
    var ext = file.files[0].extension;
    return FileItem(file, _retreiveMime(name), _retreivePayload(ext));
  }

  // @ Factory: Media - (Audio, Image, Video)
  factory FileItem.media(FilePickerResult file) {
    var name = file.files[0].name;
    return FileItem(file, _retreiveMime(name), Payload.MEDIA);
  }

  // # File Mime from Name
  static MIME _retreiveMime(String name) {
    // Get Mime
    var mimeString = lookupMimeType(name);

    // String Manipulation
    var splitIdx = mimeString.indexOf('/');
    var ext = mimeString.substring(splitIdx + 1);
    var mimeValue = mimeString.substring(0, splitIdx);

    // Find Protobuf Type
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

  // # Return File Info as String
  @override
  String toString() {
    return "metadata: ${metadata.toString()}";
  }
}
