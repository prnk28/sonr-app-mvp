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
  int _lastLobbyCount = 0;

  /// @ Controller Constructer
  @override
  onInit() {
    // Listen to Streams
    _lobbyStream = LobbyService.lobby.listen(_handleLobbyStream);
    _statusStream = NodeService.status.listen(_handleStatusStream);

    // Set Default Values
    _handleStatusStream(NodeService.status.value);

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

    if (onData.count != _lastLobbyCount) {
      // Swap Text
      HapticFeedback.mediumImpact();
      badgeVisible(true);

      // Revert Text
      Future.delayed(1200.milliseconds, () {
        if (!isClosed) {
          badgeVisible(false);
        }
      });
    }

    // Change State
    change(
      compareResult,
      status: onData.isEmpty ? RxStatus.empty() : RxStatus.success(),
    );

    // Update Reference
    _lastLobby = onData;
    _lastLobbyCount = onData.count;
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
      _handleLobbyStream(LobbyService.lobby.value);
    } else if (onData == Status.FAILED) {
      title("Failed");
    } else {
      title("Connecting");
    }
  }
}
