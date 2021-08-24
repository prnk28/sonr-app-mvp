import 'dart:async';
import 'package:sonr_app/style/style.dart';

class IntelController extends GetxController with StateMixin<CompareLobbyResult> {
  // Properties
  final title = "".obs;
  final badgeVisible = false.obs;
  final isConnecting = true.obs;
  final hasFailed = false.obs;

  // Streams
  late Location _lastLocation;
  late StreamSubscription<Lobby> _lobbyStream;
  late StreamSubscription<Status> _statusStream;

  // References
  Lobby _lastLobby = Lobby();
  int _lastLobbyCount = 0;

  /// #### Controller Constructer
  @override
  onInit() {
    // Listen to Streams
    _lobbyStream = LobbyService.lobby.listen(_handleLobbyStream);
    _statusStream = NodeService.status.listen(_handleStatusStream);

    // Set Default Values
    if (isConnecting.value) {
      _handleStatusStream(NodeService.status.value);
      _handleLobbyStream(LobbyService.lobby.value);
    }

    // Initialize
    super.onInit();
  }

  /// #### On Dispose
  @override
  void onClose() {
    _lobbyStream.cancel();
    _statusStream.cancel();
    super.onClose();
  }

  // # Method Handles Lobby Size Update
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
      status: onData.members.length == 0 ? RxStatus.empty() : RxStatus.success(),
    );

    // Update Reference
    _lastLobbyCount = onData.count;
    _lastLobby = onData;
  }

  // # Method Handles Updated Status
  void _handleStatusStream(Status onData) {
    if (isConnecting.value) {
      if (onData.isAvailable) {
        // Check Lobby Size
        _handleAvailable();
      } else if (onData == Status.FAILED) {
        title("Failed");
        isConnecting(false);
        hasFailed(true);
      } else {
        isConnecting(true);
      }
    }
  }

  // # Method Handles Succesful Connection
  void _handleAvailable() async {
    // Find Location
    _lastLocation = await DeviceService.location;
    final result = await _lastLocation.lowestPlacemarkName();

    // Set Title
    if (result.isNotEmpty) {
      title(result);
    }
    // No PlaceMark Found
    else {
      title('Welcome');
    }

    // Update Lobby Stream
    isConnecting(false);
    _handleLobbyStream(LobbyService.lobby.value);
  }
}
