import 'dart:ui';

import 'package:sonar_app/screens/screens.dart';
import 'dart:math' as math;
// Views in Screen
part 'bubble.dart';
part 'compass.dart';
part 'complete.dart';
part 'progress.dart';

class TransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Queue File
    context.emitDataBlocEvent(DataEventType.QueueOutgoingFile);

    // Search
    context.getBloc(BlocType.Web).Update(Status.Searching);

    // Return Widget
    return NeumorphicTheme(
        theme: lightTheme(),
        darkTheme: darkTheme(),
        child: Scaffold(
          appBar: leadingAppBar("/home", context, Icons.close,
              shouldPopScreen: true, shouldRevertToActive: true),
          backgroundColor: NeumorphicTheme.baseColor(context),
          body: BlocBuilder<WebBloc, WebState>(
            // Set Build Requirements
            buildWhen: (prev, curr) {
              if (curr is Loading) {
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
                      buildStackView(state.userNode.getZonedPeers()),

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
                return ProgressView(web: BlocProvider.of<WebBloc>(context));
              }

              // -- Completed State--
              else if (state is Completed) {
                return CompleteView();
              }
              return Container();
            },
          ),
        ));
  }
}
