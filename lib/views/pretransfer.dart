import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:vibration/vibration.dart';

class PreTransferView extends StatelessWidget {
  final state;

  const PreTransferView({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Vibration.vibrate();
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(state.profile["profile"]["first_name"].toString() + " has Accepted.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          )),
      Divider(),
      FloatingActionButton(
          child: Icon(Icons.image),
          onPressed: () {
            BlocProvider.of<SonarBloc>(context).add(Transfer());
          }),
      FloatingActionButton(
          child: Icon(Icons.surround_sound),
          onPressed: () {
            BlocProvider.of<SonarBloc>(context).add(Transfer());
          }),
    ]);
  }
}
