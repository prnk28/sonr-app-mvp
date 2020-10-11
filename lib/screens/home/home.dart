import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Build View
    return Scaffold(
        appBar: Design.screenAppBar("Home"),
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
            Center(
                child: NeumorphicButton(
                    margin: EdgeInsets.only(top: 12),
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.stadium()),
                    child: Icon(Icons.star_outline_rounded),
                    onPressed: () {
                      // Change View as Modal
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransferScreen(),
                            fullscreenDialog: true),
                      );
                    })),
          ],
        ));
  }
}
