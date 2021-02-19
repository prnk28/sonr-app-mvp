import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonr_app/service/media_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/service/social_service.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'modules/card/card_controller.dart';
import 'modules/home/home_binding.dart';
import 'modules/media/camera_binding.dart';
import 'modules/profile/profile_binding.dart';
import 'modules/register/register_binding.dart';
import 'modules/transfer/transfer_binding.dart';
import 'widgets/overlay.dart';

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
  await Get.putAsync(() => MediaService().init());
}

// ^ Initial Controller Bindings ^ //
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<TransferCardController>(() => TransferCardController());
    Get.create<AnimatedController>(() => AnimatedController());
    Get.lazyPut<SonrOverlay>(() => SonrOverlay(), fenix: true);
    Get.lazyPut<SonrPositionedOverlay>(() => SonrPositionedOverlay(), fenix: true);
    Get.lazyPut<RiveWidgetController>(() => RiveWidgetController('assets/animations/tile_preview.riv'), fenix: true);
    // Get.put(SonrOverlay());
    // Get.put(SonrPositionedOverlay());
    // Get.put<RiveWidgetController>(RiveWidgetController('assets/animations/tile_preview.riv'), permanent: true);
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
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to Device Start Status
    Get.find<DeviceService>().startStatus.listen((status) {
      switch (status) {
        case DeviceStatus.Success:
          Get.offNamed("/home");
          break;
        case DeviceStatus.NoUser:
          Get.offNamed("/register");
          break;
        case DeviceStatus.NoLocation:
          SonrSnack.error("Location Permissions Required for Sonr");
          break;
      }
    });
    return GetMaterialApp(
      getPages: K_PAGES,
      initialBinding: InitialBinding(),
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
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
                          ? const SizedBox(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)))
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
                        child:
                            Padding(padding: EdgeInsets.only(top: 200), child: SonrText.header("Sonr", gradient: FlutterGradientNames.glassWater)));
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
          page: () => HomeScreen(),
          maintainState: false,
          transition: Transition.topLevel,
          curve: Curves.easeIn,
          binding: HomeBinding()),

      // ** Home Page - Back from Transfer ** //
      GetPage(
          name: '/home/transfer',
          page: () => HomeScreen(),
          maintainState: false,
          transition: Transition.upToDown,
          curve: Curves.easeIn,
          binding: HomeBinding()),

      // ** Home Page - Back from Profile ** //
      GetPage(
          name: '/home/profile',
          page: () => HomeScreen(),
          maintainState: false,
          transition: Transition.downToUp,
          curve: Curves.easeIn,
          binding: HomeBinding()),

      // ** Register Page ** //
      GetPage(
          name: '/register',
          page: () => RegisterScreen(),
          maintainState: false,
          transition: Transition.fade,
          curve: Curves.easeIn,
          binding: RegisterBinding()),

      // ** Transfer Page ** //
      GetPage(
          name: '/transfer',
          page: () => TransferScreen(),
          maintainState: false,
          transition: Transition.downToUp,
          curve: Curves.easeIn,
          binding: TransferBinding()),

      // ** Camera Page - Default Media View ** //
      GetPage(
          name: '/camera',
          page: () => MediaScreen(),
          maintainState: false,
          transition: Transition.fade,
          curve: Curves.easeIn,
          binding: CameraBinding()),

      // ** Profile Page ** //
      GetPage(name: '/profile', page: () => ProfileScreen(), transition: Transition.upToDown, curve: Curves.easeIn, binding: ProfileBinding()),
    ];
