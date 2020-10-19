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
                //context.pushTransfer();
              }),
          body: BlocBuilder<WebBloc, WebState>(
            buildWhen: (past, curr) {
              if (curr is Requested) {
                context.pushRequested(curr.metadata, curr.match);
                return false;
              }
              return true;
            },
            builder: (context, state) {
              if (state is Available) {
                return Column(children: [
                  Text("OLC " + state.userNode.olc),
                  Text("ID " + state.userNode.id),
                  NeumorphicButton(
                    onPressed: () {
                      context.pushRequested(null, null);
                    },
                    style: NeumorphicStyle(
                        depth: 8,
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(8))),
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.desktop_windows),
                  ),
                ]);
              } else {
                return Text("WebBloc " + (state).toString());
              }
            },
          ),
        ));
  }
}
