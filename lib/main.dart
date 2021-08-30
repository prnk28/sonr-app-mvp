import 'dart:async';

import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';

/// #### Handles Background Push Notification
Future<void> _handleBackgroundPush(RemoteMessage message) async {
  // Initialize App if Not Set
  await Firebase.initializeApp();

  // Handle Intercom Message
  if (await Intercom.isIntercomPush(message.data)) {
    await Intercom.handlePush(message.data);
    return;
  }
}

/// #### Main Method
Future<void> main() async {
  // Init Services
  WidgetsFlutterBinding.ensureInitialized();

  // Register Handler for Background Push
  if (PlatformUtils.find().isMobile) {
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundPush);
  }

  // Services
  await AppServices.init();

  // Check Platform
  if (DeviceService.hasInternet) {
    runApp(SplashPage());
  } else {
    runApp(SplashPage());
  }
}

/// #### Root App Widget
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DeviceService.keyboardHide();
    return GetMaterialApp(
      onInit: () => _checkInitialPage(),
      themeMode: Preferences.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.LightTheme,
      darkTheme: AppTheme.DarkTheme,
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
      home: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
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
              placeholder: SizedBox(child: CircleLoader()),
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
    if (DeviceService.hasInternet) {
      if (ContactService.status.value.isNew) {
        AppPage.Register.off();
      }
      // # Handle Returning
      else {
        // All Valid
        if (await Permissions.Location.isGranted) {
          AppPage.Home.off(args: HomeArguments.FirstLoad);
        }

        // No Location
        else {
          Permissions.Location.request().then((value) {
            if (value) {
              AppPage.Home.off(args: HomeArguments.FirstLoad);
            }
          });
        }
      }
    } else {
      AppPage.Error.to(args: ErrorPageArgs.noNetwork());
    }
  }
}
