import 'package:sonr_app/modules/authorize/authorize.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style.dart';

/// ** Flat Mode Handler ** //
class FlatMode {
  static outgoing() {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        _FlatModeView(),
        barrierColor: Colors.transparent,
        useSafeArea: false,
      );
    }
  }

  static response(Contact data) {
    Get.find<FlatModeController>().animateIn(data, delayModifier: 2);
  }

  static invite(Contact data) {
    Get.find<FlatModeController>().animateSwap(data);
  }
}


/// ** Flat Mode View ** //
class _FlatModeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<FlatModeController>(
      init: FlatModeController(),
      autoRemove: false,
      builder: (controller) {
        return GestureDetector(
          onTap: () => Get.find<LocalService>().cancelFlatMode(),
          child: Container(
              width: Get.width,
              height: Get.height,
              color: Colors.black87,
              padding: EdgeInsets.all(24),
              child: AnimatedSwitcher(
                  duration: K_TRANSLATE_DURATION,
                  switchOutCurve: controller.animation.value.switchOutCurve,
                  switchInCurve: controller.animation.value.switchInCurve,
                  transitionBuilder: controller.animation.value.transition(),
                  layoutBuilder: controller.animation.value.layout() as Widget Function(Widget?, List<Widget>),
                  child: _buildChild(controller))),
        );
      },
    );
  }

  // # Build Stack Child View for Flat View //
  Widget _buildChild(FlatModeController controller) {
    if (controller.isIncoming) {
      return ContactFlatCard(controller.received.value, key: ValueKey<FlatModeState>(controller.status.value), scale: 0.9);
    } else if (controller.isPending) {
      return Container(key: ValueKey<FlatModeState>(controller.status.value));
    } else if (controller.isReceiving) {
      return ContactFlatCard(ContactService.contact.value, key: ValueKey<FlatModeState>(controller.status.value), scale: 0.9);
    } else {
      return Draggable(
        key: ValueKey<FlatModeState>(controller.status.value),
        child: ContactFlatCard(ContactService.contact.value, scale: 0.9),
        feedback: ContactFlatCard(ContactService.contact.value, scale: 0.9),
        childWhenDragging: Container(),
        axis: Axis.vertical,
        onDragUpdate: (details) {
          controller.setDrag(details.globalPosition.dy);
        },
      );
    }
  }
}
