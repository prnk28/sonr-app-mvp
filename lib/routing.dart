import 'package:flutter/material.dart';
import 'screens/screens.dart';

// ^ Routing Information ^ //
List<GetPage> getPages() {
  return [
    // ** Home Page ** //
    GetPage(
        name: '/home',
        page: () => AppTheme(HomeScreen()),
        transition: Transition.zoom),

    // ** Register Page ** //
    GetPage(
        name: '/register',
        page: () => AppTheme(RegisterScreen()),
        transition: Transition.rightToLeftWithFade),

    // ** Searching Page ** //
    GetPage(
        name: '/transfer',
        page: () => AppTheme(SearchingScreen()),
        transition: Transition.fade),
  ];
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
      // File Management
      BlocProvider<FileBloc>(
        create: (context) => FileBloc(),
      ),

      // Sonr Networking Logic
      BlocProvider<SonrBloc>(
        create: (context) => SonrBloc(),
      ),

      // Device Sensors Logic
      BlocProvider<DeviceBloc>(
        create: (context) => DeviceBloc(),
      ),
    ],
    child: app,
  );
}
