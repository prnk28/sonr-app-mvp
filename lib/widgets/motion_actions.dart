import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/bloc/motion_bloc.dart';

class MotionActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        motionBloc: BlocProvider.of<MotionBloc>(context),
      ),
    );
  }

  List<Widget> _mapStateToActionButtons({
    MotionBloc motionBloc,
  }) {
    final MotionState currentState = motionBloc.state;
    if (currentState is Zero) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () =>
              motionBloc.add(Start(position: currentState.position)),
        ),
      ];
    }
    if (currentState is InMotion) {
      return [
        FloatingActionButton(
          child: Icon(Icons.pause),
          onPressed: () => motionBloc.add(Pause()),
        )
      ];
    }
    if (currentState is Send) {
      return [
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => motionBloc.add(Reset()),
        ),
      ];
    }
    if (currentState is Receive) {
      return [
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => motionBloc.add(Reset()),
        ),
      ];
    }
    return [];
  }
}
