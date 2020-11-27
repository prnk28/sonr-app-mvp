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
        child: NeumorphicApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.light,
      home: SplashScreen(),
      onGenerateRoute: context.getRouting(),
    ));
  }
}
