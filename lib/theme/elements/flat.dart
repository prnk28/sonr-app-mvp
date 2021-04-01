import 'dart:async';
import '../theme.dart';

enum FlatModeState { Standby, Dragging, Outgoing, Empty, Pending, Incoming, Exchanging, Done }

class FlatMode {
  static outgoing() {
    Get.dialog(_FlatModeView(), barrierColor: Colors.transparent, barrierDismissible: false, useSafeArea: false);
  }

  static incoming(TransferCard data) {
    Get.find<_FlatModeController>().animateIn(data.contact);
  }

  static receiving(TransferCard data) {
    Get.find<_FlatModeController>().animateIn(data.contact);
  }
}

const K_TRANSLATE_DELAY = const Duration(milliseconds: 50);
const K_TRANSLATE_DURATION = const Duration(milliseconds: 300);

// ^ Class Builds Flat Overlay View ** //
class _FlatModeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<_FlatModeController>(
      init: _FlatModeController(),
      autoRemove: false,
      builder: (controller) {
        return Container(
            width: Get.width,
            height: Get.height,
            color: Colors.black87,
            child: Stack(alignment: Alignment.bottomCenter, children: [
              TranslationAnimatedWidget(
                enabled: controller.isAnimating,
                delay: K_TRANSLATE_DELAY,
                duration: K_TRANSLATE_DURATION,
                curve: Curves.easeIn,
                values: controller.animation,
                child: controller.isIncoming
                    ? ContactCard.flat(controller.received.value, scale: 0.9)
                    : SonrAnimatedSwitcher.slideDown(
                        child: controller.hasReceived
                            ? ContactCard.flat(controller.received.value, key: ValueKey<bool>(controller.hasReceived))
                            : Draggable(
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
                      ),
              )
            ]));
      },
    );
  }

  _buildView(_FlatModeController controller) {
    if (controller.status.value == FlatModeState.Incoming ||
        controller.status.value == FlatModeState.Outgoing ||
        controller.status.value == FlatModeState.Exchanging) {
    } else if (controller.status.value == FlatModeState.Exchanging) {
      return SonrAnimatedSwitcher.slideDown(
          child: controller.hasReceived ? ContactCard.flat(controller.received.value) : ContactCard.flat(controller.received.value));
    }
  }
}

class _FlatModeController extends GetxController {
  // Properties
  final animation = RxList<Offset>([Offset(0, 0)]);
  final received = Rx<Contact>();
  final status = Rx<FlatModeState>(FlatModeState.Standby);

  // Status Checkers
  bool get hasReceived => received.value != null;
  bool get isExchanging => status.value == FlatModeState.Exchanging;
  bool get isStandby => status.value == FlatModeState.Standby;
  bool get isDragging => status.value == FlatModeState.Dragging;
  bool get isAnimating => status.value == FlatModeState.Outgoing || status.value == FlatModeState.Incoming;
  bool get isPending => status.value == FlatModeState.Pending;
  bool get isIncoming => status.value == FlatModeState.Incoming;
  bool get isComplete => status.value == FlatModeState.Done;

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

  // ^ Method to Animate in Responded Card ^ //
  animateIn(Contact card) {
    received(card);
    animation([
      Offset(0, 1 * Get.height), // disabled value value
      Offset(0, (1 * Get.height / 2))
    ]);
    animation.refresh();
    status(FlatModeState.Incoming);
    Future.delayed(K_TRANSLATE_DURATION + K_TRANSLATE_DELAY, () {
      status(FlatModeState.Done);
    });
  }

  // ^ Method to Animate in Responded Card ^ //
  animateInOut(Contact card) {
    received(card);
    status(FlatModeState.Exchanging);
    Future.delayed(K_TRANSLATE_DURATION + K_TRANSLATE_DELAY, () {
      status(FlatModeState.Done);
    });
  }

  // ^ Method to Animate out Sent Card ^ //
  animateOut(double lastY) {
    animation([
      Offset(0, -1 * lastY), // disabled value value
      Offset(0, (-1 * Get.height))
    ]);
    animation.refresh();
    status(FlatModeState.Outgoing);
    Future.delayed(K_TRANSLATE_DURATION + K_TRANSLATE_DELAY, () {
      if (LobbyService.localFlatPeers.length == 0) {
        Get.back();
        SonrSnack.error("No Peers in Flat Mode");
      } else if (LobbyService.localFlatPeers.length == 1) {
        var result = Get.find<LobbyService>().sendFlatMode(LobbyService.localFlatPeers.values.first);
        if (!result) {
          status(FlatModeState.Standby);
        } else {
          status(FlatModeState.Pending);
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
