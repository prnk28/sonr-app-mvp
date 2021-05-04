import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonr_app/service/client/sonr.dart';

/// Class for Managing a selection from File Picker
class FileItem {
  // File Properties
  final int size;
  final String name;
  final String path;
  final Payload payload;
  final MIME mime;
  final FilePickerResult result;

  // Thumbnail Properties
  List<int> thumbnail;
  Isolate isolate;
  Completer<bool> _thumbReady = Completer();
  bool get hasThumbnail => thumbnail != null;
  Future<bool> isThumbnailReady() => _thumbReady.future;

  // Retreives Metadata Info
  bool get isAudio => mime.type == MIME_Type.AUDIO;
  bool get isImage => mime.type == MIME_Type.IMAGE;
  bool get isVideo => mime.type == MIME_Type.VIDEO;

  // * Constructer * //
  FileItem(this.path, this.name, this.size, this.mime, this.payload, {this.result}) {
    if (mime.type == MIME_Type.IMAGE) {
      _asyncThumbInit(path);
    }
  }

  // * Factory: Capture * //
  factory FileItem.capture(MediaFile capture) {
    return FileItem(capture.path, capture.name, capture.size, _retreiveMime(capture.name), Payload.FILE);
  }

  // * Factory: File * //
  factory FileItem.file(FilePickerResult data) {
    var file = data.files.first;
    var path = file.path;
    var name = file.name;
    var size = file.size;
    var ext = file.extension;
    return FileItem(path, name, size, _retreiveMime(name), _retreivePayload(data), result: data);
  }

  // * Factory: Media - (Audio, Image, Video) * //
  factory FileItem.media(FilePickerResult data) {
    var file = data.files.first;
    var path = file.path;
    var name = file.name;
    var size = file.size;
    return FileItem(path, name, size, _retreiveMime(name), Payload.FILE, result: data);
  }

  // ^ Retreives Metadata Protobuf ^ //
  SonrFile get metadata => SonrFile(
        singleFile: SonrFile_Metadata(
          name: name,
          size: size,
          path: path,
          mime: mime,
          thumbnail: thumbnail,
          properties: SonrFile_Metadata_Properties(
            payload: payload,
            isAudio: isAudio,
            isImage: isImage,
            isVideo: isVideo,
            hasThumbnail: hasThumbnail,
          ),
        ),
      );

  // # Method to Start thumbnail Generation
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
        // Set Data
        thumbnail = data;

        // Set Thumbnail for Invite
        Get.find<TransferController>().setThumbnail(data);

        // Call Complete
        _thumbReady.complete(true);
      }
    });
  }

  // # Method to Handle thumbnail Generation
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

  // # File Mime from Name
  static MIME _retreiveMime(String name) {
    // Get Mime
    var mimeString = lookupMimeType(name);

    // String Manipulation
    var splitIdx = mimeString.indexOf('/');
    var ext = mimeString.substring(splitIdx + 1);
    var mimeValue = mimeString.substring(0, splitIdx).toUpperCase();

    // Find Protobuf Type
    var mimeType = MIME_Type.values.firstWhere((e) => e.toString() == mimeValue);
    return MIME(type: mimeType, value: mimeValue, subtype: ext);
  }

  // # File Payload from Ext
  static Payload _retreivePayload(FilePickerResult result) {
    if (result.files.length > 1) {
      return Payload.FILE;
    } else {
      return Payload.MULTI_FILES;
    }
  }

  // # Return Cleaned Name
  String prettyName() {
    if (this.name.length > 8) {
      return this.name.substring(0, 8) + ".${this.mime.subtype}";
    } else {
      return this.name;
    }
  }

  // # Return Size as String
  String sizeToString() {
    // @ Less than 1KB
    if (this.size < pow(10, 3)) {
      return "${this.size} B";
    }
    // @ Less than 1MB
    else if (this.size >= pow(10, 3) && this.size < pow(10, 6)) {
      // Adjust Size Value, Return String
      var adjusted = this.size / pow(10, 3);
      return "${double.parse((adjusted).toStringAsFixed(2))} KB";
    }
    // @ Less than 1GB
    else if (this.size >= pow(10, 6) && this.size < pow(10, 9)) {
      // Adjust Size Value, Return String
      var adjusted = this.size / pow(10, 6);
      return "${double.parse((adjusted).toStringAsFixed(2))} MB";
    }
    // @ Greater than GB
    else {
      // Adjust Size Value, Return String
      var adjusted = this.size / pow(10, 9);
      return "${double.parse((adjusted).toStringAsFixed(2))} GB";
    }
  }

  // # Return File Info as String
  @override
  String toString() {
    return "metadata: ${metadata.toString()}";
  }
}

