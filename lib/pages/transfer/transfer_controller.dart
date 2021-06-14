import 'dart:async';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style.dart';

class TransferController extends GetxController {
  // @ Properties
  final title = "Nobody Here".obs;
  final isFacingPeer = false.obs;
  final isNotEmpty = false.obs;
  final centerKey = ValueKey("").obs;

  // @ Direction Properties
  final angle = 0.0.obs;
  final degrees = 0.0.obs;
  final direction = 0.0.obs;

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
    super.onInit();
  }

  /// @ On Dispose
  @override
  void onClose() {
    _lobbySizeStream.cancel();
    _payloadStream.cancel();
    _positionStream.cancel();
    super.onClose();
  }

  /// @ Closes Window for Transfer Page
  void closeToHome() {
    TransferService.resetPayload();
    AppPage.Home.off();
  }

  /// @ User is Facing or No longer Facing a Peer
  void setFacingPeer(bool value) {
    isFacingPeer(value);
    isFacingPeer.refresh();
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
