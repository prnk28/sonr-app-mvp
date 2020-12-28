import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// Custom Classes
export 'appbar.dart';
export 'button.dart';
export 'color.dart';
export 'icon.dart';
export '../widgets/animation.dart';
export '../widgets/card.dart';
export '../widgets/overlay.dart';
export '../widgets/painter.dart';
export '../widgets/radio.dart';
export '../widgets/sheet.dart';
export '../widgets/snackbar.dart';
export '../widgets/text.dart';

// UI Packages
export 'package:google_fonts/google_fonts.dart';
export 'package:flutter_neumorphic/flutter_neumorphic.dart';
export 'package:simple_animations/simple_animations.dart';
export 'package:supercharged/supercharged.dart';
export 'package:simple_animations/simple_animations.dart';
export 'package:supercharged/supercharged.dart';
export 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

// ^ Sonr Global Theme Data ^ //
// ignore: non_constant_identifier_names
NeumorphicTheme SonrTheme({@required Widget child}) {
  return NeumorphicTheme(
      themeMode: ThemeMode.light, //or dark / system
      darkTheme: NeumorphicThemeData(
        baseColor: Color.fromRGBO(239, 238, 238, 1.0),
        accentColor: Colors.green,
        lightSource: LightSource.topLeft,
        depth: 4,
        intensity: 0.5,
      ),
      theme: NeumorphicThemeData(
        baseColor: Color(0xffDDDDDD),
        accentColor: Colors.cyan,
        lightSource: LightSource.topLeft,
        depth: 6,
        intensity: 0.65,
      ),
      child: child);
}
