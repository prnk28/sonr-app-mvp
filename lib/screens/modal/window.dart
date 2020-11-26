import 'package:sonar_app/screens/screens.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonr_core/sonr_core.dart';

part 'auth.dart';
part 'progress.dart';

class Window {
  static Widget showAuth(BuildContext context, NodeInvited state) {
    // Get Screen Size
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Size screenSize = Size(width, height);

    // Return View
    return Container(
        decoration: windowDecoration(context),
        height: screenSize.height / 3 + 20,
        child: buildAuthenticationView(context, state));
  }

  static Widget showTransferring(
      BuildContext context, NodeReceiveInProgress state) {
    // Get Screen Size
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Size screenSize = Size(width, height);

    // Return View
    return Container(
        decoration: windowDecoration(context),
        height: screenSize.height / 3 + 20,
        child: buildProgressView(state.metadata, screenSize));
  }
}
