import 'package:sonr_app/theme/theme.dart';

class SonrScaffold extends StatelessWidget {
  final Widget body;
  final Widget appBar;
  final Widget floatingActionButton;
  final bool resizeToAvoidBottomPadding;
  final Function bodyAction;

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

  SonrScaffold({Key key, this.body, this.appBar, this.floatingActionButton, this.resizeToAvoidBottomPadding, this.bodyAction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
        themeMode: ThemeMode.light, //or dark / system
        darkTheme: NeumorphicThemeData(
          baseColor: Color.fromRGBO(239, 238, 238, 1.0),
          accentColor: Colors.green,
          lightSource: LightSource.topLeft,
          depth: 4,
          intensity: 0.5,
        ),
        theme: NeumorphicThemeData(
          baseColor: K_BASE_COLOR,
          lightSource: LightSource.topLeft,
          depth: 6,
          intensity: 0.85,
        ),
        child: Scaffold(backgroundColor: K_BASE_COLOR, body: body, appBar: appBar, floatingActionButton: floatingActionButton));
  }
}
