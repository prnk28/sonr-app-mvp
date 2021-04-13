import 'dart:async';

import 'package:sonr_app/theme/theme.dart';

// ^ Standardized Uniform Scaffold ^ //
class SonrScaffold extends StatelessWidget {
  final Widget body;
  final Widget bottomSheet;
  final Widget floatingActionButton;
  final Widget bottomNavigationBar;
  final Widget shareView;
  final PreferredSizeWidget appBar;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final bool resizeToAvoidBottomInset;
  final Function bodyAction;
  final Color backgroundColor;

  SonrScaffold({
    Key key,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset,
    this.bodyAction,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.shareView,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
        themeMode: UserService.isDarkMode ? ThemeMode.dark : ThemeMode.light, //or dark / system
        darkTheme: NeumorphicThemeData(
          defaultTextColor: Colors.white,
          baseColor: SonrColor.Dark,
          lightSource: LightSource.topLeft,
          depth: 4,
          intensity: 0.45,
        ),
        theme: NeumorphicThemeData(
          defaultTextColor: SonrColor.Black,
          baseColor: SonrColor.White,
          lightSource: LightSource.topLeft,
          depth: 8,
          intensity: 0.85,
        ),
        child: Scaffold(
          backgroundColor: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
          floatingActionButtonLocation: floatingActionButtonLocation,
          body: Stack(children: [
            body,
            Positioned(bottom: 0, left: 0, child: Container(width: Get.width, child: bottomNavigationBar)),
            shareView ?? Container()
          ]),
          appBar: appBar,
          floatingActionButton: floatingActionButton,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          bottomSheet: bottomSheet,
        ));
  }
}

// ^ Dynamic App bar title for Lobby Size ^ //
class _SonrAppbarTitle extends StatefulWidget {
  final String defaultText;
  const _SonrAppbarTitle({Key key, this.defaultText}) : super(key: key);
  @override
  _SonrAppbarTitleState createState() => _SonrAppbarTitleState();
}

class _SonrAppbarTitleState extends State<_SonrAppbarTitle> {
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
    return AnimatedSlideSwitcher.fade(
      duration: 2.seconds,
      child: GestureDetector(
        key: ValueKey<String>(text),
        child: _currentStatus.isConnecting
            ? Row(
                children: ["Connected".h3, CircularProgressIndicator()],
              )
            : text.h3,
        onTap: () {
          swapTitleText("${LobbyService.localSize.value} Around", timeout: 2500.milliseconds);
        },
      ),
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
