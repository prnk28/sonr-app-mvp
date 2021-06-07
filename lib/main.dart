import 'package:get/get.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:sonr_app/style.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:feedback/feedback.dart';

/// @ Main Method
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SonrServices.init();
  await SentryFlutter.init(
    Logger.sentryOptions,
    appRunner: () => runApp(BetterFeedback(child: App(isDesktop: false))),
  );
}

/// @ Root App Widget
class App extends StatelessWidget {
  final bool isDesktop;

  const App({Key? key, required this.isDesktop}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DeviceService.initialPage(delay: 3500.milliseconds);
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: SonrDesign.LightTheme,
      darkTheme: SonrDesign.DarkTheme,
      getPages: Route.pages,
      initialBinding: InitialBinding(),
      navigatorKey: Get.key,
      navigatorObservers: [
        GetObserver(),
        PosthogObserver(),
      ],
      title: _title(),
      home: _buildScaffold(),
    );
  }

  String _title() {
    if (isDesktop) {
      return "Sonr Desktop";
    }
    return "";
  }

  Widget _buildScaffold() {
    if (isDesktop) {
      return Scaffold(
          backgroundColor: Get.theme.backgroundColor,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              // @ Rive Animation
              Center(
                child: CircularProgressIndicator(),
              ),

              // @ Fade Animation of Text
              Positioned(
                bottom: 100,
                child: FadeInUp(child: "Sonr".hero()),
              ),
            ],
          ));
    }
    return Scaffold(
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
              child: FadeInUp(delay: 2222.milliseconds, child: "Sonr".hero()),
            ),
          ],
        ));
  }
}
