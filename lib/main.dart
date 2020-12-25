import 'dart:async';

import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/service/sql_service.dart';
import 'package:sonar_app/service/device_service.dart';
import 'modules/home/home_binding.dart';
import 'modules/profile/profile_binding.dart';
import 'modules/register/register_screen.dart';
import 'modules/transfer/transfer_binding.dart';

// ^ Main Method ^ //
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(App());
}

// ^ Services (Files, Contacts) ^ //
initServices() async {
  await Get.putAsync(() => SQLService().init());
  await Get.putAsync(() => SocialMediaService().init());
  await Get.putAsync(() => DeviceService().init());
}

// ^ Initial Controller Bindings ^ //
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AppController>(AppController(), permanent: true);
    Get.put<SonrCardController>(SonrCardController(), permanent: true);
  }
}

// ^ Routing Information ^ //
List<GetPage> getPages() {
  return [
    // ** Home Page ** //
    GetPage(
        name: '/home',
        page: () => SonrTheme(child: HomeScreen()),
        transition: Transition.zoom,
        binding: HomeBinding()),

    // ** Home Page - Back ** //
    GetPage(
        name: '/home/transfer',
        page: () => SonrTheme(child: HomeScreen()),
        transition: Transition.size,
        binding: HomeBinding()),

    // ** Home Page - Back ** //
    GetPage(
        name: '/home/profile',
        page: () => SonrTheme(child: HomeScreen()),
        transition: Transition.downToUp,
        binding: HomeBinding()),

    // ** Register Page ** //
    GetPage(
        name: '/register',
        page: () => SonrTheme(child: RegisterScreen()),
        transition: Transition.fade),

    // ** Transfer Page ** //
    GetPage(
        name: '/transfer',
        page: () => SonrTheme(child: TransferScreen()),
        transition: Transition.size,
        binding: TransferBinding()),

    // ** Profile Page ** //
    GetPage(
        name: '/profile',
        page: () => SonrTheme(child: ProfileScreen()),
        transition: Transition.upToDown,
        fullscreenDialog: true,
        binding: ProfileBinding()),
  ];
}

// ^ For handling inbound files/url ^ //
class AppController extends GetxController {
  StreamSubscription _intentDataStreamSubscription;
  final incomingFile = Rx<SharedMediaFile>();
  final incomingText = "".obs;

  @override
  void onInit() {
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      incomingFile(value.first);
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      incomingFile(value.first);
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      incomingText(value);
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      incomingText(value);
    });
    super.onInit();
  }

  @override
  void onClose() {
    _intentDataStreamSubscription.cancel();
    super.onClose();
  }
}

// ^ Root App Widget ^ //
class App extends GetView<AppController> {
  // @ Handle Sharing Intent
  App() {
    // Listen to Incoming File
    controller.incomingFile.listen((file) {
      print("Incoming File: " + file.toString());
    });

    // Listen to Incoming Text
    controller.incomingText.listen((text) {
      print("Incoming Text: " + text);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Connect to Sonr Network
    Get.find<DeviceService>().start();

    // Build View
    return GetMaterialApp(
      getPages: getPages(),
      initialBinding: InitialBinding(),
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: Scaffold(
          backgroundColor: NeumorphicTheme.baseColor(context),
          // Non Build States
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: Get.width / 5,
                  height: Get.height / 5,
                  child:
                      FittedBox(child: Image.asset("assets/images/icon.png"))),

              // Loading
              Padding(
                  padding: EdgeInsets.only(left: 45, right: 45),
                  child: NeumorphicProgressIndeterminate())
            ],
          )),
    );
  }
}
