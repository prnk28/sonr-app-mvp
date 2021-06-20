import 'dart:async';
import 'package:sonr_app/pages/transfer/models/arguments.dart';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style.dart';

class TransferController extends GetxController {
  // @ Global Property Accessor
  static InviteRequest get invite => Get.find<TransferController>().inviteRequest;

  // @ Properties
  final title = "Nobody Here".obs;
  final isFacingPeer = false.obs;
  final isNotEmpty = false.obs;
  final centerKey = ValueKey("").obs;

  // @ Direction Properties
  final angle = 0.0.obs;
  final cardinalTitle = "".obs;
  final degrees = 0.0.obs;
  final desktopsEnabled = true.obs;
  final direction = 0.0.obs;
  final directionTitle = "".obs;
  final hasInvite = false.obs;
  final phonesEnabled = true.obs;

  // @ FlatMode Properties
  final received = Rx<Contact?>(null);
  final status = FlatModeState.Standby.obs;
  final animation = FlatModeAnimation(FlatModeTransition.Standby).obs;
  final transition = FlatModeTransition.Standby.obs;

  // @ Status Checkers
  bool get hasReceived => received.value != null;

  // References
  late StreamSubscription<Lobby?> _lobbySizeStream;
  late StreamSubscription<Position> _positionStream;
  late StreamSubscription<Payload> _payloadStream;
  late InviteRequest inviteRequest;
  final localArrowButtonKey = GlobalKey();
  ScrollController scrollController = ScrollController();
  late StreamSubscription<bool> _isFlatStream;

  /// @ Controller Constructer
  @override
  void onInit() {
    // Set Initial Value
    _handlePositionUpdate(DeviceService.position.value);
    _handleLobbyUpdate(LocalService.lobby.value);

    // Add Stream Handlers
    _positionStream = DeviceService.position.listen(_handlePositionUpdate);
    _lobbySizeStream = LocalService.lobby.listen(_handleLobbyUpdate);
    _isFlatStream = LocalService.isFlatMode.listen(_handleFlatMode);
    super.onInit();
  }

  /// @ On Dispose
  @override
  void onClose() {
    _lobbySizeStream.cancel();
    _payloadStream.cancel();
    _positionStream.cancel();
    _isFlatStream.cancel();
    super.onClose();
  }

  /// @ First Method Called
  void initialize() {
    final args = Get.arguments;
    if (args is TransferArguments) {
      inviteRequest = args.request;
      hasInvite(true);
    } else {
      hasInvite(false);
    }
  }

  /// @ Method to Animate in Responded Card
  animateFlatIn(Contact card, {double delayModifier = 1.0}) {
    received(card);
    Future.delayed(K_TRANSLATE_DURATION * delayModifier, () {
      transition(FlatModeTransition.SlideIn);
      animation(FlatModeAnimation(transition.value));
      status(FlatModeState.Incoming);
    });
  }

  /// @ Method to Animate in Invited Card
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

  /// @ Closes Window for Transfer Page
  void closeToHome() {
    AppPage.Home.off();
  }

  void onLocalArrowPressed() {
    AppRoute.positioned(
      Checklist(
          options: [
            ChecklistOption("Phones", phonesEnabled),
            ChecklistOption("Desktops", desktopsEnabled),
          ],
          onSelectedOption: (index) {
            print(index);
          }),
      offset: Offset(-80, -10),
      parentKey: localArrowButtonKey,
    );
  }

  /// @ User is Facing or No longer Facing a Peer
  void setFacingPeer(bool value) {
    isFacingPeer(value);
    isFacingPeer.refresh();
  }

  /// @ Method to Animate out Sent Card  and Update Drage Position
  setFlatDrag(double y) {
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
  _handleFlatMode(bool val) {
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

  // # Handle Lobby Size Update
  void _handleLobbyUpdate(Lobby data) {
    if (!isClosed) {
      // Set Strings
      isNotEmpty(data.isNotEmpty);
    }
  }
}
