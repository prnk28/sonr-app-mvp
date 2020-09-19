// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/views/views.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: NeumorphicThemeData(
          baseColor: Color(0xffDDDDDD),
          accentColor: Colors.cyan,
          lightSource: LightSource.topLeft,
          depth: 6,
          intensity: 0.5,
        ),
        darkTheme: NeumorphicThemeData(
          baseColor: Color(0xff333333),
          accentColor: Colors.green,
          lightSource: LightSource.topLeft,
          depth: 4,
          intensity: 0.3,
        ),
        home: MultiBlocProvider(
            providers: [
              // Sonar Communication
              BlocProvider<SonarBloc>(
                create: (BuildContext context) => SonarBloc(),
              ),
            ],
            child: Scaffold(
              appBar: NeumorphicAppBar(
                title: NeumorphicText("Sonr",
                    style: NeumorphicStyle(
                      depth: 4, //customize depth here
                      color: Colors.white, //customize color here
                    ),
                    textStyle: Design.text.logo(),
                    textAlign: TextAlign.center),
              ),
              backgroundColor: NeumorphicTheme.baseColor(context),
              body: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: BlocBuilder<SonarBloc, SonarState>(
                      builder: (context, state) {
                        print(state);
                        if (state is Sending) {
                          return SendingView(
                              state, BlocProvider.of<SonarBloc>(context));
                        } else if (state is Receiving) {
                          return ReceivingView(state: state);
                        } else if (state is Pending) {
                          return PendingView(state: state);
                        } else if (state is PreTransfer) {
                          return PreTransferView(state: state);
                        } else if (state is Failed) {
                          return FailedView(
                              sonarBloc: BlocProvider.of<SonarBloc>(context),
                              state: state);
                        } else if (state is Transferring) {
                          return TransferView(
                              sonarBloc: BlocProvider.of<SonarBloc>(context),
                              state: state);
                        } else if (state is Complete) {
                          return CompleteView(
                              sonarBloc: BlocProvider.of<SonarBloc>(context));
                        } else {
                          return InitializeView(
                              sonarBloc: BlocProvider.of<SonarBloc>(context));
                        }
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}

void main() {
  runApp(App());
}
