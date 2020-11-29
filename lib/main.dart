import 'package:get/get.dart';

import 'routing.dart';
import 'package:sonar_app/ui/screens.dart';

// ** Main Method ** //
void main() async {
  // Run App with BLoC Providers
  runApp(initializeBloc(App()));
}

// ^ Root Widget ^ //
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
        child: GetMaterialApp(
      getPages: getPages(),
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: SplashScreen(),
    ));
  }
}

// ^ Routing Information ^ //
List<GetPage> getPages() {
  return [
    // ** Home Page ** //
    GetPage(
        name: '/home',
        page: () => AppTheme(HomeScreen()),
        transition: Transition.zoom),

    // ** Register Page ** //
    GetPage(
        name: '/register',
        page: () => AppTheme(RegisterScreen()),
        transition: Transition.rightToLeftWithFade),

    // ** Searching Page ** //
    GetPage(
        name: '/transfer',
        page: () => AppTheme(SearchingScreen()),
        transition: Transition.fade),
  ];
}
