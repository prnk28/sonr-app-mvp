import 'package:flutter/material.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';

class SendingView extends StatelessWidget {
  final state;
  final SonarBloc sonarBloc;

  SendingView(this.state, this.sonarBloc);
  @override
  Widget build(BuildContext context) {
    // Closeset Within Threshold
    if (state.matches.valid()) {
      // Begin Timer 2s
      // const twentySeconds = const Duration(seconds: 2);
      // new Timer(
      //     twentySeconds,
      //     () =>
      sonarBloc.add(Request(state.matches.closest()["id"]));

      // Return Text Widget
      return Text(
        state.currentMotion.state.toString() +
            " , " +
            state.currentDirection.degrees.toString() +
            ", Match/Client Difference: " +
            state.matches.closest()["difference"].toString(),
        style: Design.mediumTextStyle,
      );
    } else {
      // Return Text Widget
      return Text(
          state.currentMotion.state.toString() +
              " No Receivers, " +
              state.currentDirection.degrees.toString(),
          style: Design.bigTextStyle);
    }
  }
}
