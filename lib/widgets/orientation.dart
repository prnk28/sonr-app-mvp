import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/bloc/bloc.dart';

class OrientationWidget extends StatelessWidget {
  static const TextStyle bigTextStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    // Top Down
    return Scaffold(
      appBar: AppBar(title: Text('Sonar Demo')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),

            // Build With Sensor Bloc
            child: BlocBuilder<SonarBloc, SonarState>(
              builder: (context, state) {
                print(state);
                // Check Tilt
                if (state is Sending) {
                  if (state.matches.valid()) {
                    // Withing Threshold
                    if (state.matches.closest()["difference"] <= 30) {
                      // Begin Timer 2s
                      const twentySeconds = const Duration(seconds: 2);
                      new Timer(
                          twentySeconds,
                          () => BlocProvider.of<SonarBloc>(context)
                              .add(Request()));
                    }

                    // Return Text Widget
                    return Text(
                      state.currentMotion.state.toString() +
                          " , " +
                          state.currentDirection.degrees.toString() +
                          ", Match/Client Difference: " +
                          state.matches.closest()["difference"].toString(),
                      style: OrientationWidget.bigTextStyle,
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
                } else if (state is Receiving) {
                  if (state.matches.valid()) {
                    // Determine Tween Value
                    var tweenValue;

                    // Withing Threshold
                    if (state.matches.closest()["difference"] <= 30) {
                      tweenValue = 0.0;
                    }
                    // Close to threshold
                    else if (state.matches.closest()["difference"] <= 160) {
                      tweenValue = state.matches.closest()["difference"];
                    }
                    // Not in threshold
                    else {
                      tweenValue = 1.0;
                    }

                    // Create Color Tween Based on Client Differences
                    var colorTween =
                        ColorTween(begin: Colors.red, end: Colors.blue)
                            .lerp(tweenValue);

                    // Return Text Widget
                    return Text(
                        state.currentMotion.state.toString() +
                            " , " +
                            state.currentDirection.degrees.toString() +
                            " , " +
                            ", Match/Client Difference: " +
                            state.matches.closest()["difference"].toString(),
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
                } else if (state is Pending) {
                  if (state.status == "SENDER") {
                    return Text(
                        "Pending Authorization from " +
                            state.match["profile"]["firstName"].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ));
                  } else if (state.status == "RECEIVER") {
                    return AlertDialog(
                      title: Text("Accept"),
                      content: Text("Request from " +
                          state.match["profile"]["firstName"].toString()),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              BlocProvider.of<SonarBloc>(context)
                                  .add(Authorize(true, state.match["id"]));
                            },
                            child: Text("Yes")),
                        FlatButton(
                            onPressed: () {
                              BlocProvider.of<SonarBloc>(context)
                                  .add(Authorize(false, state.match["id"]));
                            },
                            child: Text("No")),
                      ],
                    );
                  }
                } else {
// Check Sensor Default
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Return Text Widget
                        Text(
                          "Waiting to Begin.",
                          style: OrientationWidget.bigTextStyle,
                        ),
                        Divider(),
                        FloatingActionButton(
                            child: Icon(Icons.cloud_upload),
                            onPressed: () {
                              BlocProvider.of<SonarBloc>(context)
                                  .add(Initialize());
                            }),
                      ]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
