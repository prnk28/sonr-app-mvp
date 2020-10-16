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
    return SafeArea(
      child: Stack(
        children: <Widget>[
          // Bubble View
          BubbleView(widget.pathfinder),

          // Have BLoC Builder Retrieve Directly from
          // Cubit to Avoid Delays
          BlocBuilder<DirectionCubit, double>(
            cubit: getCubit(CubitType.Direction, context),
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
