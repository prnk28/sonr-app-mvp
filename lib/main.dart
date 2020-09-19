// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/screens/screens.dart';
import 'package:sonar_app/screens/settings.dart';
import 'package:sonar_app/views/views.dart';

void main() {
  // We can set a Bloc's observer to an instance of `SimpleBlocObserver`.
  // This will allow us to handle all transitions and errors in SimpleBlocObserver.
  Bloc.observer = SimpleBlocObserver();
  runApp(
    BlocProvider(
      create: (context) {
        return SonarBloc();
      },
      child: App(),
    ),
  );
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
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/register': (context) => RegisterScreen(),
        '/transfer': (context) => TransferScreen(),
        '/detail': (context) => DetailScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
