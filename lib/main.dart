import 'package:get/get.dart';
import 'package:sonar_app/ui/ui.dart';
import 'controller/bindings.dart';

// ** Main Method ** //
void main() async {
  // Run App with BLoC Providers
  runApp(App());
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
      initialBinding: AppBind(),
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
      transition: Transition.zoom,
      binding: HomeBind(),
    ),

    // ** Register Page ** //
    GetPage(
        name: '/register',
        page: () => AppTheme(RegisterScreen()),
        transition: Transition.rightToLeftWithFade),

    // ** Searching Page ** //
    GetPage(
      name: '/transfer',
      page: () => AppTheme(TransferScreen()),
      transition: Transition.fade,
      // binding: HomeBind(),
    ),
  ];
}
