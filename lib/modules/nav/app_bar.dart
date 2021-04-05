import 'dart:async';

import 'package:sonr_app/theme/theme.dart';
import 'nav_controller.dart';

class SonrAppBar extends GetView<NavController> with PreferredSizeWidget {
  final Widget middle;
  final Widget leading;
  final Widget action;
  final String title;
  final bool disableDynamicLobbyTitle;
  SonrAppBar({this.middle, this.leading, this.action, this.disableDynamicLobbyTitle, this.title});
  @override
  Widget build(BuildContext context) {
    // Set Title
    Widget titleItem;
    if (disableDynamicLobbyTitle) {
      titleItem = SonrText.appBar(title);
    } else if (middle != null && disableDynamicLobbyTitle) {
      titleItem = middle;
    } else {
      titleItem = _SonrAppbarTitle(defaultText: title);
    }

    // Return App Bar
    return Container(
      width: Get.width,
      height: 80,
      child: NavigationToolbar(middle: titleItem, leading: leading, trailing: action, centerMiddle: true),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, 80);
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
  StreamSubscription<bool> readyStream;
  int _lobbySizeRef = 0;
  bool _timeoutActive = false;

  @override
  void initState() {
    // Add Initial Data
    _handleLobbySizeStream(LobbyService.localSize.value);

    // Set Defaults
    lobbySizeStream = LobbyService.localSize.listen(_handleLobbySizeStream);
    readyStream = SonrService.isReady.listen(_handleReady);
    text = widget.defaultText;
    super.initState();
  }

  @override
  void dispose() {
    lobbySizeStream.cancel();
    readyStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlideSwitcher.fade(
      duration: 2.seconds,
      child: GestureDetector(
        key: ValueKey<String>(text),
        child: SonrText.appBar(text),
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
  _handleReady(bool val) {
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

  // @ Swaps Title when Lobby Size Changes ^ //
  void swapTitleText(String val, {Duration timeout = const Duration(milliseconds: 3500)}) {
    if (!_timeoutActive) {
      // Swap Text
      setState(() {
        text = val;
        HapticFeedback.mediumImpact();
        _timeoutActive = true;
      });

      // Revert Text
      Future.delayed(timeout, () {
        setState(() {
          text = widget.defaultText;
          _timeoutActive = false;
        });
      });
    }
  }
}
