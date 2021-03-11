import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/theme/theme.dart';
import 'data/data.dart';
import 'modules/card/card_controller.dart';
import 'modules/home/home_binding.dart';
import 'modules/profile/profile_binding.dart';
import 'modules/register/register_binding.dart';
import 'modules/transfer/transfer_binding.dart';
import 'package:wiredash/wiredash.dart';

const bool K_TESTER_MODE = true;

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
}

// ^ Initial Controller Bindings ^ //
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<TransferCardController>(() => TransferCardController());
    Get.create<AnimatedController>(() => AnimatedController());
    Get.lazyPut<CameraController>(() => CameraController());
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
          Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
          break;
        case LaunchPage.Register:
          Get.offNamed("/register");
          break;
        case LaunchPage.PermissionLocation:
          Get.find<DeviceService>().requestLocation().then((value) {
            if (value) {
              Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
            }
          });
          break;
        case LaunchPage.PermissionNetwork:
          Get.find<DeviceService>().triggerNetwork().then((value) {
            Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (K_TESTER_MODE) {
      return Wiredash(
        theme: WiredashThemeData(fontFamily: "Poppins", brightness: DeviceService.brightness.value),
        options: WiredashOptionsData(
          praiseButton: false,
          screenshotStep: false,
          customTranslations: {const Locale.fromSubtags(languageCode: 'zh'): const SonrWiredashTranslation()},
          locale: const Locale.fromSubtags(languageCode: 'zh'),
        ),
        navigatorKey: Get.key,
        projectId: 'sonr-g4dd5i0',
        secret: 'ksir492giek9pqyt3yjz6gwl2klc47paxp1w9wpof7z6g52v',
        child: _buildSplashScreen(),
      );
    } else {
      return _buildSplashScreen();
    }
  }

  Widget _buildSplashScreen() {
    return GetMaterialApp(
      getPages: pageRouting,
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
