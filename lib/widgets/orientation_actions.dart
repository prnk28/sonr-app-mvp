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
        motionBloc: BlocProvider.of<OrientationBloc>(context),
        sonarBloc: BlocProvider.of<SonarBloc>(context),
      ),
    );
  }

  List<Widget> _mapStateToActionButtons({
    OrientationBloc motionBloc, SonarBloc sonarBloc
  }) {
    final OrientationState currentState = motionBloc.state;
    final SonarState currentSonarState = sonarBloc.state;
    if (currentSonarState is Initial) {
      return [
        FloatingActionButton(
          child: Icon(Icons.cloud_upload),
          onPressed: () {
              sonarBloc.add(Initialize(runningProcess: Process.create(null, null)));
              motionBloc.add(Start(position: currentState.position));
          }
        ),
      ];
    }
    return [];
  }
}
