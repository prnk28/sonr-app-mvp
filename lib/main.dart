import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/service/sql_service.dart';
import 'package:sonar_app/service/device_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'modules/home/home_binding.dart';
import 'modules/profile/profile_binding.dart';
import 'modules/register/register_screen.dart';
import 'modules/transfer/transfer_binding.dart';

// ^ Main Method ^ //
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(App());
}

// ^ Services (Files, Contacts) ^ //
// TODO: Convert SonrController to Service
initServices() async {
  // Initializes Local Contacts/Files and Device User/Settings
  await Get.putAsync(() => SQLService().init());
  await Get.putAsync(() => DeviceService().init());
}

// ^ Root Widget ^ //
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Connect to Sonr Network
    Get.find<DeviceService>().start();

    return GetMaterialApp(
      getPages: getPages(),
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: Scaffold(
          backgroundColor: NeumorphicTheme.baseColor(context),
          // Non Build States
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
List<GetPage> getPages() {
  return [
    // ** Home Page ** //
    GetPage(
        name: '/home',
        page: () => SonrTheme(HomeScreen()),
        transition: Transition.zoom,
        binding: HomeBinding()),

    // ** Home Page - Back ** //
    GetPage(
        name: '/home/transfer',
        page: () => SonrTheme(HomeScreen()),
        transition: Transition.leftToRight,
        binding: HomeBinding()),

    // ** Home Page - Back ** //
    GetPage(
        name: '/home/profile',
        page: () => SonrTheme(HomeScreen()),
        transition: Transition.downToUp,
        binding: HomeBinding()),

    // ** Register Page ** //
    GetPage(
        name: '/register',
        page: () => SonrTheme(RegisterScreen()),
        transition: Transition.rightToLeft),

    // ** Transfer Page ** //
    GetPage(
        name: '/transfer',
        page: () => SonrTheme(TransferScreen()),
        transition: Transition.rightToLeft,
        binding: TransferBinding()),

    // ** Profile Page ** //
    GetPage(
        name: '/profile',
        page: () => SonrTheme(ProfileScreen()),
        transition: Transition.upToDown,
        fullscreenDialog: true,
        binding: ProfileBinding()),
  ];
}
