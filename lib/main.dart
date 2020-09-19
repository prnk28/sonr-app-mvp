// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
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
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => InitializeView(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          //'/second': (context) => SecondScreen(),
        },
        home: Scaffold(
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
        ));
  }
}
