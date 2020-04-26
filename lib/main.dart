// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/views/views.dart';

import 'bloc/bloc.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Design.data,
        title: 'Sonar',
        home: MultiBlocProvider(
            providers: [
              // Sonar Communication
              BlocProvider<SonarBloc>(
                create: (BuildContext context) => SonarBloc(),
              ),
            ],
            child: Scaffold(
              appBar: AppBar(title: Text('Sonar Demo')),
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
                          return SpinKitRing(color: Colors.white);
                        } else if (state is Received) {
                          return ReceivedView();
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
