import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/widgets/widgets.dart';

class OrientationState extends StatelessWidget {
  static const TextStyle bigTextStyle = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Accelerometer')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 60.0),
            child: Center(
              child: BlocBuilder<MotionBloc, MotionState>(
                builder: (context, state) {
                  return Text(state.position.state.toString(),
                    style: OrientationState.bigTextStyle,
                  );
                },
              ),
            ),
          ),
          BlocBuilder<MotionBloc, MotionState>(
            condition: (previousState, state) =>
                state.runtimeType != previousState.runtimeType,
            builder: (context, state) => OrientationActions(),
          ),
        ],
      ),
    );
  }
}