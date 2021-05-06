import 'package:flutter/material.dart';
import 'data/data.dart';
import 'package:sonr_app/style/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SonrRouting.initServices(isDesktop: true);
  runApp(DesktopApp());
}

class DesktopApp extends StatefulWidget {
  const DesktopApp({Key? key}) : super(key: key);

  @override
  _DesktopAppState createState() => _DesktopAppState();
}

class _DesktopAppState extends State<DesktopApp> {
  @override
  void initState() {
    super.initState();

    // Shift Page
    DeviceService.initialPage(delay: 3500.milliseconds);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: SonrRouting.pages,
      initialBinding: InitialBinding(),
      title: 'Sonr Desktop',
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
      themeMode: UserService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
          backgroundColor: SonrColor.White,
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
                child: FadeInUp(child: "Sonr".hero),
              ),
            ],
          )),
    );
  }
}
