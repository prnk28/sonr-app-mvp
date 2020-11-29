import 'package:flutter/material.dart';
import 'ui/screens.dart';

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

      // Device Sensors Logic
      BlocProvider<DeviceBloc>(
        create: (context) => DeviceBloc(),
      ),
    ],
    child: app,
  );
}
