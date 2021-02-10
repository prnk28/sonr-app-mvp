// Custom Theme Aspects
export 'header.dart';
export '../widgets/button.dart';
export 'color.dart';
export 'icon.dart';
export 'scaffold.dart';
export 'snackbar.dart';
export 'text.dart';

// Global UI Widgets
export '../widgets/actor.dart';
export '../widgets/animation.dart';
export '../widgets/card.dart';
export '../widgets/overlay.dart';
export '../widgets/painter.dart';
export '../widgets/radio.dart';
export '../widgets/sheet.dart';

// UI Packages
export 'package:google_fonts/google_fonts.dart';
export 'package:flutter_neumorphic/flutter_neumorphic.dart';
export 'package:simple_animations/simple_animations.dart';
export 'package:supercharged/supercharged.dart';
export 'package:simple_animations/simple_animations.dart';
export 'package:supercharged/supercharged.dart';
export 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class SonrStyle {
  static get cardItem => NeumorphicStyle(intensity: 0.85, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)));
}
