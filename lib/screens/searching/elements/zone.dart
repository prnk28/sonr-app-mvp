part of '../searching.dart';

// *************************** //
// ** Build Bubbles in List ** //
// *************************** //
class ZoneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LobbyCubit, Lobby>(
        cubit: context.getCubit(CubitType.Lobby),
        builder: (context, state) {
          print(state.toString());
          if (state.peers.length > 0) {
            // Initialize Widget List
            List<Widget> stackWidgets = new List<Widget>();

            // Init Stack Vars
            int total = state.peers.length + 1;
            int current = 0;
            double mean = 1.0 / total;

            // Create Bubbles
            state.peers.values.forEach((peer) {
              // Increase Count
              current += 1;

              // Place Bubble
              Widget bubble = new PeerBubble(current * mean, peer);
              stackWidgets.add(bubble);
            });

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
