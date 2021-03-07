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
          title: SonrText.appBar(title),
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
    return NeumorphicTheme(
        themeMode: DeviceService.isDarkMode.value ? ThemeMode.dark : ThemeMode.light, //or dark / system
        darkTheme: NeumorphicThemeData(
          defaultTextColor: Colors.white,
          baseColor: SonrColor.Dark,
          lightSource: LightSource.topLeft,
          shadowLightColor: SonrColor.LightModeShadowLight,
          shadowDarkColor: SonrColor.LightModeShadowDark,
          depth: 6,
          intensity: 0.45,
        ),
        theme: NeumorphicThemeData(
          defaultTextColor: Colors.black,
          baseColor: SonrColor.White,
          lightSource: LightSource.topLeft,
          shadowLightColor: SonrColor.LightModeShadowLight,
          shadowDarkColor: SonrColor.LightModeShadowDark,
          depth: 8,
          intensity: 0.85,
        ),
        child: Scaffold(
          backgroundColor: DeviceService.isDarkMode.value ? SonrColor.Dark : SonrColor.White,
          body: body,
          appBar: appBar,
          floatingActionButton: floatingActionButton,
          resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
        ));
  }
}
