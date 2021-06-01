export 'button_view.dart';
export 'external_sheet.dart';
export 'share_controller.dart';
export 'share_view.dart';

import 'package:sonr_app/style/style.dart';
import 'share_view.dart';

class ShareView {
  /// Open ShareView without Redirect
  static void open() {
    Get.to(SharePopupView(isPopup: false), transition: Transition.downToUp, duration: 350.milliseconds);
  }

  /// Popup Stand alone share view with redirect
  static void popup() {
    Get.to(SharePopupView(isPopup: true), transition: Transition.downToUp, duration: 350.milliseconds);
  }
}
