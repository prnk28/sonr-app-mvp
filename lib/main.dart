// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/widgets/widgets.dart';

import 'bloc/bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Color.fromRGBO(109, 234, 255, 1),
          accentColor: Color.fromRGBO(72, 74, 126, 1),
          brightness: Brightness.dark,
        ),
        title: 'Sonar',
        home: MultiBlocProvider(
          providers: [
            // Motion Data Stream
            BlocProvider<SensorBloc>(
              create: (BuildContext context) =>
                  SensorBloc(),
            ),
            // Sonar Communication
            BlocProvider<SonarBloc>(
              create: (BuildContext context) =>
                  SonarBloc(BlocProvider.of<SensorBloc>(context)),
            ),
          ],
          child: OrientationWidget(),
        ));
  }
}

void main() {
  runApp(App());
}
