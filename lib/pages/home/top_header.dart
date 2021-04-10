import 'dart:async';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';

// ^ Home Screen Header ^ //
class HomeTopHeaderBar extends GetView<HomeController> {

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.path(WavePath()),
          depth: UserService.isDarkMode ? 4 : 8,
          intensity: UserService.isDarkMode ? 0.45 : 0.85,
          surfaceIntensity: 0.6,
        ),
        child: Container(
            height: Get.height / 4,
            width: Get.width,
            decoration: BoxDecoration(gradient: SonrPalette.primary()),
            child: Stack(children: [
              Align(alignment: Alignment.topCenter, child: _HomeHeaderTitle(defaultText: "Home")),
            ])));
  }
}

// ^ Dynamic App bar title for Lobby Size ^ //
class _HomeHeaderTitle extends StatelessWidget {
  final String defaultText;
  const _HomeHeaderTitle({Key key, this.defaultText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetX<_HomeHeaderTitleController>(
      init: _HomeHeaderTitleController(defaultText),
      builder: (controller) {
        return Container(
          width: Get.width,
          padding: EdgeInsets.only(top: kToolbarHeight, bottom: 16),
          height: kToolbarHeight + 56,
          child: NavigationToolbar(
              middle: AnimatedSlideSwitcher.fade(
                duration: 2.seconds,
                child: GestureDetector(
                  key: ValueKey<String>(controller.title.value),
                  child: controller.status.value.isConnecting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [SonrText.appBar("Connecting"), CircularProgressIndicator()],
                        )
                      : SonrText.appBar(controller.title.value),
                  onTap: () {
                    controller.swapTitleText("${LobbyService.localSize.value} Around", timeout: 2500.milliseconds);
                  },
                ),
              ),
              centerMiddle: true),
        );
      },
    );
  }
}

// ^ Controller for Header Title ^ //
class _HomeHeaderTitleController extends GetxController {
  // Properties
  final String defaultText;
  final title = "".obs;
  final status = Rx<Status>(SonrService.status.value);
  final isVisible = true.obs;

  // References
  StreamSubscription<int> lobbySizeStream;
  StreamSubscription<Status> statusStream;
  int _lobbySizeRef = 0;
  bool _timeoutActive = false;

  _HomeHeaderTitleController(this.defaultText);

  @override
  void onReady() {
    // Add Initial Data
    _handleLobbySizeStream(LobbyService.localSize.value);

    // Set Defaults
    lobbySizeStream = LobbyService.localSize.listen(_handleLobbySizeStream);
    statusStream = SonrService.status.listen(_handleStatus);
    title(defaultText);
    super.onReady();
  }

  @override
  void onClose() {
    lobbySizeStream.cancel();
    statusStream.cancel();
    super.onClose();
  }

  // @ Handle Size Update ^ //
  _handleLobbySizeStream(int onData) {
    // Peer Joined
    if (onData > _lobbySizeRef) {
      var diff = onData - _lobbySizeRef;
      swapTitleText("$diff Joined");
      DeviceService.playSound(type: UISoundType.Joined);
    }
    // Peer Left
    else if (onData < _lobbySizeRef) {
      var diff = _lobbySizeRef - onData;
      swapTitleText("$diff Left");
    }
    _lobbySizeRef = onData;
  }

  // @ Handle Status Update ^ //
  _handleStatus(Status val) {
    status(val);
    if (val.isConnected) {
      // Entry Text
      title("Hello, ${UserService.firstName.value}");
      _timeoutActive = true;

      // Nearby Peers Text
      Future.delayed(const Duration(milliseconds: 3500), () {
        if (!isClosed) {
          title("${LobbyService.localSize.value} Nearby");
        }
      });

      // Revert Text
      Future.delayed(const Duration(milliseconds: 3500) * 2, () {
        if (!isClosed) {
          title(defaultText);
          _timeoutActive = false;
        }
      });
    }
  }

  // @ Swaps Title when Lobby Size Changes ^ //
  void swapTitleText(String val, {Duration timeout = const Duration(milliseconds: 3500)}) {
    if (!_timeoutActive && !isClosed) {
      // Swap Text
      title(val);
      HapticFeedback.mediumImpact();
      _timeoutActive = true;

      // Revert Text
      Future.delayed(timeout, () {
        if (!isClosed) {
          title(defaultText);
          _timeoutActive = false;
        }
      });
    }
  }
}
