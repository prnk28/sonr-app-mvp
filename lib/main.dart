import 'package:get/get.dart';
import 'package:sonr_app/core/core.dart';
import 'modules/card/card_controller.dart';
import 'modules/home/home_binding.dart';
import 'modules/media/camera_binding.dart';
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
  await Get.putAsync(() => UserService().init()); // First Required Service
  await Get.putAsync(() => DeviceService().init()); // Second Required Service
  await Get.putAsync(() => MediaService().init());
  await Get.putAsync(() => SQLService().init());
  await Get.putAsync(() => SonrService().init()); // Last Initialized Service
}

// ^ Initial Controller Bindings ^ //
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<TransferCardController>(() => TransferCardController());
    Get.create<AnimatedController>(() => AnimatedController());
    Get.lazyPut<SonrOverlay>(() => SonrOverlay(), fenix: true);
    Get.lazyPut<SonrPositionedOverlay>(() => SonrPositionedOverlay(), fenix: true);
  }
}

// ^ Root App Widget ^ //
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    // Listen to Device Start Status
    Future.delayed(2.seconds, () {
      var page = DeviceService.getLaunchPage();
      switch (page) {
        case LaunchPage.Home:
          Get.offNamed("/home");
          break;
        case LaunchPage.Register:
          Get.offNamed("/register");
          break;
        case LaunchPage.PermissionLocation:
          DeviceService.requestLocation().then((value) {
            if (value) {
              Get.offNamed("/home");
            }
          });
          break;
        case LaunchPage.PermissionNetwork:
          DeviceService.triggerNetwork().then((value) {
            Get.offNamed("/home");
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              RiveContainer(
                type: ArtboardType.Splash,
                width: Get.width,
                height: Get.height,
                placeholder: SizedBox(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent))),
              ),

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
          fullscreenDialog: true,
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
