import 'package:sonar_app/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final SonrStore c = Get.put(SonrStore());
    // Set Device Screen Bounds
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    screenSize = Size(screenWidth, screenHeight);

    // Check Permissions
    context.getBloc(BlocType.Device).add(StartApp());

    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        // Non Build States
        body: BlocListener<DeviceBloc, DeviceState>(
            listener: (past, curr) {
              // Home Screen
              if (curr is DeviceActive) {
                Navigator.pushReplacementNamed(context, "/home");
              }
              // Register Screen
              else if (curr is ProfileError) {
                Navigator.pushReplacementNamed(context, "/register");
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: screenSize.width / 5,
                    height: screenSize.height / 5,
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
