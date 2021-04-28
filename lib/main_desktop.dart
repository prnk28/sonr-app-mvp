import 'package:flutter/material.dart';
import 'package:sonr_app/pages/desktop/views/main_view.dart';
import 'data/data.dart';
import 'package:sonr_app/theme/theme.dart';
import 'service/device/desktop.dart';

// This file is the default main entry-point for go-flutter application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SonrRouting.initServices(isDesktop: true);
  runApp(DesktopApp());
}

class DesktopApp extends StatelessWidget {
  const DesktopApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sonr Desktop',
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
      home: MainDesktopView(
        title: 'Home',
      ),
    );
  }
}
