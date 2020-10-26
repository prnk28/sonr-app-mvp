import 'dart:ui';

import 'package:sonar_app/screens/screens.dart';
import 'dart:math' as math;

part 'bubble.dart';
part 'zone.dart';
part 'compass.dart';

class SearchingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Return Widget
    return Scaffold(
        appBar: leadingAppBar(context, Icons.close, onPressed: () {
          // Pop Navigation
          Navigator.pushReplacementNamed(context, "/home");
        }),
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              // Range Lines
              rangeLines(),

              // Bubble View
              ZoneView(),

              // Have BLoC Builder Retrieve Directly from
              BlocBuilder<DirectionCubit, double>(
                  cubit: context.getCubit(CubitType.Direction),
                  builder: (context, state) {
                    return Align(
                        alignment: Alignment.bottomCenter,
                        child: CompassView(direction: state));
                  })
            ],
          ),
        ));
  }
}
