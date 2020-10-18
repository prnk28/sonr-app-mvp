import 'package:sonar_app/screens/screens.dart';

part 'requested.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Build View
    return Scaffold(
      appBar: screenAppBar("Home"),
      floatingActionButton: NeumorphicButton(
          style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.circle(),
              shape: NeumorphicShape.convex,
              depth: 5),
          child: Icon(Icons.star_outline_rounded),
          onPressed: () {
            context.pushTransfer();
          }),
      body: BlocBuilder<WebBloc, WebState>(
        builder: (context, state) {
          if (state is Requested) {
            return RequestedView();
          } else if (state is Available) {
            return Column(children: [
              Text("OLC " + state.userNode.olc),
              Text("ID " + state.userNode.id)
            ]);
          } else {
            return Text("WebBloc " + (state).toString());
          }
        },
      ),
    );
  }
}
