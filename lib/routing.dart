import 'package:flutter/material.dart';
import 'screens/screens.dart';

// ^ Routing Information ^ //
List<GetPage> getPages() {
  return [
    // ** Home Page ** //
    GetPage(
      name: '/',
      page: () => HomeScreen(),
    ),

    // ** Register Page ** //
    GetPage(
        name: '/',
        page: () => RegisterScreen(),
        transition: Transition.rightToLeftWithFade),

    // ** Searching Page ** //
    GetPage(
        name: '/', page: () => SearchingScreen(), transition: Transition.fade),
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
