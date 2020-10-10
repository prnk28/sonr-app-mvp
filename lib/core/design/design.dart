import 'dart:ui';
import 'package:sonar_app/screens/screens.dart';
import 'package:boxicons_flutter/boxicons_flutter.dart';

// Imports
import 'package:sonar_app/core/design/textField.dart';
import 'package:sonar_app/core/design/text.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:sonar_app/core/design/button.dart';

// Exports
export 'package:flutter_neumorphic/flutter_neumorphic.dart';
export 'package:animations/animations.dart';
export 'package:sonar_app/core/design/button.dart';
export 'package:sonar_app/core/design/text.dart';
export 'package:sonar_app/core/design/textField.dart';
export 'package:boxicons_flutter/boxicons_flutter.dart';
export 'package:flutter_gradients/flutter_gradients.dart';

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

  // ***************** **
  // ** -- App Bars -- **
  // ***************** **
  static NeumorphicAppBar logoAppBar = NeumorphicAppBar(
    title: NeumorphicText("Sonr",
        style: NeumorphicStyle(
          depth: 4, //customize depth here
          color: Colors.white, //customize color here
        ),
        textStyle: Design.text.neuLogo(),
        textAlign: TextAlign.center),
  );

  static NeumorphicAppBar screenAppBar(
    String title,
  ) {
    return NeumorphicAppBar(
      title: NeumorphicText(title,
          style: NeumorphicStyle(
            depth: 2, //customize depth here
            color: Colors.white, //customize color here
          ),
          textStyle: Design.text.neuBarTitle(),
          textAlign: TextAlign.center),
      leading: Container(),
    );
  }

  static NeumorphicAppBar leadingAppBar(
    String destination,
    BuildContext context,
    IconData iconData, {
    bool shouldPopScreen,
    String title,
  }) {
    return NeumorphicAppBar(
      leading: Stack(
        alignment: Alignment.center,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Design.button.appBarLeadingButton(iconData, onPressed: () {
                // Check if Bool Provided or False
                if (shouldPopScreen == null || !shouldPopScreen) {
                  Navigator.pushNamed(context, destination);
                } else {
                  Navigator.pop(context);
                }
              }, context: context)),
        ],
      ),
    );
  }

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
