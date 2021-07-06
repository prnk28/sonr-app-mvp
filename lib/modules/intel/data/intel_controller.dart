import 'dart:async';
import 'package:sonr_app/style/style.dart';

class IntelController extends GetxController with StateMixin<CompareLobbyResult> {
  // Properties
  final title = "".obs;
  final badgeVisible = false.obs;

  // Streams
  late StreamSubscription<Lobby?> _lobbyStream;
  late StreamSubscription<Status> _statusStream;

  // References
  Lobby _lastLobby = LobbyService.lobby.value;

  /// @ Controller Constructer
  @override
  onInit() {
    // Listen to Streams
    _lobbyStream = LobbyService.lobby.listen(_handleLobbyStream);
    _statusStream = NodeService.status.listen(_handleStatusStream);

    // Set Default Values
    _handleStatusStream(NodeService.status.value);
    change(CompareLobbyResult(current: LobbyService.lobby.value), status: RxStatus.loading());

    // Initialize
    super.onInit();
  }

  /// @ On Dispose
  @override
  void onClose() {
    _lobbyStream.cancel();
    _statusStream.cancel();
    super.onClose();
  }

  // @ Handle Size Update
  void _handleLobbyStream(Lobby onData) {
    // Check Valid
    final compareResult = CompareLobbyResult(current: onData, previous: _lastLobby);
    if (compareResult.hasLeft || compareResult.hasJoined) {
      // Swap Text
      HapticFeedback.mediumImpact();
      badgeVisible(true);

      // Change State
      change(
        compareResult,
        status: RxStatus.success(),
      );

      // Revert Text
      Future.delayed(1200.milliseconds, () {
        if (!isClosed) {
          badgeVisible(false);
        }
      });
    }

    // Update Reference
    _lastLobby = onData;
  }

  void _handleStatusStream(Status onData) {
    if (onData.isConnected) {
      // Update Title
      DeviceService.location.then((location) {
        location.initPlacemark().then((result) {
          if (result) {
            if (location.placemark.subLocality.isNotEmpty) {
              title(location.placemark.subLocality);
            } else if (location.placemark.locality.isNotEmpty) {
              title(location.placemark.locality);
            } else if (location.placemark.name.isNotEmpty) {
              title(location.placemark.name);
            }
          } else {
            title('Welcome');
          }
        });
      });

      // Check Lobby Size
      change(CompareLobbyResult(current: LobbyService.lobby.value, previous: _lastLobby),
          status: _lastLobby.isEmpty ? RxStatus.empty() : RxStatus.success());
    } else if (onData == Status.FAILED) {
      title("Failed");
    } else {
      title("Connecting");
    }
  }
}
