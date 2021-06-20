import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/style.dart';
import 'package:feedback/feedback.dart';

/// @ Main Method
Future<void> main() async {
  // Init Services
  WidgetsFlutterBinding.ensureInitialized();
  await AppServices.init();

  // Check Platform
  if (DeviceService.isMobile) {
    runZonedGuarded(() {
      runApp(BetterFeedback(child: App(isDesktop: false)));
    }, FirebaseCrashlytics.instance.recordError);
  } else {
    runApp(App(isDesktop: true));
  }
}

/// @ Root App Widget
class App extends StatelessWidget {
  final bool isDesktop;
  const App({Key? key, required this.isDesktop}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DeviceService.hideKeyboard();
    return GetMaterialApp(
      onInit: () => _checkInitialPage(),
      themeMode: ThemeMode.system,
      theme: SonrTheme.LightTheme,
      darkTheme: SonrTheme.DarkTheme,
      getPages: [
        AppPage.Home.config(),
        AppPage.Register.config(),
        AppPage.Transfer.config(),
      ],
      initialBinding: InitialBinding(),
      navigatorKey: Get.key,
      navigatorObservers: [
        GetObserver(),
        Logger.Observer,
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
                child: HourglassIndicator(),
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
              type: RiveBoard.Splash,
              width: Get.width,
              height: Get.height,
              placeholder: SizedBox(child: HourglassIndicator()),
            ),

            // @ Fade Animation of Text
            Positioned(
              bottom: 100,
              child: FadeInUp(delay: 2222.milliseconds, child: "Sonr".hero()),
            ),
          ],
        ));
  }

  Future<void> _checkInitialPage() async {
    await Future.delayed(3500.milliseconds);

    // # Check for User
    if (!ContactService.hasUser.value) {
      // Anonymous Desktop
      if (isDesktop) {
        // Get Contact from Values
        var contact = Contact(
            profile: Profile(
          firstName: "Anonymous",
          lastName: DeviceService.platform.toString(),
        ));

        // Create User
        await ContactService.newContact(contact);

        // Connect to Network
        AppPage.Home.off(init: NodeService.to.connect, args: HomePageArgs(isFirstLoad: true));
      }
      // Register Mobile
      else {
        AppPage.Register.off();
      }
    }
    // # Handle Returning
    else {
      // Check Platform
      if (!isDesktop) {
        // All Valid
        if (MobileService.hasLocation.value) {
          AppPage.Home.off(args: HomePageArgs(isFirstLoad: true));
        }

        // No Location
        else {
          MobileService.to.requestLocation().then((value) {
            if (value) {
              AppPage.Home.off(args: HomePageArgs(isFirstLoad: true));
            }
          });
        }
      } else {
        AppPage.Home.off(args: HomePageArgs(isFirstLoad: true));
      }
    }
  }
}
