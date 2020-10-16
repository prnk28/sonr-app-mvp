import 'package:sonar_app/screens/screens.dart';

part 'requested.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Update Node
    context.emitUserBlocEvent(UserEventType.SetStatus,
        newStatus: Status.Active);

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
        body: Column(
          children: [
            // Bloc Builder to View Device info
            BlocBuilder<WebBloc, WebState>(
              builder: (context, state) {
                if (state is Requested) {
                  return RequestedView();
                } else {
                  return Text("WebBloc " + (state).toString());
                }
              },
            ),
            // Button to Go to Transfer
          ],
        ));
  }
}
