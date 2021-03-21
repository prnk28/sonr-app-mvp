import 'package:get/get.dart';
import 'package:flutter_sentry/flutter_sentry.dart';
import 'package:sonr_app/theme/theme.dart';
import 'data/data.dart';
import 'modules/card/card_controller.dart';

const bool K_TESTER_MODE = true;

// ^ Main Method ^ //
Future<void> main() async {
  await FlutterSentry.wrap(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initServices();
      runApp(App());
    },
    dsn: 'https://fbc20bb5a46a41e39a3376ce8124f4bb@o549479.ingest.sentry.io/5672326',
  );
}

// ^ Services (Files, Contacts) ^ //
initServices() async {
  await Get.putAsync(() => UserService().init(), permanent: true); // First Required Service
  await Get.putAsync(() => DeviceService().init(), permanent: true); // Second Required Service
  await Get.putAsync(() => MediaService().init(), permanent: true);
  await Get.putAsync(() => SQLService().init(), permanent: true);
  await Get.putAsync(() => SonrService().init(), permanent: true);
  await Get.putAsync(() => SonrOverlay().init(), permanent: true);
}

// ^ Initial Controller Bindings ^ //
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<TransferCardController>(() => TransferCardController());
    Get.create<AnimatedController>(() => AnimatedController());
    Get.lazyPut<CameraController>(() => CameraController());
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

    // Shift Page
    DeviceService.shiftPage(delay: 2.seconds);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: SonrRoutes.pages,
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
                        child: Padding(padding: EdgeInsets.only(top: 200), child: SonrText.header("Sonr", color: Colors.white)));
                  }),
            ],
          )),
    );
  }
}
