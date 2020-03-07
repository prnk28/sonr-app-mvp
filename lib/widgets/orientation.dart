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
      SonarRepository _sonarRepository = new SonarRepository();
    return Scaffold(
      appBar: AppBar(title: Text('Sonar Demo')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: BlocBuilder<SensorBloc, SensorState>(
              builder: (context, state) {
                if (state is Tilted) {
                  _sonarRepository.setSending(state.direction);
                  return Text(
                    state.motion.state.toString() +
                        " , " +
                        state.direction.degrees.toString(),
                    style: OrientationWidget.bigTextStyle,
                  );
                } else if (state is Landscaped) {
                  _sonarRepository.setReceiving(state.direction);
                  return Text(
                    state.motion.state.toString() +
                        " , " +
                        state.direction.degrees.toString(),
                    style: OrientationWidget.bigTextStyle,
                  );
                } else {
                  return Text(
                    "Waiting to Begin.",
                    style: OrientationWidget.bigTextStyle,
                  );
                }
              },
              
            ),
          ),
          BlocBuilder<SonarBloc, SonarState>(
              builder: (context, state) => OrientationActions()),
        ],
      ),
    );
  }
}
