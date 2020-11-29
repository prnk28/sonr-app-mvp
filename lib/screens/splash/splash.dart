import 'package:sonar_app/controller/controller.dart';
import 'package:sonar_app/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final SonrController c = Get.put(SonrController());
    // Check Permissions
    context.getBloc(BlocType.Device).add(StartApp());

    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        // Non Build States
        body: BlocListener<DeviceBloc, DeviceState>(
            listener: (past, curr) {
              // Home Screen
              if (curr is DeviceActive) {
                Get.offNamed("/home");
              }
              // Register Screen
              else if (curr is ProfileError) {
                Get.offNamed("/register");
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: Get.width / 5,
                    height: Get.height / 5,
                    child: FittedBox(
                        child: Image.asset("assets/images/icon.png"))),

                // Loading
                Padding(
                    padding: EdgeInsets.only(left: 45, right: 45),
                    child: NeumorphicProgressIndeterminate())
              ],
            )));
  }
}
