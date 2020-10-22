import 'dart:ui';

import 'package:sonar_app/screens/screens.dart';
import 'dart:math' as math;
// Views in Screen
part 'bubble.dart';
part 'compass.dart';
part 'transmit.dart';

class TransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Search
    context.getBloc(BlocType.User).add(NodeSearch());

    // Return Widget
    return Scaffold(
      appBar: leadingAppBar("/home", context, Icons.close),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: BlocBuilder<SignalBloc, SignalState>(
        // Set Build Requirements
        buildWhen: (prev, curr) {
          if (curr is SocketLoadInProgress) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          // -- Searching State--
          if (state is Searching) {
            return SafeArea(
              child: Stack(
                children: <Widget>[
                  // Bubble View
                  //buildStackView(state.userNode.getZonedPeers()),

                  // Have BLoC Builder Retrieve Directly from
                  // Cubit to Avoid Delays
                  BlocBuilder<DirectionCubit, double>(
                    cubit: context.getCubit(CubitType.Direction),
                    builder: (context, state) {
                      return Align(
                          alignment: Alignment.bottomCenter,
                          child: CompassView(direction: state));
                    },
                  )
                  // Compass View
                ],
              ),
            );
          }

          // -- Transferring State--
          else if (state is Transferring) {
            return ProgressView(web: BlocProvider.of<SignalBloc>(context));
          }
          return Container();
        },
      ),
    );
  }
}
