import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';

class Popup {
  final Widget child;
  final bool dismissible;
  final bool ignoreSafeArea;

  /// Checks Whether BottomSheet is Currently Open
  static bool get isOpen => Get.isDialogOpen ?? false;

  /// Checks Whether BottomSheet is Currently Open
  static bool get isNotOpen => !isOpen;

  Popup(
    this.child,
    this.dismissible,
    this.ignoreSafeArea,
  ) {
    // Open Sheet
    if (!isOpen) {
      Get.dialog(
        child,
        barrierDismissible: dismissible,
        barrierColor: SonrColor.Black.withOpacity(0.65),
        useSafeArea: !ignoreSafeArea,
      );
    }
  }

  /// Opens a Persistent Bottom Sheet
  factory Popup.open(Widget child, {bool ignoreSafeArea = false, bool dismissible = true}) {
    return Popup(
      child,
      dismissible,
      ignoreSafeArea,
    );
  }

  /// Close the current active BottomSheet
  static void close() {
    if (isOpen) {
      Get.back(closeOverlays: true);
    }
  }
}
