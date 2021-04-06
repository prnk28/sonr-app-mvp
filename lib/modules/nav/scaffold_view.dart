import 'package:sonr_app/theme/theme.dart';
import 'app_bar.dart';

// ^ Standardized Uniform Scaffold ^ //
class SonrScaffold extends StatelessWidget {
  final bool disableDynamicLobbyTitle;
  final Widget body;
  final Widget bottomBar;
  SonrScaffold({Key key, this.disableDynamicLobbyTitle, this.body, this.bottomBar}) : super(key: key);

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
        body: Stack(children: [body, Positioned(bottom: 0, left: 0, child: Container(width: Get.width, child: bottomBar))]),
        appBar: SonrAppBar(),
        resizeToAvoidBottomInset: true,
      ),
    );
  }
}
