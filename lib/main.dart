// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/screens/screens.dart';

void main() {
  // We can set a Bloc's observer to an instance of `SimpleBlocObserver`.
  // This will allow us to handle all transitions and errors in SimpleBlocObserver.
  Bloc.observer = SimpleBlocObserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<SonarBloc>(
        create: (context) => SonarBloc(),
      ),
      BlocProvider<AccountBloc>(
        create: (context) => AccountBloc(),
      ),
      BlocProvider<DataBloc>(
        create: (context) => DataBloc(),
      )
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
      initialRoute: '/',
      routes: {
        // Splash Screen
        '/': (context) {
          return SplashScreen();
        },

        // Home Screen
        '/home': (context) => HomeScreen(),

        // Register Screen
        '/register': (context) => RegisterScreen(),

        // Transfer Screen
        '/transfer': (context) => TransferScreen(),

        // Detail Screen
        '/detail': (context) => DetailScreen(),

        // Settings Screen
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
