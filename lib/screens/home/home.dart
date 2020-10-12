import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            BlocBuilder<DeviceBloc, DeviceState>(
              builder: (context, state) {
                if (state is Ready) {
                  return Text("Ready: " +
                      BlocProvider.of<UserBloc>(context).node.id.toString());
                } else if (state is Sending) {
                  return Text("Sending: " +
                      BlocProvider.of<UserBloc>(context).node.id.toString());
                } else if (state is Receiving) {
                  return Text("Receiving: " +
                      BlocProvider.of<UserBloc>(context).node.id.toString());
                } else if (state is Busy) {
                  return Text("DeviceBloc State: Busy");
                } else if (state is Refreshing) {
                  return Text("DeviceBloc State: Refreshing");
                }
                return Text("DeviceBloc State: Inactive");
              },
            ),
            // Button to Go to Transfer
          ],
        ));
  }
}
