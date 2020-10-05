part of 'transfer.dart';

class ReceivingView extends StatelessWidget {
  final PathFinder pathfinder;
  const ReceivingView(this.pathfinder);

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
    return Container();
  }
}
