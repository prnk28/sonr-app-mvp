import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/bloc/bloc.dart';

class SonarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        sonarBloc: BlocProvider.of<SonarBloc>(context),
      ),
    );
  }

  List<Widget> _mapStateToActionButtons({
    SonarBloc sonarBloc,
  }) {
    final SonarState currentState = sonarBloc.state;
    if (currentState is Default) {
      return [
        FloatingActionButton(
          child: Icon(Icons.cloud_upload),
          onPressed: () =>
              sonarBloc.add(Initialize()),
        ),
      ];
    }
    return [];
  }
}
