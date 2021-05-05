import 'package:sonr_app/data/data.dart';
import 'package:intl/intl.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

extension SharedFileUtils on SonrFile {
  static SonrFile newFromExternal(SharedMediaFile mediaShared) {
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

    // Return File
    return SonrFileUtils.newSingle(
      path: file.path,
      size: file.lengthSync(),
      duration: duration,
      thumbnail: thumbnail,
    );
  }
}

extension ProfileFileUtils on Profile {
  Widget get nameText {
    return " ${this.firstName} ${this.lastName}".h6;
  }
}

extension TextUtils on TransferCardItem {
  Widget get dateTimeText {
    // Formatters
    final dateFormat = DateFormat.yMd();
    final timeFormat = DateFormat.jm();

    // Get String
    String dateText = dateFormat.format(this.received);
    String timeText = timeFormat.format(this.received);
    return Row(children: [dateText.h6_White, timeText.p_White]);
  }

  Widget get dateText {
    // Formatters
    final dateFormat = DateFormat.yMd();

    // Get String
    return dateFormat.format(this.received).h6_White;
  }
}

// ^ Payload Model Extensions ^ //
extension MIMETypeUtils on MIME_Type {
  FlutterGradientNames get gradientName {
    return [
      FlutterGradientNames.itmeoBranding,
      FlutterGradientNames.norseBeauty,
      FlutterGradientNames.summerGames,
      FlutterGradientNames.healthyWater,
      FlutterGradientNames.frozenHeat,
      FlutterGradientNames.mindCrawl,
      FlutterGradientNames.seashore
    ].random();
  }
}

// @ Helper Enum for Video/Image Orientation
enum MediaOrientation { Portrait, Landscape }

extension MediaOrientationUtils on MediaOrientation {
  double get aspectRatio {
    switch (this) {
      case MediaOrientation.Landscape:
        return 16 / 9;
      default:
        return 9 / 16;
    }
  }

  double get defaultHeight {
    switch (this) {
      case MediaOrientation.Landscape:
        return 180;
      default:
        return 320;
    }
  }

  double get defaultWidth {
    switch (this) {
      case MediaOrientation.Landscape:
        return 320;
      default:
        return 180;
    }
  }
}
