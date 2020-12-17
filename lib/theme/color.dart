import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

// ^ Find Icons color based on Theme - Light/Dark ^
Color findIconsColor() {
  final theme = NeumorphicTheme.of(Get.context);
  if (Get.isDarkMode) {
    return theme.current.accentColor;
  } else {
    return null;
  }
}

// ^ Find Text color based on Theme - Light/Dark ^
Color findTextColor() {
  if (Get.isDarkMode) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}
