import 'package:http/http.dart';
import 'package:sonar_app/screens/screens.dart';

part 'requested.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Build View
    return NeumorphicTheme(
        theme: lightTheme(),
        darkTheme: darkTheme(),
        child: Scaffold(
          backgroundColor: NeumorphicTheme.baseColor(context),
          appBar: screenAppBar("Home"),
          floatingActionButton: NeumorphicFloatingActionButton(
              child: Icon(Icons.star, size: 30),
              onPressed: () {
                context.pushTransfer();
              }),
          body: BlocBuilder<WebBloc, WebState>(
            buildWhen: (past, curr) {
              if (curr is Requested) {
                context.pushRequested(curr.metadata, curr.match, curr.offer);
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
              } else {
                return Text("WebBloc " + (state).toString());
              }
            },
          ),
        ));
  }
}
