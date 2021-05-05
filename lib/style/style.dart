export '../service/device/device.dart';
export '../service/device/desktop.dart';
export '../service/device/mobile.dart';
export '../service/client/file.dart';
export '../service/client/lobby.dart';
export '../service/client/sonr.dart';
export '../service/user/cards.dart';
export '../service/user/user.dart';
export '../service/user/assets.dart';
export 'package:flutter/services.dart';
export 'package:get/get.dart' hide Node;
export 'dart:typed_data';
export 'package:path_provider/path_provider.dart';
export 'package:flutter_compass/flutter_compass.dart';
export 'package:open_file/open_file.dart';
export 'package:sonr_app/style/elements/clipper.dart';
export 'package:animated_widgets/animated_widgets.dart';
export 'package:sonr_app/modules/camera/camera_view.dart';

// Custom Theme Aspects
export 'buttons/action.dart';
export 'buttons/color.dart';
export 'buttons/plain.dart';
export 'buttons/confirm.dart';
export 'elements/scaffold.dart';
export 'elements/snackbar.dart';
export 'elements/appbar.dart';
export 'animation/animation.dart';

// Global UI Widgets
export 'elements/shape.dart';
export 'elements/painter.dart';
export '../pages/overlay/overlay.dart';
export '../pages/overlay/flat_overlay.dart';
export 'form/dropdown.dart';
export 'form/textfield.dart';

// UI Packages
export 'package:flutter/material.dart';
export 'package:supercharged/supercharged.dart';
export 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/device/device.dart';

enum WidgetPosition { Left, Right, Top, Bottom, Center }

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

/// * Class that Handles Device Screen Width Management * //
class Width {
  /// Return Full Screen Width
  static double get full => DeviceService.isDesktop ? 1280 : Get.width;

  /// Return Full Screen Width Divided by Value <= ScreenWidth
  static double divided(double val) {
    assert(val <= Get.width);
    return Get.width / val;
  }

  /// Return Width as Ratio from Screen between 0.0 and 1.0
  static double ratio(double ratio) {
    assert(ratio <= 1.0 && ratio > 0.0);
    return Get.width * ratio;
  }

  /// Return Width reduced by given Ratio from Screen between 0.0 and 1.0
  static double reduced(double ratio) {
    assert(ratio <= 1.0 && ratio > 0.0);
    var factor = Get.width * ratio;
    return Get.width - factor;
  }
}

/// * Class that Handles Device Screen Height Management * //
class Height {
  /// Return Full Screen Height
  static double get full => DeviceService.isDesktop ? 800 : Get.height;

  /// Return Full Screen Height Divided by Value <= ScreenHeight
  static double divided(double val) {
    assert(val <= Get.height);
    return Get.height / val;
  }

  /// Return Height as Ratio from Screen between 0.0 and 1.0
  static double ratio(double ratio) {
    assert(ratio <= 1.0 && ratio > 0.0);
    return Get.height * ratio;
  }

  /// Return Height reduced by given Ratio from Screen between 0.0 and 1.0
  static double reduced(double ratio) {
    assert(ratio <= 1.0 && ratio > 0.0);
    var factor = Get.height * ratio;
    return Get.height - factor;
  }
}

/// * Class that Handles Screen Margin Management * //
class Margin {
  static EdgeInsetsGeometry ratio(double vertical, {double horizontal = 24}) {
    var difference = Height.full - Height.ratio(vertical);
    return EdgeInsets.only(left: horizontal, right: horizontal, bottom: difference - horizontal, top: horizontal);
  }

  /// Return Margin as Ratio from Screen between 0.0 and 1.0 for Vertical, Horizontal defaults to 24
  /// Aligns to Center of Screen
  static EdgeInsetsGeometry ratioCentered(double vertical, {double horizontal = 24}) {
    var difference = Height.full - Height.ratio(vertical);
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: difference / 2);
  }
}
