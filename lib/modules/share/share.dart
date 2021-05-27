export 'button_view.dart';
export 'external_sheet.dart';
export 'share_controller.dart';
export 'share_view.dart';

import 'package:sonr_app/style/style.dart';
import 'share_controller.dart';
import 'share_view.dart';

class Share {
  /// Open ShareView without Redirect
  static void open() {
    Get.find<ShareController>().reset(close: false, popup: false);
    Get.to(SharePopupView(), transition: Transition.downToUp, duration: 350.milliseconds);
  }

  /// Popup Stand alone share view with redirect
  static void popup() {
    Get.find<ShareController>().reset(close: false);
    Get.to(SharePopupView(), transition: Transition.downToUp, duration: 350.milliseconds);
  }
}
