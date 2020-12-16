import 'package:get/get.dart';
import 'package:sonar_app/ui/ui.dart';
import 'controller/bindings.dart';
import 'service/service.dart';

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

  /// Here is where you put get_storage, hive, shared_pref initialization.
  await Get.putAsync(() => CardService().init());
  await Get.putAsync(() => DeviceService().init());
  print('All services started...');
}

// ^ Root Widget ^ //
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Connect to Sonr Network
    final DeviceService device = Get.find();
    device.connectUser();

    return GetMaterialApp(
      getPages: getPages(),
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      initialBinding: AppBind(),
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
      page: () => AppTheme(HomeScreen()),
      transition: Transition.zoom,
    ),

    // ** Register Page ** //
    GetPage(
        name: '/register',
        page: () => AppTheme(RegisterScreen()),
        transition: Transition.rightToLeftWithFade),

    // ** Searching Page ** //
    GetPage(
      name: '/transfer',
      page: () => AppTheme(TransferScreen()),
      transition: Transition.fade,
      // binding: HomeBind(),
    ),
  ];
}
