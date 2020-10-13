import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Update Node
    BlocProvider.of<WebBloc>(context).add(Update(UpdateType.NODE));

    // Update Node
    BlocProvider.of<WebBloc>(context).add(Update(UpdateType.NODE));

    // Build View
    return Scaffold(
        appBar: Design.screenAppBar("Home"),
        floatingActionButton: NeumorphicButton(
            style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.circle(),
                shape: NeumorphicShape.convex,
                depth: 5),
            child: Icon(Icons.star_outline_rounded),
            onPressed: () {
              // Change View as Modal
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransferScreen(),
                    fullscreenDialog: true),
              );
            }),
        body: Column(
          children: [
            // Bloc Builder to View Device info
            BlocBuilder<WebBloc, WebState>(
              builder: (context, state) {
                return Text("WebBloc " + (state).toString());
              },
            ),
            // Button to Go to Transfer
          ],
        ));
  }
}
