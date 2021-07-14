import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style/style.dart';

/// ### Flat Mode View
class FlatModeOverlay extends GetView<PositionController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => Get.find<LobbyService>().cancelFlatMode(),
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
                child: _FlatModeCard(),
              )),
        ));
  }
}

class _FlatModeCard extends GetView<PositionController> {
  @override
  Widget build(BuildContext context) {
    if (controller.status.value.isIncoming) {
      return ContactContent(controller.received.value, key: ValueKey<FlatModeState>(controller.status.value), scale: 0.9);
    } else if (controller.status.value.isPending) {
      return Container(key: ValueKey<FlatModeState>(controller.status.value));
    } else if (controller.status.value.isReceiving) {
      return ContactContent(ContactService.contact.value, key: ValueKey<FlatModeState>(controller.status.value), scale: 0.9);
    } else {
      return Draggable(
        key: ValueKey<FlatModeState>(controller.status.value),
        child: ContactContent(ContactService.contact.value, scale: 0.9),
        feedback: ContactContent(ContactService.contact.value, scale: 0.9),
        childWhenDragging: Container(),
        axis: Axis.vertical,
        onDragUpdate: (details) {
          controller.setFlatDrag(details.globalPosition.dy);
        },
      );
    }
  }
}
