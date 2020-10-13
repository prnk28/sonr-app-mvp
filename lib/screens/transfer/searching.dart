part of 'transfer.dart';

class SearchingView extends StatefulWidget {
  final PathFinder pathfinder;
  final UserBloc user;

  SearchingView({this.pathfinder, this.user});

  @override
  _SearchingViewState createState() => _SearchingViewState();
}

class _SearchingViewState extends State<SearchingView> {
  @override
  Widget build(BuildContext context) {
    //if (!pathfinder.isEmpty) {
    // Get Closest Peer
    //Peer closest = pathfinder.getClosestNeighbor();

    return SafeArea(
      child: Stack(
        children: <Widget>[
          // Bubble View
          Align(
            alignment: Alignment.topCenter,
            child: BubbleView(),
          ),

          BlocBuilder<DirectionCubit, double>(
            cubit: BlocProvider.of<DeviceBloc>(context).directionCubit,
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
}
