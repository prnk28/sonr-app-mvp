import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ Find Icons color based on Theme - Light/Dark ^
Color findIconsColor(BuildContext context) {
  final theme = NeumorphicTheme.of(context);
  if (theme.isUsingDark) {
    return theme.current.accentColor;
  } else {
    return null;
  }
}

// ^ Find Text color based on Theme - Light/Dark ^
Color findTextColor(BuildContext context) {
  final theme = NeumorphicTheme.of(context);
  if (theme.isUsingDark) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}
