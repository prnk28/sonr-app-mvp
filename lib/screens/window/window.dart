import 'package:sonar_app/screens/screens.dart';

part 'auth.dart';
part 'download.dart';

class Sheet {
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

  static Widget showComplete(BuildContext context, NodeTransferSuccess state) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: MediaQuery.of(context).size.height / 3,
        child: buildCompleteView(context, state));
  }
}

// TODO: Turn into a Full Method of Extending Modal BottomSheet
