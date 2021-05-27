export 'button_view.dart';
export 'external_sheet.dart';
export 'share_controller.dart';
export 'share_view.dart';

import 'package:sonr_app/style/style.dart';
import 'share_controller.dart';
import 'share_view.dart';

class Share {
  /// Opens Stand alone share popup with redirect
  static void popup() {
    Get.find<ShareController>().reset(withClose: false);
    Get.to(SharePopupView(), transition: Transition.downToUp, duration: 350.milliseconds);
  }
}
