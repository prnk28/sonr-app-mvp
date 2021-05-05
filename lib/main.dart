import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';
import 'data/data.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// ^ Main Method ^ //
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SonrRouting.initServices();
  await SentryFlutter.init(
    (options) {
      // Properties
      options.dsn = 'https://fbc20bb5a46a41e39a3376ce8124f4bb@o549479.ingest.sentry.io/5672326';
      options.sampleRate = 0.1;
      options.serverName = "[App] ${DeviceService.platform.toString()}";

      // Add Excludes
      SonrRouting.excludedModules.forEach((ex) {
        options.addInAppExclude(ex);
      });
    },
    // Init your App.
    appRunner: () => runApp(MobileApp()),
  );
}

// ^ Root App Widget ^ //
class MobileApp extends StatefulWidget {
  @override
  _MobileAppState createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  @override
  void initState() {
    super.initState();

    // Shift Page
    DeviceService.shiftPage(delay: 3.seconds);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: SonrRouting.pages,
      initialBinding: InitialBinding(),
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
      themeMode: UserService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              // @ Rive Animation
              RiveContainer(
                type: RiveBoard.SplashPortrait,
                width: Get.width,
                height: Get.height,
                placeholder: SizedBox(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent))),
              ),

              // @ Fade Animation of Text
              Positioned(
                bottom: 100,
                child: OpacityAnimatedWidget(enabled: true, duration: 350.milliseconds, delay: 2222.milliseconds, child: "Sonr".hero),
              ),
            ],
          )),
    );
  }
}
