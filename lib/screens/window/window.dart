import 'package:sonar_app/screens/screens.dart';

part 'auth.dart';

class Window {
  static Widget showAuth(BuildContext context, Requested state) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width / 2,
        child: buildAuthenticationView(context, state.offer, state.from));
  }

  static Widget showLoading(BuildContext) {}

  static Widget popupComplete() {}
}
