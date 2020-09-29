import 'package:hive/hive.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/screens/screens.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';

// ** Main Method ** //
Future<void> main() async {
  // Set bloc observer to observe transitions
  Bloc.observer = SimpleBlocObserver();

  // Initialize HiveDB
  await Hive.initFlutter();

  // Run App with BLoC Providers
  runApp(MultiBlocProvider(
    providers: [
      // User Data Logic
      BlocProvider<UserBloc>(
        create: (context) => UserBloc(),
      ),

      // Local Data/Transfer Logic
      BlocProvider<DataBloc>(create: (context) => DataBloc()),

      // Device Input Logic
      BlocProvider<DeviceBloc>(
        create: (context) => DeviceBloc(),
      ),

      // Networking Logic
      BlocProvider<WebBloc>(
        create: (context) => WebBloc(BlocProvider.of<DataBloc>(context),
            BlocProvider.of<DeviceBloc>(context)),
      ),
    ],
    child: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: Design.lightTheme,
      darkTheme: Design.darkTheme,
      home: SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageTransition(
                child: HomeScreen(),
                type: PageTransitionType.fade,
                settings: settings);
            break;
          case '/register':
            return PageTransition(
                child: RegisterScreen(),
                type: PageTransitionType.rightToLeftWithFade,
                settings: settings);
            break;
          case '/transfer':
            return PageTransition(
                child: TransferScreen(),
                type: PageTransitionType.fade,
                settings: settings);
            break;
          case '/detail':
            return PageTransition(
                child: DetailScreen(),
                type: PageTransitionType.scale,
                settings: settings);
            break;
          case '/settings':
            return PageTransition(
                child: SettingsScreen(),
                type: PageTransitionType.upToDown,
                settings: settings);
            break;
        }
      },
    );
  }
}
