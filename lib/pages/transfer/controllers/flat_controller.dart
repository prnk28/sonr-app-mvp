import 'dart:async';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';

/// ** Reactive Flat Mode Controller ** //
class FlatModeController extends GetxController {
  // Properties
  final received = Rx<Contact?>(null);
  final status = Rx<FlatModeState>(FlatModeState.Standby);
  final animation = Rx<FlatModeAnimation>(FlatModeAnimation(FlatModeTransition.Standby));
  final transition = Rx<FlatModeTransition>(FlatModeTransition.Standby);

  // Status Checkers
  bool get hasReceived => received.value != null;
  bool get isStandby => status.value == FlatModeState.Standby;
  bool get isDragging => status.value == FlatModeState.Dragging;
  bool get isPending => status.value == FlatModeState.Pending;
  bool get isReceiving => status.value == FlatModeState.Receiving;
  bool get isIncoming => status.value == FlatModeState.Incoming;
  bool get isDone => status.value == FlatModeState.Done;

  // References
  late StreamSubscription<bool> _isFlatStream;

  // # Initialize Service Method
  @override
  void onInit() {
    _isFlatStream = LocalService.isFlatMode.listen(_handleFlatMode);
    super.onInit();
  }

  // # On Service Close //
  @override
  void onClose() {
    _isFlatStream.cancel();
    super.onClose();
  }

  /// @ Method to Animate in Responded Card
  animateIn(Contact card, {double delayModifier = 1.0}) {
    received(card);
    Future.delayed(K_TRANSLATE_DURATION * delayModifier, () {
      transition(FlatModeTransition.SlideIn);
      animation(FlatModeAnimation(transition.value));
      status(FlatModeState.Incoming);
    });
  }

  /// @ Method to Animate in Invited Card
  animateSwap(Contact card) {
    // Set Received Card
    received(card);

    // Translate User Card Down
    transition(FlatModeTransition.SlideDown);
    animation(FlatModeAnimation(transition.value));
    status(FlatModeState.Receiving);

    Future.delayed(K_TRANSLATE_DURATION, () {
      // Hide Existing Card
      status(FlatModeState.Pending);

      // Slide In Received
      transition(FlatModeTransition.SlideInSingle);
      animation(FlatModeAnimation(transition.value));
      status(FlatModeState.Incoming);
    });
  }

  /// @ Method to Animate out Sent Card  and Update Drage Position
  setDrag(double y) {
    // @ Check for Valid State
    if (status.value == FlatModeState.Dragging || status.value == FlatModeState.Standby) {
      // # Before Drag Threshold
      if (y >= Get.height * 0.8) {
        HapticFeedback.heavyImpact();
        status(FlatModeState.Dragging);
      }
      // # Reached Drag Threshold
      else {
        status(FlatModeState.Outgoing);
        transition(FlatModeTransition.SlideOut);
        animation(FlatModeAnimation(transition.value));
        // No Peers
        if (LocalService.lobby.value.flatPeerCount() == 0) {
          Get.back();
          AppRoute.snack(SnackArgs.error("No Peers in Flat Mode"));
        } else if (LocalService.lobby.value.flatPeerCount() == 1) {
          if (Get.find<LocalService>().sendFlatMode(LocalService.lobby.value.flatFirst())) {
            Future.delayed(K_TRANSLATE_DURATION, () {
              status(FlatModeState.Pending);
            });
          }
        } else {
          AppRoute.snack(SnackArgs.error("Too Many Peers in Flat Mode"));
        }
      }
    }
  }

  // # Handle Flat Mode Status Change //
  _handleFlatMode(bool status) {
    if (!status && isStandby) {
      Get.back();
    }
  }
}
