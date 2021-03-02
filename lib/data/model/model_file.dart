import 'dart:io';
import 'dart:math';
import 'package:media_gallery/media_gallery.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonr_app/core/core.dart';
import '../../core/core.dart';

// ^ Media Picker Item Data ^ //
class MediaGalleryItem {
  // Media Properties
  final int index;
  final Media media;
  File file;
  OpenResult openResult;
  MediaType get type => media.mediaType;

  // Thumbnail Properties
  Uint8List thumbnail;
  final bool highQuality;
  final double maxWidth;
  final double maxHeight;

  // Constructer + Methods
  MediaGalleryItem(this.index, this.media, {this.maxWidth = 320, this.maxHeight = 320, this.highQuality = false});
  Widget getIcon() => type == MediaType.video ? SonrIcon.gradient(SonrIconData.video, FlutterGradientNames.glassWater, size: 28) : Container();

  // Gets Media Thumbnail
  Future<Uint8List> getThumbnail() async {
    // Get Ratio
    var ratio = min(maxWidth / media.width, maxHeight / media.height);

    // Calculate Fit and Scale Image
    var thumbWidth = (media.width * ratio).round();
    var thumbHeight = (media.height * ratio).round();

    return thumbnail = await media.getThumbnail(width: thumbWidth, height: thumbHeight, highQuality: highQuality);
  }

  // Gets Media file
  Future<MediaFile> getMediaFile() async {
    if (file == null) {
      return MediaFile(file = await media.getFile(), thumbnail, type == MediaType.video, 0);
    } else {
      return MediaFile(file, thumbnail, type == MediaType.video, 0);
    }
  }

  // Opens MediaFile
  Future openFile() async {
    if (file == null) {
      file = await media.getFile();
      openResult = await OpenFile.open(file.path);
    } else {
      openResult = await OpenFile.open(file.path);
    }
  }
}

// ^ Media Picker Selected File ^ //
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
}
