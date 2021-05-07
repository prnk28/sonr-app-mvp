import 'dart:async';
import 'package:sonr_app/style/style.dart';

class WindowController extends GetxController {
  static get to => Get.find<WindowController>();

  // Properties
  final isTitleVisible = true.obs;

  // Elements
  final titleText = "Home".obs;
  final sonrStatus = Rx<Status>(SonrService.status.value);
  final view = Rx<DesktopView>(DesktopView.Default);

  // References
  late StreamSubscription<Lobby?> _lobbySizeStream;
  late StreamSubscription<Status> _statusStream;
  bool _timeoutActive = false;
  int _lobbySizeRef = 0;

  @override
  void onInit() {
    // Set View
    if (UserService.hasUser.value) {
      Get.find<SonrService>().connect();
      view(DesktopView.Explorer);
    } else {
      view(DesktopView.Register);
    }

    super.onInit();

    // Handle Streams
    _lobbySizeStream = LobbyService.local.listen(_handleLobbySizeStream);
    _statusStream = SonrService.status.listen(_handleStatus);
  }

  /// @ On Dispose
  @override
  void onClose() {
    _lobbySizeStream.cancel();
    _statusStream.cancel();
    super.onClose();
  }

  void changeView(DesktopView newView) {
    view(newView);
    view.refresh();
  }

  // @ Handle Size Update
  _handleLobbySizeStream(Lobby? onData) {
    // Peer Joined
    if (onData!.size > _lobbySizeRef) {
      var diff = onData.size - _lobbySizeRef;
      swapTitleText("$diff Joined");
      DeviceService.playSound(type: UISoundType.Joined);
    }
    // Peer Left
    else if (onData.size < _lobbySizeRef) {
      var diff = _lobbySizeRef - onData.size;
      swapTitleText("$diff Left");
    }
    _lobbySizeRef = onData.size;
  }

  // @ Handle Status Update
  _handleStatus(Status val) {
    sonrStatus(val);
    if (val.isConnected) {
      // Entry Text
      titleText("${LobbyService.local.value.count} Nearby");
      _timeoutActive = true;

      // Revert Text
      Future.delayed(const Duration(milliseconds: 3500), () {
        if (!isClosed) {
          titleText("Welcome Back");
          _timeoutActive = false;
        }
      });
    }
  }

  // @ Swaps Title when Lobby Size Changes
  void swapTitleText(String val, {Duration timeout = const Duration(milliseconds: 3500)}) {
    // Check Valid
    if (!_timeoutActive && !isClosed && isTitleVisible.value) {
      // Swap Text
      titleText(val);
      HapticFeedback.mediumImpact();
      _timeoutActive = true;

      // Revert Text
      Future.delayed(timeout, () {
        if (!isClosed) {
          titleText("Welcome Back");
          _timeoutActive = false;
        }
      });
    }
  }
}

enum DesktopView { Default, Explorer, Register }
