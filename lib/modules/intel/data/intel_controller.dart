import 'dart:async';
import 'package:sonr_app/modules/intel/intel.dart';
import 'package:sonr_app/style/style.dart';

class IntelController extends GetxController with StateMixin<LobbyInfo> {
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
      change(LobbyInfo(newLobby: LobbyService.lobby.value), status: RxStatus.success());
    } else {
      change(LobbyInfo(newLobby: LobbyService.lobby.value), status: RxStatus.empty());
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
      // Check Lobby Size
      if (onData.count > 0) {
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
            LobbyInfo(
              newLobby: onData,
              lastLobby: _lastLobby,
            ),
            status: RxStatus.success());
      } else {
        // Change State
        change(
          LobbyInfo(),
          status: RxStatus.empty(),
        );
      }

      // Update Reference
      _lastLobby = onData;
    }
  }
}
