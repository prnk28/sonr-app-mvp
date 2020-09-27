import 'package:sonar_app/screens/screens.dart';
export 'views/views.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Extract Arguments
    final HomeArguments args = ModalRoute.of(context).settings.arguments;

    // Build View
    return Scaffold(
      appBar: Design.screenAppBar("Home"),
      body: Center(
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
    );
  }
}

// ** Arguments to Pass Data to HomeScreen **
class HomeArguments {
  final Profile currentProfile;
  HomeArguments(this.currentProfile);
}
