import 'package:flutter/material.dart';
import 'package:sonar_app/bloc/bloc.dart';

class FailedView extends StatelessWidget {
  final SonarBloc sonarBloc;
  final state;

  const FailedView({Key key, this.sonarBloc, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set Display Timer
    sonarBloc.add(Reset(3));

    // Yield Decline Result
    return Text(
        state.profile["profile"]["first_name"].toString() + " has Declined.",
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ));
  }
}
