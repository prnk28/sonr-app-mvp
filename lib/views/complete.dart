import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sonar_app/bloc/bloc.dart';

class CompleteView extends StatelessWidget {
  final dynamic sonarBloc;

  const CompleteView({Key key, this.sonarBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sonarBloc.state.status == "SENDER") {
      return Column(children: [
        Text("Complete.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            )),
        FloatingActionButton(
            child: Icon(Icons.done_all),
            onPressed: () {
              sonarBloc.add(Reset(0));
            }),
      ]);
    } else {
      File file = sonarBloc.state.file;

      return Column(children: [
        Text("Complete.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            )),
        Image.file(file),
        FloatingActionButton(
            child: Icon(Icons.done_all),
            onPressed: () {
              sonarBloc.add(Reset(0));
            }),
      ]);
    }
  }
}
