import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:sonr_core/sonr_core.dart';
import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart' as img;
import 'model_media.dart';

class FileItem {
  final int size;
  final String name;
  final String path;
  final Payload payload;
  final MIME mime;
  final FilePickerResult result;

  // Thumbnail Vars
  List<int> thumbnail;
  Isolate isolate;

  // # Retreives Metadata Info
  bool get isAudio => mime.type == MIME_Type.audio;
  bool get isImage => mime.type == MIME_Type.image;
  bool get isVideo => mime.type == MIME_Type.video;
  bool get hasThumbnail => thumbnail != null;

  // # Retreives Metadata Protobuf
  Metadata_Properties get properties => Metadata_Properties(payload: payload, isAudio: isAudio, isImage: isImage, isVideo: isVideo);
  Metadata get metadata => Metadata(name: name, size: size, path: path, mime: mime, properties: properties);

  // * Constructer * //
  FileItem(this.path, this.name, this.size, this.mime, this.payload, {this.result}) {
    if (mime.type == MIME_Type.image) {
      _asyncThumbInit(path);
    }
  }

  // ^ Method to Start thumbnail Generation ^ //
  _asyncThumbInit(String path) async {
    final ReceivePort receivePort = ReceivePort();
    isolate = await Isolate.spawn(_isolateThumbEntry, receivePort.sendPort);

    receivePort.listen((dynamic data) {
      if (data is SendPort) {
        data.send({
          'path': path,
          'size': Size(320, 320),
        });
      } else {
        thumbnail = data;
      }
    });
  }

  // ^ Method to Handle thumbnail Generation ^ //
  static _isolateThumbEntry(dynamic d) async {
    final ReceivePort receivePort = ReceivePort();
    d.send(receivePort.sendPort);

    // Retreive Data
    final config = await receivePort.first;
    final file = File(config['path']);
    final bytes = await file.readAsBytes();

    // Generate Thumbnail
    img.Image image = img.decodeImage(bytes);
    img.Image thumbnail = img.copyResize(
      image,
      width: config['size'].width.toInt(),
    );

    d.send(img.encodeNamedImage(thumbnail, basename(config['path'])));
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
    return FileItem(path, name, size, _retreiveMime(name), _retreivePayload(ext), result: data);
  }

  // @ Factory: Media - (Audio, Image, Video)
  factory FileItem.media(FilePickerResult data) {
    var file = data.files.first;
    var path = file.path;
    var name = file.name;
    var size = file.size;
    return FileItem(path, name, size, _retreiveMime(name), Payload.MEDIA, result: data);
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
