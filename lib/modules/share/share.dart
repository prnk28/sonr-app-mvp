export 'button_view.dart';
export 'external_sheet.dart';
export 'share_controller.dart';
export 'share_view.dart';

import 'package:sonr_app/style/style.dart';
import 'share_controller.dart';
import 'share_view.dart';

class ShareView {
  /// Open ShareView without Redirect
  static void dialog() {
    ShareController.initDialog();
    Get.to(SharePopupView(), transition: Transition.downToUp, duration: 350.milliseconds);
  }

  /// Popup Stand alone share view with redirect
  static void popup() {
    ShareController.initPopup();
    Get.to(SharePopupView(), transition: Transition.downToUp, duration: 350.milliseconds);
  }
}
