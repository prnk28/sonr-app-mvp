import 'dart:async';
import 'package:sonr_app/modules/authorize/contact_auth.dart';
import 'package:sonr_app/style.dart';

enum FlatModeState { Standby, Dragging, Empty, Outgoing, Pending, Receiving, Incoming, Done }
enum FlatModeTransition { Standby, SlideIn, SlideOut, SlideDown, SlideInSingle }

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
    Get.find<_FlatModeController>().animateIn(data, delayModifier: 2);
  }

  static invite(Contact data) {
    Get.find<_FlatModeController>().animateSwap(data);
  }
}

const K_TRANSLATE_DELAY = Duration(milliseconds: 150);
const K_TRANSLATE_DURATION = Duration(milliseconds: 600);

/// ** Flat Mode View ** //
class _FlatModeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<_FlatModeController>(
      init: _FlatModeController(),
      autoRemove: false,
      builder: (controller) {
        return GestureDetector(
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
                  child: _buildChild(controller))),
        );
      },
    );
  }

  // # Build Stack Child View for Flat View //
  Widget _buildChild(_FlatModeController controller) {
    if (controller.isIncoming) {
      return ContactFlatCard(controller.received.value, key: ValueKey<FlatModeState>(controller.status.value), scale: 0.9);
    } else if (controller.isPending) {
      return Container(key: ValueKey<FlatModeState>(controller.status.value));
    } else if (controller.isReceiving) {
      return ContactFlatCard(UserService.contact.value, key: ValueKey<FlatModeState>(controller.status.value), scale: 0.9);
    } else {
      return Draggable(
        key: ValueKey<FlatModeState>(controller.status.value),
        child: ContactFlatCard(UserService.contact.value, scale: 0.9),
        feedback: ContactFlatCard(UserService.contact.value, scale: 0.9),
        childWhenDragging: Container(),
        axis: Axis.vertical,
        onDragUpdate: (details) {
          controller.setDrag(details.globalPosition.dy);
        },
      );
    }
  }
}

/// ** Reactive Flat Mode Controller ** //
class _FlatModeController extends GetxController {
  // Properties
  final received = Rx<Contact?>(null);
  final status = Rx<FlatModeState>(FlatModeState.Standby);
  final animation = Rx<_FlatModeAnimation>(_FlatModeAnimation(FlatModeTransition.Standby));
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
    _isFlatStream = LobbyService.isFlatMode.listen(_handleFlatMode);
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
      animation(_FlatModeAnimation(transition.value));
      status(FlatModeState.Incoming);
    });
  }

  /// @ Method to Animate in Invited Card
  animateSwap(Contact card) {
    // Set Received Card
    received(card);

    // Translate User Card Down
    transition(FlatModeTransition.SlideDown);
    animation(_FlatModeAnimation(transition.value));
    status(FlatModeState.Receiving);

    Future.delayed(K_TRANSLATE_DURATION, () {
      // Hide Existing Card
      status(FlatModeState.Pending);

      // Slide In Received
      transition(FlatModeTransition.SlideInSingle);
      animation(_FlatModeAnimation(transition.value));
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
        animation(_FlatModeAnimation(transition.value));
        // No Peers
        if (LobbyService.local.value.flatPeerCount() == 0) {
          Get.back();
          AppRoute.snack(SnackArgs.error("No Peers in Flat Mode"));
        } else if (LobbyService.local.value.flatPeerCount() == 1) {
          if (Get.find<LobbyService>().sendFlatMode(LobbyService.local.value.flatFirst())) {
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

/// @ Method Builds Slide Transition
class _FlatModeAnimation {
  final FlatModeTransition type;
  _FlatModeAnimation(this.type);

  Curve get switchOutCurve {
    return Curves.easeOut;
  }

  Curve get switchInCurve {
    return Curves.easeIn;
  }

  // # Helper to Find End Offset
  TweenSequence<Offset> _buildTweenSequence() {
    switch (this.type) {
      // @ Slide In
      case FlatModeTransition.SlideIn:
        return TweenSequence([
          TweenSequenceItem(tween: Offset(0, -1).tweenTo(Offset(0.0, 0.0)), weight: 1),
          TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 1),
        ]);

      // @ Slide In Single
      case FlatModeTransition.SlideInSingle:
        return TweenSequence([
          TweenSequenceItem(tween: Offset(0, -1).tweenTo(Offset(0.0, 0.0)), weight: 1),
          TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 1),
        ]);

      // @ Slide Out
      case FlatModeTransition.SlideOut:
        return TweenSequence([
          TweenSequenceItem(tween: Offset(0, 0.5).tweenTo(Offset(0.0, -1)), weight: 1),
          TweenSequenceItem(tween: ConstantTween(Offset(0.0, -1)), weight: 1),
        ]);

      // @ Slide Down
      case FlatModeTransition.SlideDown:
        return TweenSequence([
          TweenSequenceItem(tween: Offset(0, 0.0).tweenTo(Offset(0.0, 1)), weight: 1),
          TweenSequenceItem(tween: ConstantTween(Offset(0.0, 1)), weight: 1),
        ]);

      default:
        return TweenSequence([TweenSequenceItem(tween: ConstantTween(Offset(0.0, 0.0)), weight: 1)]);
    }
  }

  // # Switcher Transition Method
  Widget Function(Widget, Animation<double>) transition() {
    return (Widget child, Animation<double> animation) {
      final offsetAnimation = _buildTweenSequence().animate(animation);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    };
  }

  // # Switcher Layout Method
  Widget? Function(Widget? currentChild, List<Widget> previousChildren) layout() {
    return (Widget? currentChild, List<Widget> previousChildren) {
      if (type == FlatModeTransition.SlideIn) {
        List<Widget> children = previousChildren;
        if (currentChild != null) children = children.toList()..add(currentChild);
        return Stack(
          children: children,
          alignment: Alignment.center,
        );
      } else if (type == FlatModeTransition.Standby) {
        return Align(alignment: Alignment.bottomCenter, child: Container(child: currentChild, padding: EdgeWith.bottom(48)));
      } else if (type == FlatModeTransition.SlideDown) {
        return currentChild;
      } else if (type == FlatModeTransition.SlideInSingle) {
        return Center(child: currentChild);
      } else {
        return Center(child: currentChild);
      }
    };
  }
}
