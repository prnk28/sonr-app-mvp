import 'dart:math';
import 'package:sonr_app/theme/theme.dart';

import 'constants.dart';

extension DataUtils on int {
  String sizeText() {
    // @ Less than 1KB
    if (this < pow(10, 3)) {
      return "$this B";
    }
    // @ Less than 1MB
    else if (this >= pow(10, 3) && this < pow(10, 6)) {
      // Adjust Size Value, Return String
      var adjusted = this / pow(10, 3);
      return "${double.parse((adjusted).toStringAsFixed(2))} KB";
    }
    // @ Less than 1GB
    else if (this >= pow(10, 6) && this < pow(10, 9)) {
      // Adjust Size Value, Return String
      var adjusted = this / pow(10, 6);
      return "${double.parse((adjusted).toStringAsFixed(2))} MB";
    }
    // @ Greater than GB
    else {
      // Adjust Size Value, Return String
      var adjusted = this / pow(10, 9);
      return "${double.parse((adjusted).toStringAsFixed(2))} GB";
    }
  }
}

extension DoubleUtils on double {
  // ^ Retreives Direction String ^ //
  String get direction {
    // Calculated
    var adjustedDegrees = this.round();
    final unit = "°";

    // @ Convert To String
    if (adjustedDegrees >= 0 && adjustedDegrees <= 9) {
      return "0" + "0" + adjustedDegrees.toString() + unit;
    } else if (adjustedDegrees > 9 && adjustedDegrees <= 99) {
      return "0" + adjustedDegrees.toString() + unit;
    } else {
      return adjustedDegrees.toString() + unit;
    }
  }

  // ^ Retreives Heading String ^ //
  String get heading {
    var adjustedDesignation = ((this / 22.5) + 0.5).toInt();
    var compassEnum = Position_Heading.values[(adjustedDesignation % 16)];
    return compassEnum.toString().substring(compassEnum.toString().indexOf('.') + 1);
  }
}

extension BoolUtils on bool {
  String valToEn() {
    if (this) {
      return "YES";
    } else {
      return "NO";
    }
  }
}

extension ListUtils on List {
  random() {
    final rand = new Random();
    return this[rand.nextInt(this.length)];
  }
}

extension StringUtils on String {
  String replaceAt(int index, String newChar) {
    return this.substring(0, index) + newChar + this.substring(index + 1);
  }
}
