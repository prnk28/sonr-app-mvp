part of 'transfer.dart';

class SendingView extends StatelessWidget {
  final PathFinder pathfinder;
  final UserBloc user;
  SendingView(this.pathfinder, this.user);

  @override
  Widget build(BuildContext context) {
    if (pathfinder.closestNeighbor != null) {
      return Column(
        children: [
          Text(pathfinder.closestNeighbor.profile.firstName),
          //Text(closest.profile.lastName),
          //Container();
        ],
      );
    }
    return Text(user.node.direction.toString());
  }
}
