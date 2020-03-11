import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/controllers/process.dart';
import 'package:sonar_app/bloc/bloc.dart';

class OrientationActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        sensorBloc: BlocProvider.of<SensorBloc>(context),
        sonarBloc: BlocProvider.of<SonarBloc>(context),
      ),
    );
  }

  List<Widget> _mapStateToActionButtons(
      {SensorBloc sensorBloc, SonarBloc sonarBloc}) {
    // Initialize
    final SonarState sonarState = sonarBloc.state;
    final SensorState sensorState = sensorBloc.state;
    if (sonarState is Initial) {
      return [
        FloatingActionButton(
            child: Icon(Icons.cloud_upload),
            onPressed: () {
              sonarBloc.add(Initialize());
            }),
      ];
    } else if (sonarState is Sending) {
      if (sensorState is Tilted) {
        for (final value in sonarState.matches.values) {
          var matchDirection = value["direction"]["direction"];
          print(sensorState.direction.degrees);
          print( matchDirection["antipodal_degrees"]);
          var difference = sensorState.direction.degrees - matchDirection["antipodal_degrees"];
          difference.abs();
          print("Match/Client Difference: " + difference.toString());
        }
      }
      
    }
    return [];
  }
}
