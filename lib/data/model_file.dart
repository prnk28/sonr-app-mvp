import 'dart:io';
import 'dart:math';
import 'package:media_gallery/media_gallery.dart';
import 'package:sonr_app/theme/theme.dart';
import 'constants.dart';

// ^ Media Picker Item Data ^ //
class MediaGalleryItem {
  // Media Properties
  final int index;
  final Media media;
  MediaType get type => media.mediaType;

  // Thumbnail Properties
  final bool highQuality;
  final double maxWidth;
  final double maxHeight;

  // Constructer + Methods
  MediaGalleryItem(this.index, this.media, {this.maxWidth = 320, this.maxHeight = 320, this.highQuality = false});
  Widget getIcon() => type == MediaType.video ? SonrIcon.gradient(SonrIconData.video, FlutterGradientNames.glassWater, size: 28) : Container();
  Future<Uint8List> getThumbnail() async {
    // Get Ratio
    var ratio = min(maxWidth / media.width, maxHeight / media.height);

    // Calculate Fit and Scale Image
    var thumbWidth = (media.width * ratio).round();
    var thumbHeight = (media.height * ratio).round();

    return await media.getThumbnail(width: thumbWidth, height: thumbHeight, highQuality: highQuality);
  }
}

// ^ Media Picker Selected File ^ //
class MediaFile {
  // Media Properties
  final File _file;
  

  // Constructer
  MediaFile(this._file);
}
