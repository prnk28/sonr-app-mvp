import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:sonr_core/sonr_core.dart';

import 'model_media.dart';

class FileItem {
  final int size;
  final String name;
  final String path;
  final Payload payload;
  final MIME mime;
  List<int> thumbnail;

  // # Retreives Metadata Info
  bool get isAudio => mime.type == MIME_Type.audio;
  bool get isImage => mime.type == MIME_Type.image;
  bool get isVideo => mime.type == MIME_Type.video;
  bool get hasThumbnail => thumbnail != null;

  // # Retreives Metadata Protobuf
  Metadata_Properties get properties => Metadata_Properties(payload: payload, isAudio: isAudio, isImage: isImage, isVideo: isVideo);
  Metadata get metadata => Metadata(name: name, size: size, path: path, mime: mime, properties: properties);

  // * Constructer * //
  FileItem(this.path, this.name, this.size, this.mime, this.payload);

  // ^ Method to Add a thumbnail ^ //
  void addThumbnail(List<int> thumbnail) {
    if (thumbnail.length > 0) {
      this.thumbnail = thumbnail;
    }
  }

  // @ Factory: Capture
  factory FileItem.capture(MediaFile capture) {
    return FileItem(capture.path, capture.name, capture.size, _retreiveMime(capture.name), Payload.MEDIA);
  }

  // @ Factory: File
  factory FileItem.file(FilePickerResult data) {
    var file = data.files.first;
    var path = file.path;
    var name = file.name;
    var size = file.size;
    var ext = file.extension;
    return FileItem(path, name, size, _retreiveMime(name), _retreivePayload(ext));
  }

  // @ Factory: Media - (Audio, Image, Video)
  factory FileItem.media(FilePickerResult data) {
    var file = data.files.first;
    var path = file.path;
    var name = file.name;
    var size = file.size;
    return FileItem(path, name, size, _retreiveMime(name), Payload.MEDIA);
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
      return Payload.OTHER;
    }
  }

  // # Return File Info as String
  @override
  String toString() {
    return "metadata: ${metadata.toString()}";
  }
}
