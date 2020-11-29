import 'package:sonar_app/screens/screens.dart';
import 'bubble/bubble.dart';
import 'compass/compass.dart';

class SearchingScreen extends StatelessWidget {
  final SonrController sonr = Get.find();
  @override
  Widget build(BuildContext context) {
    // Return Widget
    return AppTheme(Scaffold(
        appBar: exitAppBar(context, Icons.close, onPressed: () {
          Get.offAllNamed("/home");
        }),
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            // @ Range Lines
            Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: CustomPaint(
                  size: Size(Get.width, Get.height),
                  painter: ZonePainter(),
                  child: Container(),
                )),

            // @ Bubble View
            Obx(() {
              // Check Peers Size
              if (sonr.peers().length > 0) {
                // Initialize Widget List
                List<Widget> stackWidgets = new List<Widget>();

                // Init Stack Vars
                int total = sonr.peers().length;
                int current = 0;
                double mean = 1.0 / total;

                // Create Bubbles
                sonr.peers().values.forEach((peer) {
                  // Increase Count
                  current += 1;

                  // Place Bubble
                  stackWidgets.add(new Bubble(current * mean, peer, sonr.auth()));
                });

                // Return View
                return Stack(children: stackWidgets);
              }
              return Container();
            }),

            // @ Have BLoC Builder Retrieve Directly from Compass
            BlocBuilder<DirectionCubit, double>(
                cubit: BlocProvider.of<DeviceBloc>(context).directionCubit,
                builder: (context, state) {
                  return Align(
                      alignment: Alignment.bottomCenter,
                      child: CompassView(direction: state));
                })
          ],
        ))));
  }
}
