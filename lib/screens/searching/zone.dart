part of 'searching.dart';

// *************************** //
// ** Build Bubbles in List ** //
// *************************** //
class ZoneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(buildWhen: (past, curr) {
      if (curr is NodeSearchSuccess) {
        return true;
      } else {
        return false;
      }
    }, builder: (context, state) {
      if (state is NodeSearchSuccess) {
        // Initialize Widget List
        List<Widget> stackWidgets = new List<Widget>();

        // Init Stack Vars
        int total = state.activePeers.length + 1;
        int current = 0;
        double mean = 1.0 / total;

        // Create Bubbles
        for (Node peer in state.activePeers) {
          // Increase Count
          current += 1;

          // Place Bubble
          Widget bubble = new Bubble(current * mean, peer);
          stackWidgets.add(bubble);
        }
        // Return View
        return Stack(children: stackWidgets);
      }
      return Container();
    });
  }
}

Widget rangeLines() {
  return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: CustomPaint(
        size: screenSize,
        painter: ZonePainter(),
        child: Container(),
      ));
}
