import 'dart:async';

import 'package:sonr_app/theme/theme.dart';
import 'style.dart';

// ^ Standardized Uniform Scaffold ^ //
class SonrScaffold extends StatelessWidget {
  final Widget body;
  final Widget appBar;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final bool resizeToAvoidBottomPadding;
  final Function bodyAction;
  final Color backgroundColor;

  factory SonrScaffold.appBarAction(
      {@required String title,
      @required SonrButton action,
      Widget body,
      Widget floatingActionButton,
      FloatingActionButtonLocation floatingActionButtonLocation,
      bool resizeToAvoidBottomPadding = true}) {
    return SonrScaffold(
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        appBar: NeumorphicAppBar(
            color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White, title: SonrText.appBar(title), actions: [action]),
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding);
  }

  factory SonrScaffold.appBarLeading(
      {@required String title,
      @required SonrButton leading,
      Widget body,
      Widget floatingActionButton,
      FloatingActionButtonLocation floatingActionButtonLocation,
      bool resizeToAvoidBottomPadding = true}) {
    return SonrScaffold(
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        appBar: NeumorphicAppBar(
            color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White, title: SonrText.appBar(title), leading: leading),
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding);
  }

  factory SonrScaffold.appBarCustom(
      {@required Widget middle,
      @required Widget leading,
      Widget action,
      Widget body,
      Widget floatingActionButton,
      FloatingActionButtonLocation floatingActionButtonLocation,
      bool resizeToAvoidBottomPadding = true}) {
    return SonrScaffold(
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        appBar: NeumorphicAppBar(
            color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White, title: middle, leading: leading, actions: [action]),
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding);
  }

  factory SonrScaffold.appBarTitle(
      {@required String title,
      Widget body,
      Widget floatingActionButton,
      FloatingActionButtonLocation floatingActionButtonLocation,
      bool resizeToAvoidBottomPadding = true}) {
    return SonrScaffold(
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        appBar: NeumorphicAppBar(color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White, title: SonrText.appBar(title)),
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding);
  }

  factory SonrScaffold.appBarLeadingAction(
      {@required String title,
      @required SonrButton leading,
      @required SonrButton action,
      Widget body,
      Widget floatingActionButton,
      FloatingActionButtonLocation floatingActionButtonLocation,
      bool resizeToAvoidBottomPadding = true}) {
    return SonrScaffold(
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        appBar: NeumorphicAppBar(
          color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
          title: _SonrAppbarTitle(defaultText: title),
          leading: leading,
          actions: [action],
        ),
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding);
  }

  SonrScaffold({
    Key key,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomPadding,
    this.bodyAction,
    this.backgroundColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => NeumorphicTheme(
        themeMode: DeviceService.isDarkMode.value ? ThemeMode.dark : ThemeMode.light, //or dark / system
        darkTheme: NeumorphicThemeData(
          defaultTextColor: Colors.white,
          baseColor: SonrColor.Dark,
          lightSource: LightSource.topLeft,
          depth: 4,
          intensity: 0.45,
        ),
        theme: NeumorphicThemeData(
          defaultTextColor: SonrColor.black,
          baseColor: SonrColor.White,
          lightSource: LightSource.topLeft,
          depth: 8,
          intensity: 0.85,
        ),
        child: Obx(() => Scaffold(
              backgroundColor: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
              floatingActionButtonLocation: floatingActionButtonLocation,
              body: body,
              appBar: appBar,
              floatingActionButton: floatingActionButton,
              resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
            ))));
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
  String text;
  // References
  StreamSubscription<int> lobbySizeStream;
  int _lobbySizeRef = 0;
  bool _timeoutActive = false;

  @override
  void initState() {
    lobbySizeStream = SonrService.lobbySize.listen(_handleLobbySizeStream);
    text = widget.defaultText;
    super.initState();
  }

  @override
  void dispose() {
    lobbySizeStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SonrAnimatedSwitcher.fade(
      duration: 2.seconds,
      child: GestureDetector(key: ValueKey<String>(text), child: SonrText.appBar(text)),
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
