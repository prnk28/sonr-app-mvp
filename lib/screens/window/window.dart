import 'package:sonar_app/screens/screens.dart';
import 'package:flutter/widgets.dart';
import 'package:sonar_app/bloc/bloc.dart';

part 'auth.dart';
part 'download.dart';
part 'popup.dart';

class Window {
  static Widget showAuth(BuildContext context, NodeRequestInitial state) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: MediaQuery.of(context).size.height / 3,
        child: buildAuthenticationView(context, state));
  }

  static Widget showTransferring(BuildContext context) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: MediaQuery.of(context).size.height / 3,
        child: buildProgressView(context));
  }

  static Widget showComplete(BuildContext context, NodeTransferSuccess state,
      void Function() onWindowTransferComplete) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: MediaQuery.of(context).size.height / 3,
        child: buildCompleteView(context, state, onWindowTransferComplete));
  }
}

// TODO: Turn into a Full Method of Extending Modal BottomSheet
class WindowSheet extends StatefulWidget {
  final UserState userState;
  WindowSheet({this.userState});
  _WindowSheetState createState() => _WindowSheetState();
}

class _WindowSheetState extends State<WindowSheet> {
  var heightOfModalBottomSheet = 100.0;
  Widget build(BuildContext context) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: MediaQuery.of(context).size.height / 3,
        child: buildAuthenticationView(context, widget.userState));
  }
}
