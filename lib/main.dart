import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'data/data.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// ^ Main Method ^ //
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SonrRouting.initServices();
  await SentryFlutter.init(
    (options) => options.dsn = 'http://eaf4e944d14b4f77b0794d87daaa5ad6:4ac8dc72bd6945408141483fe97540b8@ec2-34-201-54-61.compute-1.amazonaws.com/3',
    appRunner: () => runApp(App()),
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
                type: RiveBoard.Splash,
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
