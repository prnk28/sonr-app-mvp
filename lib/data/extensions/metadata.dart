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
    Uint8List thumbdata = File(mediaShared.thumbnail).readAsBytesSync();
    List<int> thumbnail = thumbdata.toList();

    // Return File
    return SonrFileUtils.newWith(
      path: mediaShared.path,
      duration: mediaShared.duration ?? 0,
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
