import 'package:sonr_app/data/constants.dart';
import 'package:sonr_app/theme/theme.dart';

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
        appBar: NeumorphicAppBar(title: SonrText.appBar(title), actions: [action]),
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding);
  }

  factory SonrScaffold.appBarLeading(
      {@required String title, @required SonrButton leading, Widget body, Widget floatingActionButton, bool resizeToAvoidBottomPadding = true}) {
    return SonrScaffold(
        body: body,
        floatingActionButton: floatingActionButton,
        appBar: NeumorphicAppBar(title: SonrText.appBar(title), leading: leading),
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding);
  }

  factory SonrScaffold.appBarTitle({@required String title, Widget body, Widget floatingActionButton, bool resizeToAvoidBottomPadding = true}) {
    return SonrScaffold(
        body: body,
        floatingActionButton: floatingActionButton,
        appBar: NeumorphicAppBar(title: SonrText.appBar(title)),
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
    this.backgroundColor = SonrColor.base,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
        themeMode: DeviceService.isDarkMode.value ? ThemeMode.dark : ThemeMode.light, //or dark / system
        darkTheme: NeumorphicThemeData(
          baseColor: SonrColor.baseDark,
          lightSource: LightSource.topLeft,
          shadowDarkColor: Colors.black.withOpacity(0.7),
          shadowLightColor: SonrColor.fromHex("#3A3A3A").withOpacity(0.7),
          depth: 6,
          intensity: 0.85,
        ),
        theme: NeumorphicThemeData(
          baseColor: SonrColor.base,
          lightSource: LightSource.topLeft,
          depth: 6,
          intensity: 0.85,
        ),
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: body,
          appBar: appBar,
          floatingActionButton: floatingActionButton,
          resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
        ));
  }
}
