import 'dart:ui';
import 'package:sonar_app/views/views.dart';
import 'package:boxicons_flutter/boxicons_flutter.dart';

// Imports
import 'package:sonar_app/core/design/textField.dart';
import 'package:sonar_app/core/design/text.dart';
import 'package:sonar_app/core/design/button.dart';

// Exports
export 'package:flutter_neumorphic/flutter_neumorphic.dart';
export 'package:sonar_app/core/design/button.dart';
export 'package:sonar_app/core/design/text.dart';
export 'package:sonar_app/core/design/textField.dart';
export 'package:boxicons_flutter/boxicons_flutter.dart';

class Design {
  // ******************* **
  // ** -- Theme Data -- **
  // ******************* **
  static NeumorphicThemeData lightTheme = NeumorphicThemeData(
    baseColor: Color(0xffDDDDDD),
    accentColor: Colors.cyan,
    lightSource: LightSource.topLeft,
    depth: 6,
    intensity: 0.5,
  );

  static NeumorphicThemeData darkTheme = NeumorphicThemeData(
    baseColor: Color(0xff333333),
    accentColor: Colors.green,
    lightSource: LightSource.topLeft,
    depth: 4,
    intensity: 0.3,
  );

  // ********************* **
  // ** -- Element Data -- **
  // ********************* **
  // Import all Design Classes
  static DesignButton button = new DesignButton();
  static DesignText text = new DesignText();
  static DesignTextField textField = new DesignTextField();

  // ********************** **
  // ** -- Class Methods -- **
  // ********************** **
  // Find Icons color based on Theme - Light/Dark
  static Color findIconsColor(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    if (theme.isUsingDark) {
      return theme.current.accentColor;
    } else {
      return null;
    }
  }

  // Find Text color based on Theme - Light/Dark
  static Color findTextColor(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
