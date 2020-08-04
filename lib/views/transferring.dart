import 'package:flutter/material.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/views/views.dart';

class TransferView extends StatelessWidget {
  final SonarBloc sonarBloc;
  final Transferring state;

  const TransferView({Key key, this.sonarBloc, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Yield Decline Result
    return Column(
      children: [
        SpinKitRing(color: Colors.white),
        Divider(),
        // Text(
        //   "Receive Progress: " + (state.progress * 100).toString() + "%",
        //   style: Design.getTextStyle(TextDesign.DescriptionText),
        // )
      ],
    );
  }
}
