part of 'transfer.dart';

class ReceivingView extends StatelessWidget {
  final PathFinder pathfinder;
  final UserBloc user;
  const ReceivingView(this.pathfinder, this.user);

  @override
  Widget build(BuildContext context) {
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
