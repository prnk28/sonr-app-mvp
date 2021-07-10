
import 'package:sonr_app/style/style.dart';

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
