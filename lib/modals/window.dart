import 'package:sonar_app/screens/screens.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonr_core/sonr_core.dart';

part 'auth.dart';
part 'progress.dart';

class Window {
  static Widget showAuth(BuildContext context, AuthMessage state) {
    // Return View
    return Container(
        decoration: windowDecoration(context),
        height: screenSize.height / 3 + 20,
        child: buildAuthenticationView(context, state));
  }

  // TODO: Implement progress update
  // static Widget showTransferring(
  //     BuildContext context, ProgressUpdate state) {
  //   // Return View
  //   return Container(
  //       decoration: windowDecoration(context),
  //       height: screenSize.height / 3 + 20,
  //       child: buildProgressView(state.metadata));
  // }
}
