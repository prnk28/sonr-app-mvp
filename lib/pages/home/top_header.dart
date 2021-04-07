import 'dart:async';
import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';

// ^ Home Screen Header ^ //
class HomeTopHeaderBar extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.path(TopBarPath()),
          depth: UserService.isDarkMode ? 4 : 8,
          intensity: UserService.isDarkMode ? 0.45 : 0.85,
          surfaceIntensity: 0.6,
        ),
        child: Container(
            height: Get.height / 3.5,
            width: Get.width,
            decoration: BoxDecoration(gradient: SonrPalette.primary()),
            child: Stack(children: [
              Align(alignment: Alignment.topCenter, child: _HomeHeaderTitle(defaultText: "Home")),
            ])));
  }
}

// ^ Header Clipper for Neumorphic Path ^ //
class TopBarPath extends NeumorphicPathProvider {
  @override
  Path getPath(Size size) {
    Offset firstEndPoint = Offset(size.width * .5, size.height - 20);
    Offset firstControlPoint = Offset(size.width * .25, size.height - 30);
    Offset secondEndPoint = Offset(size.width, size.height - 50);
    Offset secondControlPoint = Offset(size.width * .75, size.height - 10);

    final path = Path()
      ..lineTo(0.0, size.height)
      ..quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
      ..quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
      ..lineTo(size.width, 0.0)
      ..close();
    return path;
  }

  @override
  bool get oneGradientPerPath => true;
}

// ^ Dynamic App bar title for Lobby Size ^ //
class _HomeHeaderTitle extends StatefulWidget {
  final String defaultText;
  const _HomeHeaderTitle({Key key, this.defaultText}) : super(key: key);
  @override
  _HomeHeaderTitleState createState() => _HomeHeaderTitleState();
}

class _HomeHeaderTitleState extends State<_HomeHeaderTitle> {
  // Properties
  String text;

  // References
  StreamSubscription<int> lobbySizeStream;
  StreamSubscription<Status> statusStream;
  int _lobbySizeRef = 0;
  bool _timeoutActive = false;
  Status _currentStatus = Status.NONE;

  @override
  void initState() {
    // Add Initial Data
    _handleLobbySizeStream(LobbyService.localSize.value);

    // Set Defaults
    lobbySizeStream = LobbyService.localSize.listen(_handleLobbySizeStream);
    statusStream = SonrService.status.listen(_handleStatus);
    text = widget.defaultText;
    super.initState();
  }

  @override
  void dispose() {
    lobbySizeStream.cancel();
    statusStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(top: kToolbarHeight, bottom: 16),
      height: kToolbarHeight + 56,
      child: NavigationToolbar(
          middle: AnimatedSlideSwitcher.fade(
            duration: 2.seconds,
            child: GestureDetector(
              key: ValueKey<String>(text),
              child: _currentStatus.isConnecting
                  ? Row(
                      children: [SonrText.appBar("Connecting"), CircularProgressIndicator()],
                    )
                  : SonrText.appBar(text),
              onTap: () {
                swapTitleText("${LobbyService.localSize.value} Around", timeout: 2500.milliseconds);
              },
            ),
          ),
          centerMiddle: true),
    );
  }

  // @ Handle Cards Update ^ //
  _handleLobbySizeStream(int onData) {
    if (onData > _lobbySizeRef) {
      var diff = onData - _lobbySizeRef;
      swapTitleText("$diff Joined");
    } else if (onData < _lobbySizeRef) {
      var diff = _lobbySizeRef - onData;
      swapTitleText("$diff Left");
    }
    _lobbySizeRef = onData;
  }

  // @ Handle Ready ^ //
  _handleStatus(Status val) {
    _currentStatus = val;
    if (val.isReady && mounted) {
      // Entry Text
      setState(() {
        text = "Hello, ${UserService.firstName.value}";
        _timeoutActive = true;
      });

      // Nearby Peers Text
      Future.delayed(const Duration(milliseconds: 3500), () {
        setState(() {
          text = ("${LobbyService.localSize.value} Nearby");
        });
      });

      // Revert Text
      Future.delayed(const Duration(milliseconds: 3500) * 2, () {
        setState(() {
          text = widget.defaultText;
          _timeoutActive = false;
        });
      });
    }
  }

  // @ Swaps Title when Lobby Size Changes ^ //
  void swapTitleText(String val, {Duration timeout = const Duration(milliseconds: 3500)}) {
    if (!_timeoutActive && mounted) {
      // Swap Text
      setState(() {
        text = val;
        HapticFeedback.mediumImpact();
        _timeoutActive = true;
      });

      // Revert Text
      Future.delayed(timeout, () {
        if (mounted) {
          setState(() {
            text = widget.defaultText;
            _timeoutActive = false;
          });
        }
      });
    }
  }
}
