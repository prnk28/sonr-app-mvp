import 'dart:math';
import '../../theme/theme.dart';

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

extension DirectionUtils on double {
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
    var adjustedDesignation = ((this / 11.25) + 0.25).toInt();
    var compassEnum = Position_Designation.values[(adjustedDesignation % 32)];
    return compassEnum.toString().substring(compassEnum.toString().indexOf('.') + 1);
  }
}

extension ListUtils<T> on List<T> {
  random() {
    final rand = new Random();
    return this[rand.nextInt(this.length)];
  }

  void swap(int index1, int index2) {
    var length = this.length;
    RangeError.checkValidIndex(index1, this, "index1", length);
    RangeError.checkValidIndex(index2, this, "index2", length);
    if (index1 != index2) {
      var tmp1 = this[index1];
      this[index1] = this[index2];
      this[index2] = tmp1;
    }
  }
}

extension StringUtils on String {
  String replaceAt(int index, String newChar) {
    return this.substring(0, index) + newChar + this.substring(index + 1);
  }
}
