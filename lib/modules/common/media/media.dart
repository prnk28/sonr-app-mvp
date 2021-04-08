export 'auth_view.dart';
export 'card_view.dart';
export 'queue_view.dart';
export 'sheet_view.dart';
import 'dart:math';

import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ Metadata Model Extensions ^ //
extension MetadataMediaUtils on Metadata {
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

extension MIMEMimeUtils on MIME {
  String get asString {
    return this.type.toString().capitalizeFirst;
  }
}
