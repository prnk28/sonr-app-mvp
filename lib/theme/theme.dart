// Custom Theme Aspects
export '../widgets/header.dart';
export '../widgets/button.dart';
export 'color.dart';
export 'dialog.dart';
export 'icon.dart';
export 'scaffold.dart';
export 'snackbar.dart';
export 'text.dart';

// Global UI Widgets
export '../widgets/animation.dart';
export '../widgets/painter.dart';
export '../widgets/radio.dart';
export '../widgets/sheet.dart';
export '../widgets/overlay.dart';

// UI Packages
export 'package:google_fonts/google_fonts.dart';
export 'package:flutter_neumorphic/flutter_neumorphic.dart';
export 'package:simple_animations/simple_animations.dart';
export 'package:supercharged/supercharged.dart';
export 'package:simple_animations/simple_animations.dart';
export 'package:supercharged/supercharged.dart';
export 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'color.dart';

class SonrStyle {
  static get cardItem => NeumorphicStyle(intensity: 0.85, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)));
  static get indented => NeumorphicStyle(depth: -8, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)));
  static get overlay => NeumorphicStyle(
      intensity: 0.85,
      depth: 8,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
      color: K_BASE_COLOR,
      shadowLightColor: Colors.black38);
  static get timeStamp => NeumorphicStyle(intensity: 0.4, depth: 8, boxShape: NeumorphicBoxShape.stadium(), color: K_BASE_COLOR);
}
