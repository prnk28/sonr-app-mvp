import 'package:sonar_app/screens/screens.dart';
import 'package:sonr_core/sonr_core.dart';

part 'view/initialize.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: logoAppBar(),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: BlocBuilder<DeviceBloc, DeviceState>(buildWhen: (prev, curr) {
        if (curr is DeviceActive) {
          // Push to Home with Profile
          Get.offNamed("/home");
          return false;
        }
        // Register Screen
        else if (curr is ProfileError) {
          return true;
          // Default
        } else {
          return false;
        }
      }, builder: (context, state) {
        // Display Login/Signup View
        if (state is ProfileError) {
          return Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: InitializeView())
          ]);
        }
        // On Error
        else {
          // Log
          log.e("User shouldnt be stuck at register page");

          // Dummy Widget
          return Center(child: NeumorphicProgressIndeterminate());
        }
      }),
    );
  }
}
