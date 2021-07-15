import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';

Future<void> _handleBackgroundPush(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
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
    runZonedGuarded(() {
      runApp(SplashPage(isDesktop: DeviceService.isDesktop));
    }, FirebaseCrashlytics.instance.recordError);
  } else {
    runApp(SplashPage(isDesktop: DeviceService.isDesktop));
  }
}

/// #### Root App Widget
class SplashPage extends StatelessWidget {
  final bool isDesktop;
  const SplashPage({Key? key, required this.isDesktop}) : super(key: key);
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
                child: CircleLoader(),
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
        if (isDesktop) {
          // Create User
          await ContactService.newContact(Contact(
              profile: Profile(
            firstName: "Anonymous",
            lastName: DeviceService.device.platform.toString(),
          )));

          // Connect to Network
          AppPage.Home.off(init: NodeService.to.connect, args: HomeArguments(isFirstLoad: true));
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
        } else {
          AppPage.Home.off(args: HomeArguments.FirstLoad);
        }
      }
    } else {
      AppPage.Error.to(args: ErrorPageArgs.noNetwork());
    }
  }
}
