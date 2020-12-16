import 'package:sonar_app/controller/controller.dart';
import 'package:sonar_app/ui/ui.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        // Non Build States
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: Get.width / 5,
                height: Get.height / 5,
                child: FittedBox(child: Image.asset("assets/images/icon.png"))),

            // Loading
            Padding(
                padding: EdgeInsets.only(left: 45, right: 45),
                child: NeumorphicProgressIndeterminate())
          ],
        ));
  }
}
