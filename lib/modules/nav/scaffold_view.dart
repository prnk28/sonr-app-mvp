import 'package:sonr_app/theme/theme.dart';
import 'app_bar.dart';
import 'bottom_bar.dart';
import 'bottom_sheet.dart';
import 'nav_controller.dart';

// ^ Standardized Uniform Scaffold ^ //
class SonrScaffold extends StatelessWidget {
  final Widget body;
  final bool disableDynamicLobbyTitle;
  SonrScaffold({
    Key key,
    this.body,
    this.disableDynamicLobbyTitle,
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
        body: Stack(children: [body, Positioned(bottom: 0, left: 0, child: Container(width: Get.width, child: SonrBottomNavBar()))]),
        appBar: SonrAppBar(),
        resizeToAvoidBottomInset: true,
        bottomSheet: SonrBottomSheet(),
      ),
    );
  }
}

class _SonrScaffoldBody extends GetView<NavController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {

    });
  }

  _switchPage(){
    switch(controller.page.value){
      case NavPage.Home:
        // TODO: Handle this case.
        break;
      case NavPage.Profile:
        // TODO: Handle this case.
        break;
      case NavPage.Alerts:
        // TODO: Handle this case.
        break;
      case NavPage.Remote:
        // TODO: Handle this case.
        break;
      case NavPage.Transfer:
        // TODO: Handle this case.
        break;
    }
  }
}
