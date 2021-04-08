export 'auth_view.dart';
export 'card_view.dart';

import 'dart:math';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

const K_ALLOWED_FILE_TYPES = ['pdf', 'doc', 'docx', 'ttf', 'mp3', 'xml', 'csv', 'key', 'ppt', 'pptx', 'xls', 'xlsm', 'xlsx', 'rtf', 'txt'];

// ^ Metadata Model Extensions ^ //
extension MetadataFileUtils on Metadata {
  String get sizeString {
    // @ Less than 1KB
    if (this.size < pow(10, 3)) {
      return "$this B";
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
}

extension MIMEFileUtils on MIME {
  String get asString {
    return this.type.toString().capitalizeFirst;
  }
}

extension ProfileFileUtils on Profile {
  SonrText get nameText {
    return SonrText.bold(" ${this.firstName} ${this.lastName}", size: 16, color: Colors.grey[600]);
  }

  SonrIcon get platformIcon {
    return this.platform.icon(IconType.Normal, color: Colors.grey[600], size: 18);
  }
}
