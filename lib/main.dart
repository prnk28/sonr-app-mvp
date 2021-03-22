import 'package:get/get.dart';
import 'package:flutter_sentry/flutter_sentry.dart';
import 'package:sonr_app/theme/theme.dart';
import 'data/data.dart';

const bool K_TESTER_MODE = false;

// ^ Main Method ^ //
Future<void> main() async {
  await FlutterSentry.wrap(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await SonrRoutes.initServices();
      runApp(App());
    },
    dsn: 'https://fbc20bb5a46a41e39a3376ce8124f4bb@o549479.ingest.sentry.io/5672326',
  );
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
