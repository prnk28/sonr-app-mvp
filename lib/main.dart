import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'data/data.dart';

const bool K_TESTER_MODE = true;

// ^ Main Method ^ //
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SonrRouting.initServices();
  runApp(App());
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
