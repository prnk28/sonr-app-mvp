import 'package:hive/hive.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/screens/screens.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ** Main Method ** //
void main() async {
  // Initialize HiveDB
  await Hive.initFlutter();

  // Initialize Hive Adapters
  Hive.registerAdapter(ProfileAdapter());

  // Get a location using getDatabasesPath
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, DATABASE_PATH);

// Delete the database
  await deleteDatabase(path);

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
