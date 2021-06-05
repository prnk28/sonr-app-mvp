import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';

class Sheet {
  final Widget child;
  final bool dismissible;
  final bool persistent;
  final bool ignoreSafeArea;
  final bool forced;
  final double elevation;
  final Key? key;
  final Function(DismissDirection)? onDismissed;

  /// Checks Whether BottomSheet is Currently Open
  static bool get isOpen => Get.isBottomSheetOpen ?? false;

  /// Checks Whether BottomSheet is Currently Open
  static bool get isNotOpen => !isOpen;

  Sheet(this.child, this.dismissible, this.persistent, this.ignoreSafeArea, this.elevation, this.forced, this.key, this.onDismissed) {
    // Check if Forced Open
    if (forced) {
      close();
    }

    // Open Sheet
    if (!isOpen) {
      Get.bottomSheet(
          dismissible
              ? Dismissible(
                  key: key!,
                  child: child,
                  direction: DismissDirection.down,
                  onDismissed: onDismissed!,
                )
              : child,
          isDismissible: dismissible,
          persistent: persistent,
          barrierColor: SonrColor.Black.withOpacity(0.65),
          ignoreSafeArea: ignoreSafeArea,
          elevation: elevation);
    }
  }

  /// Opens a Persistent Bottom Sheet
  factory Sheet.persistent(Widget child, {bool forced = false, bool ignoreSafeArea = false, double elevation = 8}) {
    return Sheet(child, false, true, ignoreSafeArea, elevation, forced, null, null);
  }

  /// Opens a Dissmissable Bottom Sheet
  factory Sheet.dissmissible(Key key, Widget child, Function(DismissDirection)? onDismissed,
      {bool forced = false, bool ignoreSafeArea = false, double elevation = 8}) {
    return Sheet(child, true, false, ignoreSafeArea, elevation, forced, key, onDismissed);
  }

  /// Close the current active BottomSheet
  static void close() {
    if (isOpen) {
      Get.back(closeOverlays: true);
    }
  }
}
