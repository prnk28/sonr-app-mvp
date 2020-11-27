import 'bloc/sonrN/sonr_service.dart';
import 'routing.dart';
import 'package:sonar_app/screens/screens.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

// ** Global Functional Injection ** //
final sonrService = RM.inject(() => SonrService());

// ^ Main Method ^ //
void main() async {
  // Run App with BLoC Providers
  runApp(initializeBloc(App()));
}

// ^ Master Widget ^ //
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
        child: NeumorphicApp(
      navigatorKey: RM.navigate.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.light,
      home: SplashScreen(),
      onGenerateRoute: context.getRouting(),
    ));
  }
}
