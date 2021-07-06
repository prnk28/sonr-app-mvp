import 'dart:async';
import 'package:sonr_app/style/style.dart';

class IntelController extends GetxController with StateMixin<CompareLobbyResult> {
  // Properties
  final title = "".obs;
  final badgeVisible = false.obs;

  // References
  late StreamSubscription<Lobby?> _lobbyStream;
  Lobby _lastLobby = LobbyService.lobby.value;

  /// @ Controller Constructer
  @override
  onInit() {
    // Handle Streams
    _lobbyStream = LobbyService.lobby.listen(_handleLobbyStream);

    // Check Lobby Size
    if (LobbyService.lobby.value.count > 0) {
      change(CompareLobbyResult(current: LobbyService.lobby.value), status: RxStatus.success());
    } else {
      change(CompareLobbyResult(current: LobbyService.lobby.value), status: RxStatus.empty());
    }

    // Initialize
    super.onInit();
  }

  /// @ On Dispose
  @override
  void onClose() {
    _lobbyStream.cancel();
    super.onClose();
  }

  // @ Handle Size Update
  _handleLobbyStream(Lobby onData) {
    // Check Valid
    if (!badgeVisible.value && !isClosed) {
      final compareResult = CompareLobbyResult(current: onData, previous: _lastLobby);

      if (!compareResult.hasStayed) {
        // Swap Text
        HapticFeedback.mediumImpact();
        badgeVisible(true);

        // Revert Text
        Future.delayed(800.milliseconds, () {
          if (!isClosed) {
            badgeVisible(false);
          }
        });

        // Change State
        change(
            CompareLobbyResult(
              current: onData,
              previous: _lastLobby,
            ),
            status: RxStatus.success());
      }

      // Update Reference
      _lastLobby = onData;
    }
  }
}
