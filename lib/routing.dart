import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/events.dart';
import 'screens/screens.dart';

// ******************* //
// ** Build Routing ** //
// ******************* //
extension Routing on BuildContext {
  // ** Navigator Methods **

  // Display Transfer as Modal
  pushTransfer() {
    // Change View as Modal
    Navigator.push(
      this,
      MaterialPageRoute(
          maintainState: false,
          builder: (context) => SearchingScreen(),
          fullscreenDialog: true),
    );
  }

  // ** Get Routing Information **
  Function(RouteSettings) getRouting() {
    return (settings) {
      switch (settings.name) {
        case '/home':
          // Update Status
          getBloc(BlocType.Sonr).add(NodeCancel());
          return PageTransition(
              child: HomeScreen(),
              type: PageTransitionType.fade,
              ctx: this,
              inheritTheme: true,
              settings: settings);
          break;
        case '/register':
          return PageTransition(
              child: RegisterScreen(),
              type: PageTransitionType.rightToLeftWithFade,
              ctx: this,
              inheritTheme: true,
              settings: settings);
          break;
        case '/transfer':
          // Update Status
          getBloc(BlocType.Sonr).add(NodeSearch());
          return PageTransition(
              child: SearchingScreen(),
              type: PageTransitionType.fade,
              ctx: this,
              inheritTheme: true,
              settings: settings);
          break;
        case '/detail':
          // TODO: Implement Detail Screen
          // return PageTransition(
          //     child: DetailScreen(),
          //     type: PageTransitionType.scale,
          //     ctx: this,
          //     inheritTheme: true,
          //     settings: settings);
          // break;
        case '/settings':
          return PageTransition(
              child: SettingsScreen(),
              type: PageTransitionType.topToBottom,
              ctx: this,
              inheritTheme: true,
              settings: settings);
          break;
      }
      return null;
    };
  }
}

// *********************** //
// ** Build BLoC System ** //
// *********************** //
MultiBlocProvider initializeBloc(Widget app) {
  // Set bloc observer to observe transitions
  Bloc.observer = SimpleBlocObserver();

  // Return Provider
  return MultiBlocProvider(
    providers: [
      // User Data Logic
      BlocProvider<SonrBloc>(
        create: (context) => SonrBloc(),
      ),

      // Device Sensors Logic
      BlocProvider<DeviceBloc>(
        create: (context) => DeviceBloc(
          BlocProvider.of<SonrBloc>(context),
        ),
      ),
    ],
    child: app,
  );
}
