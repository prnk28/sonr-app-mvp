import 'package:sonar_app/screens/screens.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_app/bloc/bloc.dart';

part 'auth.dart';
part 'progress.dart';
class Window {
  static Widget showAuth(BuildContext context, NodeRequestInitial state) {
    return Container(
        decoration: windowDecoration(context),
        height: screenSize.height / 3,
        child: buildAuthenticationView(context, state));
  }

  static Widget showTransferring(BuildContext context) {
    return Container(
        decoration: windowDecoration(context),
        height: screenSize.height / 3,
        child: buildProgressView(context));
  }
}
