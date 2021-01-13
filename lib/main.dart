import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
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
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Artboard _riveArtboard;
  @override
  void initState() {
    super.initState();
    // Load the RiveFile from the binary data.
    rootBundle.load('assets/animations/splash_screen.riv').then(
      (data) async {
        // Await Loading
        final file = RiveFile();
        if (file.import(data)) {
          // Retreive Artboard
          final artboard = file.mainArtboard;

          // Determine Animation by Tile Type
          artboard.addController(SimpleAnimation('Default'));
          setState(() => _riveArtboard = artboard);

          // Add Delay before switching screens
          Future.delayed(Duration(milliseconds: 1600)).then((_) {
            Get.offNamed("/home");
          });
        }
      },
    );
  }

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
          backgroundColor: Colors.black,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              // @ Rive Animation
              Container(
                  width: Get.width,
                  height: Get.height,
                  child: Center(
                      child: _riveArtboard == null
                          ? const SizedBox(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blueAccent)))
                          : Rive(artboard: _riveArtboard))),

              // @ Fade Animation of Text
              PlayAnimation<double>(
                  tween: (0.0).tweenTo(1.0),
                  duration: 400.milliseconds,
                  delay: 1.seconds,
                  builder: (context, child, value) {
                    return AnimatedOpacity(
                        opacity: value,
                        duration: 400.milliseconds,
                        child: Padding(
                            padding: EdgeInsets.only(top: 200),
                            child: SonrText.header("Sonr",
                                gradient: FlutterGradientNames.glassWater)));
                  }),
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
