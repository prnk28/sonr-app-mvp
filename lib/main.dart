import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/home/home_screen.dart';
import 'package:sonar_app/service/card_service.dart';
import 'package:sonar_app/service/device_service.dart';
import 'modules/register/register_screen.dart';
import 'modules/transfer/transfer_screen.dart';
import 'theme/neumorphic.dart';

// ** Main Method ** //
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(App());
}

// ^ Services (Files, Contacts) ^ //
// TODO: Convert SonrController to Service
initServices() async {
  print('starting services ...');
  // Initializes Worker Executer
  //await Executor().warmUp();

  // Initializes Local Contacts/Files and Device User/Settings
  await Get.putAsync(() => CardService().init());
  await Get.putAsync(() => DeviceService().init());
  print('All services started...');
}

// ^ Root Widget ^ //
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Connect to Sonr Network
    DeviceService device = Get.find();
    device.start();

    return GetMaterialApp(
      getPages: getPages(),
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

// ^ Routing Information ^ //
List<GetPage> getPages() {
  return [
    // ** Home Page ** //
    GetPage(
      name: '/home',
      page: () => SonrTheme(HomeScreen()),
      transition: Transition.zoom,
    ),

    // ** Register Page ** //
    GetPage(
        name: '/register',
        page: () => SonrTheme(RegisterScreen()),
        transition: Transition.rightToLeftWithFade),

    // ** Searching Page ** //
    GetPage(
      name: '/transfer',
      page: () => SonrTheme(TransferScreen()),
      transition: Transition.fade,
      // binding: BindingsBuilder.put(() => TransferController()),
    ),
  ];
}
