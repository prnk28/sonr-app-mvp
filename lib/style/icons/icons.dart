export 'charts.dart';
export 'communication.dart';
export 'datetime.dart';
export 'design.dart';
export 'devices.dart';
export 'filesystem.dart';
export 'finance.dart';
export 'formatting.dart';
export 'mediacontrols.dart';
export 'medicine.dart';
export 'navigation.dart';
export 'selfcare.dart';
export 'shopping.dart';
export 'socialmedia.dart';
export 'sports.dart';
export 'package:sonr_app/style/style.dart';
export 'ui.dart';
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter/widgets.dart';
export 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';

Directory K_ASSETS_DIR = Directory('/Users/prad/Sonr/tools/icons/assets');

enum IconFill { Line, DuoTone, Solid }

extension IconFillUtils on IconFill {
  /// Returns Name of this Type
  String get name => this.toString().substring(this.toString().indexOf('.') + 1);
}

String cleanWord(String word) {
  var cseven = word.replaceAll('Seven', '07');
  var csix = cseven.replaceAll('Six', '06');
  var cfive = csix.replaceAll('Five', '05');
  var cfour = cfive.replaceAll('Four', '04');
  var cthree = cfour.replaceAll('Three', '03');
  var ctwo = cthree.replaceAll('Two', '02');
  var cone = ctwo.replaceAll('One', '01');
  var cout = cone.replaceAll('Out', 'ou-lc');
  var cin = cout.replaceAll('In', 'in-lc');
  return cin.toLowerCase();
}
