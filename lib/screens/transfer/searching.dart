part of 'transfer.dart';

class SearchingView extends StatefulWidget {
  final List<Peer> activePeers;
  final UserBloc user;

  SearchingView({this.activePeers, this.user});

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
          BubbleView(widget.activePeers),

          // Have BLoC Builder Retrieve Directly from
          // Cubit to Avoid Delays
          BlocBuilder<DirectionCubit, double>(
            cubit: context.getCubit(CubitType.Direction),
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
