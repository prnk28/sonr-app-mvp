// ignore: non_constant_identifier_names
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

// ^ Sonr Global WindowBorder Data ^ //
// ignore: non_constant_identifier_names
RoundedRectangleBorder SonrWindowBorder() {
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0));
}

// ^ Sonr Global WindowDecoration Data ^ //
// ignore: non_constant_identifier_names
BoxDecoration SonrWindowDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(40),
    color: NeumorphicTheme.baseColor(Get.context),
  );
}
