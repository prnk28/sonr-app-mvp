import 'dart:async';
import 'package:sonr_app/modules/intel/intel.dart';
import 'package:sonr_app/style/style.dart';

class IntelController extends GetxController with StateMixin<LobbyInfo> {
  // Properties
  final title = "Home".obs;
  final subtitle = "".obs;
  final sonrStatus = Rx<Status>(NodeService.status.value);

  // References
  late StreamSubscription<Lobby?> _lobbyStream;
  late StreamSubscription<Status> _statusStream;
  int _lastCount = 0;
  bool _timeoutActive = false;

  /// @ Controller Constructer
  @override
  onInit() {
    // Handle Streams
    _lobbyStream = LobbyService.lobby.listen(_handleLobbyStream);
    _statusStream = NodeService.status.listen(_handleStatus);

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

  // @ Swaps Title when Lobby Size Changes
  void swapTitleText(String val, {Duration timeout = const Duration(milliseconds: 3500)}) {
    // Check Valid
    if (!_timeoutActive && !isClosed) {
      // Swap Text
      title(val);
      HapticFeedback.mediumImpact();
      _timeoutActive = true;

      // Revert Text
      Future.delayed(timeout, () {
        if (!isClosed) {
          title("${LobbyService.lobby.value.count} Around");
          _timeoutActive = false;
        }
      });
    }
  }

  // @ Handle Size Update
  _handleLobbyStream(Lobby? onData) {
    // Peer Joined
    if (onData!.count > _lastCount) {
      var diff = onData.count - _lastCount;
      swapTitleText("$diff Joined");
      DeviceService.playSound(type: Sounds.Joined);
    }
    // Peer Left
    else if (onData.count < _lastCount) {
      var diff = _lastCount - onData.count;
      swapTitleText("$diff Left");
    }
    _lastCount = onData.count;
  }

  // @ Handle Status Update
  _handleStatus(Status val) {
    sonrStatus(val);
    if (val.isConnected) {
      // Entry Text
      title("${LobbyService.lobby.value.count} Nearby");
      _timeoutActive = true;

      // Revert Text
      Future.delayed(const Duration(milliseconds: 3500), () {
        if (!isClosed) {

          _timeoutActive = false;
        }
      });
    }
  }
}
