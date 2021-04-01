// ^ Class Builds Flat Overlay View ** //
import 'dart:async';

import 'package:animated_widgets/animated_widgets.dart';
import '../theme.dart';

enum FlatModeState { Standby, Dragging, Animate, Pending, Empty, Done }
const K_TRANSLATE_DELAY = const Duration(milliseconds: 50);
const K_TRANSLATE_DURATION = const Duration(milliseconds: 300);

class FlatModeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<_FlatModeController>(
      global: false,
      init: _FlatModeController(),
      builder: (controller) {
        return Container(
            width: Get.width,
            height: Get.height,
            color: Colors.black87,
            child: Stack(alignment: Alignment.bottomCenter, children: [
              TranslationAnimatedWidget(
                enabled: controller.isAnimatingOut,
                delay: K_TRANSLATE_DELAY,
                duration: K_TRANSLATE_DURATION,
                curve: Curves.easeIn,
                values: [
                  Offset(0, -1 * controller.lastYPos.value), // disabled value value
                  Offset(0, (-1 * Get.height)) //enabled value
                ],
                child: Draggable(
                  child: ContactCard.flat(UserService.current.contact, scale: 0.9),
                  feedback: ContactCard.flat(UserService.current.contact, scale: 0.9),
                  childWhenDragging: Container(),
                  axis: Axis.vertical,
                  onDragUpdate: (details) {
                    if (details.globalPosition.dy >= Get.height * 0.6) {
                      HapticFeedback.heavyImpact();
                      controller.setDragging(true);
                    } else {
                      controller.animateOut(details.globalPosition.dy);
                    }
                  },
                  onDragCompleted: () {
                    controller.setDragging(false);
                  },
                ),
              )
            ]));
      },
    );
  }
}

class _FlatModeController extends GetxController {
  // Properties
  final lastYPos = 0.0.obs;
  final status = Rx<FlatModeState>(FlatModeState.Standby);

  // Status Checkers
  bool get isStandby => status.value == FlatModeState.Standby;
  bool get isDragging => status.value == FlatModeState.Dragging;
  bool get isAnimatingOut => status.value == FlatModeState.Animate;
  bool get isPending => status.value == FlatModeState.Pending;

  // References
  StreamSubscription<bool> _isFlatStream;

  // # Initialize Service Method ^ //
  @override
  void onInit() {
    _isFlatStream = LobbyService.isFlatMode.listen(_handleFlatMode);
    super.onInit();
  }

  // # On Service Close //
  @override
  void onClose() {
    _isFlatStream.cancel();
    super.onClose();
  }

  // ^ Method to Animate out View ^ //
  animateOut(double lastY) {
    lastYPos(lastY);
    status(FlatModeState.Animate);
    Future.delayed(K_TRANSLATE_DURATION + K_TRANSLATE_DELAY, () {
      if (LobbyService.localFlatPeers.length == 0) {
        Get.back();
        SonrSnack.error("No Peers in Flat Mode");
      } else if (LobbyService.localFlatPeers.length == 1) {
        var result = Get.find<LobbyService>().sendFlatMode(LobbyService.localFlatPeers.values.first);
        if (!result) {
          status(FlatModeState.Standby);
        }
      } else {
        status(FlatModeState.Standby);
        SonrSnack.error("Too Many Peers in Flat Mode");
      }
    });
  }

  // ^ Method to Animate out View ^ //
  setDragging(bool dragging) {
    // Set to Dragging if Standby
    if (dragging && status.value == FlatModeState.Standby) {
      status(FlatModeState.Dragging);
    }

    // Reset State if Not Animating
    if (!dragging) {
      Future.delayed(30.milliseconds, () {
        status(FlatModeState.Standby);
      });
    }
  }

  // # Handle Flat Mode Status Change //
  _handleFlatMode(bool status) {
    if (!status && isStandby) {
      Get.back();
    }
  }
}
