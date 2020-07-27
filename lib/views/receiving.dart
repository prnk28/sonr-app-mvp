import 'package:flutter/material.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';

class ReceivingView extends StatelessWidget {
  final Receiving state;

  const ReceivingView({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.matches.valid()) {
      // Determine Tween Value
      var tweenValue;

      // Withing Threshold
      if (state.matches.closestProfile()["difference"] <= 30) {
        tweenValue = 0.0;
      }
      // Close to threshold
      else if (state.matches.closestProfile()["difference"] <= 160) {
        tweenValue = state.matches.closestProfile()["difference"];
      }
      // Not in threshold
      else {
        tweenValue = 1.0;
      }

      // Create Color Tween Based on Client Differences
      var colorTween =
          ColorTween(begin: Colors.red, end: Colors.blue).lerp(tweenValue);

      // Return Text Widget
      return Text(
          state.currentMotion.state.toString() +
              " , " +
              state.currentDirection.degrees.toString() +
              " , " +
              ", Match/Client Difference: " +
              state.matches.closestProfile()["difference"].toString(),
          style: TextStyle(
            color: colorTween,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ));
    } else {
      // Return Text Widget
      return Text(
          state.currentMotion.state.toString() +
              " No Senders, " +
              state.currentDirection.degrees.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ));
    }
  }
}
