import 'dart:async';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style/style.dart';

class PositionController extends GetxController {
  // @ Direction Properties
  final angle = 0.0.obs;
  final cardinalTitle = "".obs;
  final degrees = 0.0.obs;
  final direction = 0.0.obs;
  final directionTitle = "".obs;

  // @ Flat Mode Properties
  final status = FlatModeState.Standby.obs;
  final received = Rx<Contact?>(null);
  final animation = FlatModeAnimation(FlatModeTransition.Standby).obs;
  final transition = FlatModeTransition.Standby.obs;

  // @ Status Checkers
  bool get hasReceived => received.value != null;

  // Streams
  late StreamSubscription<Position> _positionStream;
  late StreamSubscription<bool> _isFlatStream;

  /// #### Controller Constructer
  @override
  void onInit() {
    _positionStream = DeviceService.position.listen(_handlePositionUpdate);
    _isFlatStream = LobbyService.isFlatMode.listen(_handleFlatMode);
    super.onInit();
  }

  /// #### On Dispose
  @override
  void onClose() {
    _positionStream.cancel();
    _isFlatStream.cancel();
    super.onClose();
  }

  /// #### Method to Animate in Responded Card
  animateFlatIn(Contact card, {double delayModifier = 1.0}) {
    received(card);
    Future.delayed(K_TRANSLATE_DURATION * delayModifier, () {
      transition(FlatModeTransition.SlideIn);
      animation(FlatModeAnimation(transition.value));
      status(FlatModeState.Incoming);
    });
  }

  /// #### Method to Animate in Invited Card
  animateFlatSwap(Contact card) {
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

  /// #### Method to Animate out Sent Card  and Update Drage Position
  void setFlatDrag(double y) {
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
        if (LobbyService.lobby.value.flatPeerCount() == 0) {
          Get.back();
          AppRoute.snack(SnackArgs.error("No Peers in Flat Mode"));
        } else if (LobbyService.lobby.value.flatPeerCount() == 1) {
          // if (Get.find<LobbyService>().sendFlatMode(LobbyService.lobby.value.flatFirst())) {
          //   Future.delayed(K_TRANSLATE_DURATION, () {
          //     status(FlatModeState.Pending);
          //   });
          // }
        } else {
          AppRoute.snack(SnackArgs.error("Too Many Peers in Flat Mode"));
        }
      }
    }
  }

  // # Handle Flat Mode Status Change //
  void _handleFlatMode(bool val) {
    if (!val && status.value.isStandby) {
      Get.back();
    }
  }

  // # Handle Compass Update
  void _handlePositionUpdate(Position pos) {
    // Update String Elements
    if (!isClosed) {
      // Set Titles
      directionTitle(pos.facing.prettyDirection());
      cardinalTitle(pos.facing.prettyCardinal());

      // Update Properties
      direction(pos.facing.direction);
      angle(pos.facing.angle);
      degrees(pos.facing.degrees);
    }
  }
}
