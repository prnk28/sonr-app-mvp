import 'package:http/http.dart';
import 'package:sonar_app/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Build View
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: screenAppBar("Home"),
        floatingActionButton: NeumorphicFloatingActionButton(
            child: Icon(Icons.star, size: 30),
            onPressed: () {
              // Queue File
              context.getBloc(BlocType.Data).traffic.addOutgoing();

              // Push to Transfer Screen
              Navigator.pushReplacementNamed(context, "/transfer");
            }),
        body: _HomeView());
  }
}

class _HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignalBloc, SignalState>(
      listenWhen: (previousState, state) {
        if (state is SocketInitial) {
          return false;
        }
        return true;
      },
      listener: (past, curr) {
        if (curr is Requested) {
          // Display Bottom Sheet
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Sheet.showAuth(context, curr);
              });
        } else if (curr is Transferring) {
          // Display Bottom Sheet
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Sheet.showTransferring(context);
              });
        } else if (curr is Completed) {
          // Display Bottom Sheet
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Sheet.showComplete(context, curr);
              });
        }
      },
      buildWhen: (previous, current) {
        if (current is SocketInitial) {
          return false;
        } else if (current is Requested) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state is Available) {
          return Column(children: [
            Text("OLC " + state.userNode.olc),
            Text("ID " + state.userNode.id),
          ]);
        }
        return Center(child: Text("WebBloc State: " + (state).toString()));
      },
    );
  }
}
