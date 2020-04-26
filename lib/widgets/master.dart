import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/widgets/views/views.dart';

class MasterWidget extends StatelessWidget {
  static const TextStyle bigTextStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    // Top Down
    return Scaffold(
      appBar: AppBar(title: Text('Sonar Demo')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),

            // Build With Sensor Bloc
            child: BlocBuilder<SonarBloc, SonarState>(
              builder: (context, state) {
                print(state);
                if (state is Sending) {
                  return SendingView(
                      state, BlocProvider.of<SonarBloc>(context));
                } else if (state is Receiving) {
                  return ReceivingView(state: state);
                } else if (state is Pending) {
                  return PendingView(state: state);
                } else if (state is PreTransfer) {
                  return PreTransferView(state: state);
                } else if (state is Failed) {
                  return FailedView(
                      sonarBloc: BlocProvider.of<SonarBloc>(context),
                      state: state);
                } else if (state is Transferring) {
                  return SpinKitRing(color: Colors.white);
                } else if (state is Received) {
                  return ReceivedView();
                } else if (state is Complete) {
                  return CompleteView(
                      sonarBloc: BlocProvider.of<SonarBloc>(context));
                } else {
                  return InitializeView(
                      sonarBloc: BlocProvider.of<SonarBloc>(context));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
