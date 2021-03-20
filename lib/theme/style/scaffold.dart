import 'dart:async';

import 'package:sonr_app/theme/theme.dart';
import 'style.dart';

class SonrScaffold extends StatelessWidget {
  final Widget body;
  final Widget appBar;
  final Widget floatingActionButton;
  final bool resizeToAvoidBottomPadding;
  final Function bodyAction;
  final Color backgroundColor;

  factory SonrScaffold.appBarAction(
      {@required String title, @required SonrButton action, Widget body, Widget floatingActionButton, bool resizeToAvoidBottomPadding = true}) {
    return SonrScaffold(
        body: body,
        floatingActionButton: floatingActionButton,
        appBar: NeumorphicAppBar(
            color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White, title: SonrText.appBar(title), actions: [action]),
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding);
  }

  factory SonrScaffold.appBarLeading(
      {@required String title, @required SonrButton leading, Widget body, Widget floatingActionButton, bool resizeToAvoidBottomPadding = true}) {
    return SonrScaffold(
        body: body,
        floatingActionButton: floatingActionButton,
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
      bool resizeToAvoidBottomPadding = true}) {
    return SonrScaffold(
        body: body,
        floatingActionButton: floatingActionButton,
        appBar: NeumorphicAppBar(
            color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White, title: middle, leading: leading, actions: [action]),
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding);
  }

  factory SonrScaffold.appBarTitle({@required String title, Widget body, Widget floatingActionButton, bool resizeToAvoidBottomPadding = true}) {
    return SonrScaffold(
        body: body,
        floatingActionButton: floatingActionButton,
        appBar: NeumorphicAppBar(color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White, title: SonrText.appBar(title)),
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding);
  }

  factory SonrScaffold.appBarLeadingAction(
      {@required String title,
      @required SonrButton leading,
      @required SonrButton action,
      Widget body,
      Widget floatingActionButton,
      bool resizeToAvoidBottomPadding = true}) {
    return SonrScaffold(
        body: body,
        floatingActionButton: floatingActionButton,
        appBar: NeumorphicAppBar(
          color: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
          title: GetX<_TitleController>(
            global: false,
            init: _TitleController(),
            builder: (controller) {
              controller.setDefault(title);
              return SonrAnimatedSwitcher.fade(
                duration: 2.seconds,
                child: GestureDetector(key: ValueKey<String>(controller.text.value), child: SonrText.appBar(controller.text.value)),
              );
            },
          ),
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
              body: body,
              appBar: appBar,
              floatingActionButton: floatingActionButton,
              resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
            ))));
  }
}

class _TitleController extends GetxController {
  // Properties
  String defaultText = "";
  final text = "".obs;

  // References
  StreamSubscription<int> lobbySizeStream;
  int _lobbySizeRef = 0;
  bool _timeoutActive = false;

  // ^ Constructer ^ //
  _TitleController() {
    lobbySizeStream = SonrService.lobbySize.listen(_handleLobbySizeStream);
    text(defaultText);
  }

  // ^ On Dispose ^ //
  void onDispose() {
    lobbySizeStream.cancel();
  }

  setDefault(String val) {
    defaultText = val;
    text(val);
  }

  // ^ Handle Cards Update ^ //
  _handleLobbySizeStream(int onData) {
    if (onData > _lobbySizeRef) {
      var diff = onData - _lobbySizeRef;
      swapTitleText("$diff Joined");
    } else if (onData < _lobbySizeRef) {
      var diff = _lobbySizeRef - onData;
      swapTitleText("$diff Left");
    }
  }

  // ^ Provides Information at home page ^ //
  void swapTitleText(String val, {Duration timeout = const Duration(milliseconds: 3500)}) {
    if (!_timeoutActive) {
      text(val);
      HapticFeedback.mediumImpact();
      _timeoutActive = true;
      Future.delayed(timeout, () {
        text(defaultText);
        _timeoutActive = false;
      });
    }
  }
}
