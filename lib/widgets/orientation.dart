import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:vibration/vibration.dart';

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
                  // Closeset Within Threshold
                  if (state.matches.withinThreshold()) {
                    // Begin Timer 2s
                    const twentySeconds = const Duration(seconds: 2);
                    new Timer(
                        twentySeconds,
                        () => BlocProvider.of<SonarBloc>(context)
                            .add(Request(state.matches.closest()["id"])));

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
                            state.match["profile"]["first_name"].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ));
                  } else if (state.status == "RECEIVER") {
                    Vibration.vibrate();
                    print("Pending approval");
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Return Text Widget
                          Text(
                              "Request from " +
                                  state.match["profile"]["first_name"]
                                      .toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              )),
                          Divider(),
                          FloatingActionButton(
                              child: Icon(Icons.check),
                              onPressed: () {
                                BlocProvider.of<SonarBloc>(context)
                                    .add(Authorize(true, state.match["id"]));
                              }),
                          FloatingActionButton(
                              child: Icon(Icons.close),
                              onPressed: () {
                                BlocProvider.of<SonarBloc>(context)
                                    .add(Authorize(false, state.match["id"]));
                              }),
                        ]);
                  }
                } else if (state is PreTransfer) {
                  Vibration.vibrate();
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                            state.profile["profile"]["first_name"].toString() +
                                " has Accepted.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            )),
                        Divider(),
                        FloatingActionButton(
                            child: Icon(Icons.image),
                            onPressed: () {
                              BlocProvider.of<SonarBloc>(context)
                                  .add(Transfer("Image"));
                            }),
                        FloatingActionButton(
                            child: Icon(Icons.surround_sound),
                            onPressed: () {
                              BlocProvider.of<SonarBloc>(context)
                                  .add(Transfer("Audio"));
                            }),
                      ]);
                } else if (state is Failed) {
                  // Set Display Timer
                  BlocProvider.of<SonarBloc>(context).add(Reset(3));

                  // Yield Decline Result
                  return Text(
                      state.profile["profile"]["first_name"].toString() +
                          " has Declined.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ));
                } else if (state is Transferring) {
                  return SpinKitRing(color: Colors.white);
                } else if (state is Received) {
                  return Text("Received.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ));
                } else if (state is Complete) {
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
                          BlocProvider.of<SonarBloc>(context).add(Reset(0));
                        }),
                  ]);
                } else {
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
