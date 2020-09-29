import 'package:sonar_app/screens/screens.dart';
export 'views/views.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Extract Arguments
    final HomeArguments args = ModalRoute.of(context).settings.arguments;

    // Initialize Device Sensors
    BlocProvider.of<DeviceBloc>(context).add(Initialize());

    // Build View
    return Scaffold(
        appBar: Design.screenAppBar("Home"),
        body: Column(
          children: [
            // Bloc Builder to View Device info
            BlocBuilder<DeviceBloc, DeviceState>(
              builder: (context, state) {
                if (state is Ready) {
                  return Text("DeviceBloc State: Ready");
                } else if (state is Sending) {
                  return Text("DeviceBloc State: Sending");
                } else if (state is Receiving) {
                  return Text("DeviceBloc State: Receiving");
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
                      // Change View
                      Navigator.pushNamed(context, "/transfer",
                          arguments: TransferArguments(args.currentProfile));
                    })),
          ],
        ));
  }
}

// ** Arguments to Pass Data to HomeScreen **
class HomeArguments {
  final Profile currentProfile;
  HomeArguments(this.currentProfile);
}
