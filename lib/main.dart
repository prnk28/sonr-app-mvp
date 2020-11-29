import 'package:get/get.dart';

import 'routing.dart';
import 'package:sonar_app/screens/screens.dart';

// ** Main Method ** //
void main() async {
  // Run App with BLoC Providers
  runApp(initializeBloc(App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
        child: GetMaterialApp(
      getPages: getPages(),
      navigatorKey: Get.key,
      navigatorObservers: [GetObserver()],
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: SplashScreen(),
    ));
  }
}
