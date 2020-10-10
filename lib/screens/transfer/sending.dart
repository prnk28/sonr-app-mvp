part of 'transfer.dart';

class SendingView extends StatelessWidget {
  final PathFinder pathfinder;
  final UserBloc user;
  SendingView({this.pathfinder, this.user});

  @override
  Widget build(BuildContext context) {
    //if (!pathfinder.isEmpty) {
    // Get Closest Peer
    //Peer closest = pathfinder.getClosestNeighbor();

    // Build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [CompassView()],
    );
  }
}
