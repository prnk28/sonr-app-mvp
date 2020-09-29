import 'package:sonar_app/screens/screens.dart';
export 'views/views.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize Device Sensors
    //BlocProvider.of<DeviceBloc>(context).add(Initialize());

    // Extract Arguments
    final HomeArguments args = ModalRoute.of(context).settings.arguments;

    // Build View
    return Scaffold(
        appBar: Design.screenAppBar("Home"),
        body: Column(
          children: [
            // Bloc Builder to View Device info
            BlocBuilder<DeviceBloc, DeviceState>(
              builder: (context, state) {
                if (state is Inactive) {
                } else if (state is Ready) {
                } else if (state is Sending) {
                } else if (state is Receiving) {
                } else if (state is Sending) {}
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
