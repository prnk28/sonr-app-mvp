import 'package:get/get.dart';
import 'package:sonar_app/service/device_service.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/service/sql_service.dart';
import 'package:sonar_app/theme/theme.dart';

import 'modules/home/home_binding.dart';
import 'modules/profile/profile_binding.dart';
import 'modules/register/register_binding.dart';
import 'modules/transfer/transfer_binding.dart';

// ^ Main Method ^ //
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(App());
}

// ^ Services (Files, Contacts) ^ //
initServices() async {
  await Get.putAsync(() => SQLService().init());
  await Get.putAsync(() => SocialMediaService().init());
  await Get.putAsync(() => DeviceService().init());
}

// ^ Initial Controller Bindings ^ //
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SonrCardController>(SonrCardController(), permanent: true);
  }
}

// ^ Root App Widget ^ //
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: K_PAGES,
      initialBinding: InitialBinding(),
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: Scaffold(
          backgroundColor: NeumorphicTheme.baseColor(context),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: Get.width / 5,
                  height: Get.height / 5,
                  child:
                      FittedBox(child: Image.asset("assets/images/icon.png"))),

              // Loading
              Padding(
                  padding: EdgeInsets.only(left: 45, right: 45),
                  child: NeumorphicProgressIndeterminate())
            ],
          )),
    );
  }
}

// ^ Routing Information ^ //
// ignore: non_constant_identifier_names
List<GetPage> get K_PAGES => [
      // ** Home Page ** //
      GetPage(
          name: '/home',
          page: () => SonrTheme(child: HomeScreen()),
          transition: Transition.zoom,
          binding: HomeBinding()),

      // ** Home Page - Incoming File ** //
      GetPage(
          name: '/home/incoming',
          page: () => SonrTheme(child: HomeScreen()),
          transition: Transition.cupertinoDialog,
          binding: HomeBinding()),

      // ** Home Page - Back ** //
      GetPage(
          name: '/home/transfer',
          page: () => SonrTheme(child: HomeScreen()),
          transition: Transition.upToDown,
          binding: HomeBinding()),

      // ** Home Page - Back ** //
      GetPage(
          name: '/home/profile',
          page: () => SonrTheme(child: HomeScreen()),
          transition: Transition.downToUp,
          binding: HomeBinding()),

      // ** Register Page ** //
      GetPage(
          name: '/register',
          page: () => SonrTheme(child: RegisterScreen()),
          transition: Transition.fade,
          binding: RegisterBinding()),

      // ** Transfer Page ** //
      GetPage(
          name: '/transfer',
          page: () => SonrTheme(child: TransferScreen()),
          transition: Transition.downToUp,
          binding: TransferBinding()),

      // ** Profile Page ** //
      GetPage(
          name: '/profile',
          page: () => SonrTheme(child: ProfileScreen()),
          transition: Transition.upToDown,
          fullscreenDialog: true,
          binding: ProfileBinding()),
    ];
