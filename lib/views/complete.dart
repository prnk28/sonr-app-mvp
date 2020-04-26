import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/bloc/bloc.dart';

class CompleteView extends StatelessWidget {
  final SonarBloc sonarBloc;

  const CompleteView({Key key, this.sonarBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}
