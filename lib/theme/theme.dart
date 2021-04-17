export '../service/device/sensors.dart';
export '../service/device/file.dart';
export '../service/client/lobby.dart';
export '../service/interface/media.dart';
export '../service/client/sonr.dart';
export '../service/device/cards.dart';
export '../service/client/user.dart';
export '../service/interface/assets.dart';
export 'package:flutter/services.dart';
export 'package:get/get.dart' hide Node;
export 'dart:typed_data';
export 'package:path_provider/path_provider.dart';
export 'package:flutter_compass/flutter_compass.dart';
export 'package:open_file/open_file.dart';
export 'package:sonr_app/theme/elements/clipper.dart';
export 'package:animated_widgets/animated_widgets.dart';
export 'package:sonr_app/modules/common/camera/camera_view.dart';

// Custom Theme Aspects
export 'buttons/action.dart';
export 'buttons/color.dart';
export 'buttons/plain.dart';
export 'buttons/confirm.dart';
export 'style/color.dart';
export 'style/icon.dart';
export 'style/scaffold.dart';
export 'elements/snackbar.dart';
export 'style/text.dart';
export 'style/decoration.dart';
export 'elements/appbar.dart';
export 'animation/animation.dart';

// Global UI Widgets
export 'elements/shape.dart';
export 'elements/glass.dart';
export 'elements/painter.dart';
export '../modules/overlay/overlay.dart';
export '../modules/overlay/flat_overlay.dart';
export 'form/dropdown.dart';
export 'form/radio.dart';
export 'form/textfield.dart';

// UI Packages
export 'package:flutter_neumorphic/flutter_neumorphic.dart';
export 'package:supercharged/supercharged.dart';
export 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/client/user.dart';
import 'style/color.dart';

enum WidgetPosition { Left, Right, Top, Bottom, Center }

class SonrStyle {
  static Size get viewSize => Size(Get.width * 0.95, Get.height * 0.85);
  static EdgeInsets get viewMargin => EdgeInsets.symmetric(vertical: Get.height * 0.15, horizontal: Get.width * 0.05);

  static NeumorphicStyle get overlay => NeumorphicStyle(
        intensity: UserService.isDarkMode ? 0.45 : 0.85,
        depth: UserService.isDarkMode ? 4 : 8,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
      );

  static NeumorphicStyle get timeStamp => NeumorphicStyle(
      intensity: 0.4,
      depth: UserService.isDarkMode ? 4 : 8,
      boxShape: NeumorphicBoxShape.stadium(),
      color: UserService.isDarkMode ? SonrColor.White : SonrColor.Dark);

  static NeumorphicStyle get timeStampDark => NeumorphicStyle(
      intensity: 0.4,
      depth: UserService.isDarkMode ? 4 : 8,
      boxShape: NeumorphicBoxShape.stadium(),
      color: UserService.isDarkMode ? SonrColor.White : SonrColor.Dark);

  static NeumorphicStyle get toggle => NeumorphicStyle(
        intensity: UserService.isDarkMode ? 0.25 : 0.5,
        depth: UserService.isDarkMode ? 4 : 6,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        color: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
      );
}

extension WidgetListUtils on List<Widget> {
  /// Accessor Method to Create a Row
  Widget row(
      {Key key,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
      MainAxisSize mainAxisSize = MainAxisSize.max,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
      VerticalDirection verticalDirection = VerticalDirection.down,
      TextDirection textDirection,
      TextBaseline textBaseline}) {
    return Row(
      children: this,
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      verticalDirection: verticalDirection,
      textDirection: textDirection ?? textDirection,
      textBaseline: textBaseline ?? textBaseline,
    );
  }

  /// Accessor Method to Create a Column
  Widget column({
    Key key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextDirection textDirection,
    TextBaseline textBaseline,
  }) {
    return Column(
      children: this,
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      verticalDirection: verticalDirection,
      textDirection: textDirection ?? textDirection,
      textBaseline: textBaseline ?? textBaseline,
    );
  }
}
