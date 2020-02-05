import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/widgets/widgets.dart';

class OrientationWidget extends StatelessWidget {
  static const TextStyle bigTextStyle = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sonar Demo')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 45.0),
            child: Center(
              child: BlocBuilder<OrientationBloc, OrientationState>(
                builder: (context, state) {
                  return Text(
                    state.position.state.toString(),
                    style: OrientationWidget.bigTextStyle,
                  );
                },
              ),
            ),
          ),

          BlocBuilder<SonarBloc, SonarState>(
                builder: (context, state) => OrientationActions()
              ),
        ],
      ),
    );
  }
}
