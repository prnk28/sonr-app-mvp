export 'button_view.dart';
export '../common/media/media_view.dart';
export 'option_button.dart';
export 'share_controller.dart';
export 'sheet_view.dart';

// ** Share State Extension ** //
import 'package:sonr_app/theme/theme.dart';

enum ShareStatus { Default, Queue, PickMedia }

extension ShareStatusUtils on ShareStatus {
  bool get isExpanded => this != ShareStatus.Default;
  bool get isOverflow => this != ShareStatus.Default || this != ShareStatus.Queue;

  // @ Method Builds Alignment for Status
  Alignment get alignment {
    switch (this) {
      case ShareStatus.PickMedia:
        return Alignment.center;
        break;
      case ShareStatus.Queue:
        return Alignment.bottomCenter;
        break;

      default:
        return Alignment.bottomCenter;
    }
  }

  // @ Method Builds Size for Status
  Size get size {
    switch (this) {
      case ShareStatus.Queue:
        return Size(Get.width / 2 + 165, 110);
        break;
      case ShareStatus.PickMedia:
        return Size(Get.width * 0.9, Get.height * 0.65);
        break;
      default:
        return Size(60, 60);
    }
  }

  // @ Method Builds Position for Status
  Matrix4 get translation {
    switch (this) {
      case ShareStatus.Queue:
        return Matrix4.translationValues(0, -30, 0);
      case ShareStatus.PickMedia:
        return Matrix4.translationValues(0, 40, 0);
      default:
        return Matrix4.translationValues(0, -30, 0);
    }
  }
}
