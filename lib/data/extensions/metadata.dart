import 'package:sonr_app/data/data.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ Metadata Model Extensions ^ //
extension MetadataFileUtils on Metadata {
  /// Checks if Metadata is for Image File
  bool get isImage => this.mime.type == MIME_Type.image;
  bool get isVideo => this.mime.type == MIME_Type.video;

  ///  Return Cleaned Name
  String get prettyName {
    if (this.name.length > 8) {
      return this.name.substring(0, 8) + ".${this.mime.subtype}";
    } else {
      return this.name;
    }
  }

  /// Returns Size as Readable String
  String get sizeString {
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

  String get typeString {
    return this.mime.type.toString().capitalizeFirst;
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
extension PayloadUtils on Payload {
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

  String get asString {
    if (this == Payload.PDF) {
      return this.toString();
    }
    return this.toString().capitalizeFirst;
  }

  bool get isFile {
    return this != Payload.UNDEFINED && this != Payload.CONTACT && this != Payload.URL;
  }

  bool get isMedia {
    return this == Payload.MEDIA;
  }

  bool get isTransfer => this != Payload.CONTACT && this != Payload.URL;
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
