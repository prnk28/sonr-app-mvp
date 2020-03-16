import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/models/models.dart';
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
                SonarState sonarState =
                    BlocProvider.of<SonarBloc>(context).state;
                // Check Sensor Tilted
                if (state is Tilted) {
                  // Call Sending Action
                  _sonarRepository.setSending(state.direction);
                  var circle;

                  // Iterate Between Matches
                  if (sonarState is Sending) {
                    circle = new Circle(
                        sonarState.matches.values, state.direction, true);
                  }

                  // Return Text Widget
                  return Text(
                    state.motion.state.toString() +
                        " , " +
                        state.direction.degrees.toString() +
                        ", Match/Client Difference: " +
                        circle.closestMatch["difference"].toString(),
                    style: OrientationWidget.bigTextStyle,
                  );
                }
                // Check Sensor Landscape
                else if (state is Landscaped) {
                  // Call Receiving Action
                  _sonarRepository.setReceiving(state.direction);
                  var circle;

                  // Iterate Between Matches
                  if (sonarState is Receiving) {
                    circle = new Circle(
                        sonarState.matches.values, state.direction, false);
                  }
var colorTween = ColorTween(begin: Colors.red, end: Colors.blue).lerp(circle.closestMatch["difference"]);


                  // Return Text Widget
                  return Text(
                    state.motion.state.toString() +
                        " , " +
                        state.direction.degrees.toString() +
                        " , " +
                        ", Match/Client Difference: " +
                        circle.closestMatch["difference"].toString(),
                    style: TextStyle(color: colorTween, fontSize: 40,
    fontWeight: FontWeight.bold,)
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
