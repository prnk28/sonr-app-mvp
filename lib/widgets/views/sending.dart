import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/widgets/views/views.dart';
import 'package:vibration/vibration.dart';

import '../master.dart';

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
        style: MasterWidget.bigTextStyle,
      );
    } else {
      // Return Text Widget
      return Text(
          state.currentMotion.state.toString() +
              " No Receivers, " +
              state.currentDirection.degrees.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ));
    }
  }
}
