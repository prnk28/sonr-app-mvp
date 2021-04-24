export 'share_view.dart';
export 'option_button.dart';
export 'share_controller.dart';
export 'sheet_view.dart';

// ** Share State Extension ** //
import 'package:sonr_app/theme/theme.dart';

enum ShareStatus { Default, Queue }

extension ShareStatusUtils on ShareStatus {
  bool get isExpanded => this != ShareStatus.Default;

  // @ Method Builds Size for Status
  Size get size {
    switch (this) {
      case ShareStatus.Queue:
        return Size(Get.width / 2 + 200, 110);
        break;
      default:
        return Size(60, 60);
    }
  }
}
