import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/sonr_core.dart';

part 'form.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    UserController user = Get.find();
    user.addListenerId("Listener", () {
      if (user.status == UserStatus.Active) {
        Get.offNamed("/home");
      }
    });

    return Scaffold(
        appBar: logoAppBar(),
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0), child: FormView())
        ]));
  }
}