// ^ Class for Media Item in Gallery ^ //
class MediaItem {
  // Inherited References
  final AssetEntity entity;
  final int index;

  // Properties
  String id;
  int width;
  int height;
  AssetType type;
  Duration duration;
  Uint8List thumbnail;

  // Calculated
  OpenResult openResult;

  // # Getter for is Audio
  bool get isAudio {
    if (type != null) {
      return type == AssetType.audio;
    }
    return false;
  }

  // # Getter for is Image
  bool get isImage {
    if (type != null) {
      return type == AssetType.image;
    }
    return false;
  }

  // # Getter for is Video
  bool get isVideo {
    if (type != null) {
      return type == AssetType.video;
    }
    return false;
  }

  // * Constructer * //
  MediaItem(this.entity, this.index) {
    // Set Properties
    this.id = entity.id;
    this.duration = entity.videoDuration;
    this.type = entity.type;
    this.width = entity.width;
    this.height = entity.height;
  }

  // @ Fetch Uint8List
  Future<Uint8List> getThumbnail() async {
    // Set Thumbnail
    thumbnail = await entity.thumbDataWithSize(320, 320);
    return thumbnail;
  }

  // @ Return File Info for Invite Request
  Future<SonrFile> getMetadata() async {
    thumbnail = thumbnail != null ? thumbnail : await getThumbnail();
    var file = await entity.file;
    var path = file.path;
    return SonrFile(
        singleFile: SonrFile_Metadata(
      path: path,
      thumbnail: thumbnail,
      properties: SonrFile_Metadata_Properties(
        hasThumbnail: thumbnail.length == 0,
        width: width,
        height: height,
        isImage: this.isImage,
        isVideo: this.isVideo,
        duration: this.duration.inSeconds,
      ),
    ));
  }

  // @ Fetch Image
  Future<ImageProvider<Object>> getImageProvider() async {
    return NetworkImage(await entity.getMediaUrl());
  }

  // @ Fetch File
  openFile() async {
    File file = await entity.file;
    var result = await OpenFile.open(file.path);
    return result;
  }
}

// ^ Class for Media Item from Capture or External Share ^ //
class MediaFile {
  // Media Properties
  final File _file;
  final Uint8List thumbnail;
  final bool isVideo;
  final int duration;

  String get path => _file.path;
  int get size => _file.lengthSync();
  String get name => _file.path.split('/').last;
  File get file => _file;

  // Constructer
  MediaFile(this._file, this.thumbnail, this.isVideo, this.duration);

  factory MediaFile.externalShare(SharedMediaFile mediaShared) {
    // Initialize
    int duration = 0;
    Uint8List thumbnail = Uint8List(0);
    File file = File(mediaShared.path);
    bool isVideo = mediaShared.type == SharedMediaType.VIDEO;

    // Get Video Thumbnail
    if (isVideo) {
      duration = mediaShared.duration;
      File thumbFile = File(mediaShared.thumbnail);
      thumbFile.readAsBytes().then((value) {
        thumbnail = value;
      });
    }

    // Return MediaFile
    return MediaFile(file, thumbnail, isVideo, duration);
  }

  factory MediaFile.capture(String path, bool isVideo, int duration) {
    return MediaFile(File(path), Uint8List(0), isVideo, duration);
  }

  Future<Uint8List> toUint8List() async {
    return await _file.readAsBytes();
  }
}
