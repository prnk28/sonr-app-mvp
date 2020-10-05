part of 'transfer.dart';

class SendingView extends StatelessWidget {
  final PathFinder pathfinder;
  final UserBloc user;
  SendingView(this.pathfinder, this.user);

  @override
  Widget build(BuildContext context) {
    log.i("Closest Neighbor" +
        pathfinder.getClosestNeighbor().toMap().toString());
    if (pathfinder.getClosestNeighbor() != null) {
      return Column(
        children: [
          Text(pathfinder.getClosestNeighbor().profile.firstName),
          //Text(closest.profile.lastName),
          //Container();
        ],
      );
    }
    return Text(user.node.direction.toString());
  }
}
