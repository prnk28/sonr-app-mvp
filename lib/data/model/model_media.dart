import 'dart:io';
import 'dart:typed_data';

import 'package:open_file/open_file.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonr_app/service/sonr.dart';

const K_ALBUM_PAGE_SIZE = 40;

// ^ Class for Media Album ^ //
class MediaAlbum {
  final AssetPathEntity data;
  // Properties
  bool isAll;
  var assets = <MediaItem>[];
  String name = "";
  int count = 0;
  int currentPage = 0;
  int totalPages = 0;

  // * Constructer * //
  MediaAlbum(this.data) {
    this.isAll = data.isAll;
    this.name = data.name;
    this.count = data.assetCount;
    this.totalPages = (data.assetCount / K_ALBUM_PAGE_SIZE).ceil();

    // Items on Range
    data.getAssetListRange(start: 0, end: 500).then((items) {
      // Iterate through Items
      items.forEach((element) {
        assets.add(MediaItem(element, items.indexOf(element)));
      });
    });
  }
}

// ^ Class for Media Item in Gallery ^ //
class MediaItem {
  // Inherited References
  final AssetEntity data;
  final int index;

  // Properties
  String id;
  int width;
  int height;
  AssetType type;
  Duration duration;

  // Calculated
  Uint8List thumbnail;
  OpenResult openResult;
  File file;

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
  MediaItem(this.data, this.index) {
    // Set Properties
    this.id = data.id;
    this.duration = data.videoDuration;
    this.type = data.type;
    this.width = data.width;
    this.height = data.height;
  }

  static fromID(String id) async {
    var asset = await AssetEntity.fromId(id);
    return MediaItem(asset, -1);
  }

  // @ Fetch Uint8List
  Future<Uint8List> getThumbnail() async {
    // Set Thumbnail
    var td = await data.thumbDataWithSize(320, 320);
    this.thumbnail = td;
    return td;
  }

  // @ Fetch File
  Future<File> getFile() async {
    this.file = await this.data.file;
    return this.file;
  }

  // @ Return File Info for Invite Request
  Future<InviteRequest_FileInfo> getInfo() async {
    if (this.file == null) {
      this.file = await data.file;
      return InviteRequest_FileInfo(
        path: this.file.path,
        duration: this.duration.inSeconds,
        thumbnail: this.thumbnail,
        isVideo: this.isVideo,
      );
    } else {
      return InviteRequest_FileInfo(
        path: this.file.path,
        duration: this.duration.inSeconds,
        thumbnail: this.thumbnail,
        isVideo: this.isVideo,
      );
    }
  }

  // @ Fetch File
  void openFile() async {
    if (this.file == null) {
      this.file = await data.file;
      this.openResult = await OpenFile.open(file.path);
    } else {
      this.openResult = await OpenFile.open(file.path);
    }
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
}
