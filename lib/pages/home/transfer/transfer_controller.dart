import 'dart:async';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style/style.dart';

class TransferController extends GetxController {
  // @ Properties
  final title = "Sharing".obs;
  final subtitle = "Nobody Here".obs;
  final isFacingPeer = false.obs;
  final isNotEmpty = false.obs;

  // @ Remote Properties
  final counter = 0.obs;
  final remote = Rx<RemoteInfo?>(null);

  // @ Direction Properties
  final angle = 0.0.obs;
  final degrees = 0.0.obs;
  final direction = 0.0.obs;
  final isShiftingEnabled = true.obs;

  // @ View Properties
  final directionTitle = "".obs;
  final cardinalTitle = "".obs;

  // References
  late StreamSubscription<Lobby?> _lobbySizeStream;
  late StreamSubscription<Position> _positionStream;
  late StreamSubscription<Payload> _payloadStream;
  ScrollController scrollController = ScrollController();

  /// @ Controller Constructer
  void onInit() {
    // Set Initial Value
    _handlePositionUpdate(MobileService.position.value);
    _handleLobbyUpdate(LobbyService.local.value);

    // Add Stream Handlers
    _positionStream = MobileService.position.listen(_handlePositionUpdate);
    _lobbySizeStream = LobbyService.local.listen(_handleLobbyUpdate);
    _payloadStream = TransferService.payload.listen(_handlePayload);
    super.onInit();
  }

  /// @ On Dispose
  @override
  void onClose() {
    _positionStream.cancel();
    _lobbySizeStream.cancel();
    _payloadStream.cancel();
    super.onClose();
  }

  /// @ User is Facing or No longer Facing a Peer
  void setFacingPeer(bool value) {
    isFacingPeer(value);
    isFacingPeer.refresh();
  }

  /// @ Toggles Peer Shifting
  void toggleShifting() {
    isShiftingEnabled(!isShiftingEnabled.value);
  }

  // # Handle Compass Update
  _handlePositionUpdate(Position pos) {
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
  _handleLobbyUpdate(Lobby? data) {
    if (data != null && !isClosed) {
      isNotEmpty(data.isNotEmpty);
      subtitle(data.prettyCount());
    }
  }

  // # Updates Title Value by Payload
  void _handlePayload(Payload payload) {
    // Update Title
    switch (payload) {
      case Payload.CONTACT:
        title("Sharing Contact Card");
        break;
      case Payload.URL:
        title("Sending Link");
        break;
      default:
        if (TransferService.file.value.exists) {
          title("Sharing " + TransferService.file.value.prettyType());
        }
    }
  }
}
