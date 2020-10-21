import 'package:sonar_app/screens/screens.dart';

part 'auth.dart';
part 'download.dart';

class Window {
  static Widget showAuth(BuildContext context, Requested state) {
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

  static Widget popupComplete() {}
}
