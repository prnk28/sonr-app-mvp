part of 'transfer.dart';

class SendingView extends StatelessWidget {
  final PathFinder pathfinder;
  final UserBloc user;
  SendingView({this.pathfinder, this.user});

  @override
  Widget build(BuildContext context) {
    if (!pathfinder.isEmpty) {
      // Get Closest Peer
      Peer closest = pathfinder.getClosestNeighbor();

      // Build
      return Column(
        children: [
          Text(closest.profile.firstName),
          //Container();
        ],
      );
    }
    return Text(user.node.direction.toString());
  }
}
