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
    // Get Screen Size
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Size screenSize = Size(width, height);

    return SafeArea(
      child: Stack(
        children: <Widget>[
          // Bubble View
          BubbleView(widget.pathfinder, screenSize),

          // Have BLoC Builder Retrieve Directly from
          // Cubit to Avoid Delays
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
