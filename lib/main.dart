// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/repositories/repositories.dart';
import 'package:sonar_app/widgets/widgets.dart';

import 'blocs/blocs.dart';
import 'blocs/bloc_delegate.dart';

class Sonar extends StatelessWidget {

  final DirectionRepository directionRepository;

  const Sonar({Key key, this.directionRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather',
      home: BlocProvider(
        create: (context) =>
            HomeBloc(directionRepository: directionRepository),
        child: Direction(),
      ),
    );
  }
}

void main() {
  // Run App
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(Sonar());
}
