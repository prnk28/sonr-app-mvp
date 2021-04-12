import 'dart:io';
import 'dart:typed_data';

import 'package:open_file/open_file.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonr_app/service/sonr.dart';
import 'package:sonr_app/theme/theme.dart';

const K_ALBUM_PAGE_SIZE = 40;

// ^ Class for Media Album ^ //
class MediaAlbum {
  final AssetPathEntity data;
  // Properties
  bool isAll = false;
  bool get isEmpty => assets.isEmpty;
  var assets = <MediaItem>[];
  String name = "";
  int count = 0;
  int currentPage = 0;
  int totalPages = 0;

  factory MediaAlbum.blank() {
    return MediaAlbum(null);
  }

  // * Constructer * //
  MediaAlbum(this.data) {
    if (this.data != null) {
      this.isAll = data.isAll;
      this.name = data.name;
      this.count = data.assetCount;
      this.totalPages = (data.assetCount / K_ALBUM_PAGE_SIZE).ceil();

      // Items on Range
      data.getAssetListRange(start: 0, end: 100).then((items) {
        // Iterate through Items
        items.forEach((element) {
          assets.add(MediaItem(element, items.indexOf(element)));
        });
      });
    }
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
  Future<Metadata> getMetadata() async {
    thumbnail = thumbnail != null ? thumbnail : await getThumbnail();
    var file = await entity.file;
    var path = file.path;
    return Metadata(
      path: path,
      thumbnail: thumbnail,
      properties: Metadata_Properties(
        hasThumbnail: thumbnail.isEmpty,
        width: width,
        height: height,
        isImage: this.isImage,
        isVideo: this.isVideo,
        duration: this.duration.inSeconds,
      ),
    );
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
