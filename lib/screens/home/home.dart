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
              context.pushTransfer();
            }),
        body: _HomeView());
  }
}

class _HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WebBloc, WebState>(
      listenWhen: (previousState, state) {
        if (state is Requested) {
          return true;
        }
        return false;
      },
      listener: (past, curr) {
        if (curr is Requested) {
          // Display Bottom Sheet
          Scaffold.of(context).showBottomSheet<void>((BuildContext context) {
            return Window.showAuth(context, curr);
          });
        }
      },
      buildWhen: (previous, current) {
        if (current is Loading) {
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
