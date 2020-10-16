import 'package:hive/hive.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/screens/screens.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ** Main Method ** //
void main() async {
  // Set bloc observer to observe transitions
  Bloc.observer = SimpleBlocObserver();

  // Initialize HiveDB
  await Hive.initFlutter();

  // Initialize Hive Adapters
  Hive.registerAdapter(ProfileAdapter());

  // Run App with BLoC Providers
  runApp(initializeBloc(App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Setup Neumorphic Application
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.light,
      home: SplashScreen(),
      onGenerateRoute: getRouting(context),
    );
  }
}
