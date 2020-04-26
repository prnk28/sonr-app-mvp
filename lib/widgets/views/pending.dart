import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:vibration/vibration.dart';

class PendingView extends StatelessWidget {
  final state;

  const PendingView({Key key, this.state}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                    state.match["profile"]["first_name"].toString(),
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
                      .add(Authorize(true, state.match["id"], state.offer));
                }),
            FloatingActionButton(
                child: Icon(Icons.close),
                onPressed: () {
                  BlocProvider.of<SonarBloc>(context)
                      .add(Authorize(false, state.match["id"], state.offer));
                }),
          ]);
    }
  }
}
