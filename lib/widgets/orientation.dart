import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/repositories/repositories.dart';
import 'package:sonar_app/widgets/widgets.dart';

class OrientationWidget extends StatelessWidget {
  static const TextStyle bigTextStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    // Sonar Repo
    SonarRepository _sonarRepository = new SonarRepository();

    // Top Down
    return Scaffold(
      appBar: AppBar(title: Text('Sonar Demo')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),

            // Build With Sensor Bloc
            child: BlocBuilder<SensorBloc, SensorState>(
              builder: (context, state) {
                SonarState sonarState
                = BlocProvider.of<SonarBloc>(context).state;
                // Check Sensor Tilted
                if (state is Tilted) {
                  // Call Sending Action
                  _sonarRepository.setSending(state.direction);

                  var _differences = [];
                  // Iterate Between Matches
                  if (sonarState is Sending) {
                    for (final value in sonarState.matches.values) {
                      var matchDirection = value["direction"];
                      var difference = state.direction.degrees -
                          matchDirection["antipodal_degrees"];
                      difference.abs();
                      print(value);
                      _differences.add(difference);
                    }
                  }

                  // Return Text Widget
                  return Text(
                    state.motion.state.toString() +
                        " , " +
                        state.direction.degrees.toString() + ", Match/Client Difference: " + _differences.toString(),
                    style: OrientationWidget.bigTextStyle,
                  );
                }
                // Check Sensor Landscape
                else if (state is Landscaped) {
                  // Call Receiving Action
                  _sonarRepository.setReceiving(state.direction);

                  // Return Text Widget
                  return Text(
                    state.motion.state.toString() +
                        " , " +
                        state.direction.degrees.toString(),
                    style: OrientationWidget.bigTextStyle,
                  );
                }
                // Check Sensor Default
                else {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Return Text Widget
                        Text(
                          "Waiting to Begin.",
                          style: OrientationWidget.bigTextStyle,
                        ),
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
