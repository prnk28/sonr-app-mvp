import 'package:sonar_app/screens/screens.dart';
export 'views/views.dart';

class TransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransferArguments args = ModalRoute.of(context).settings.arguments;
    BlocProvider.of<WebBloc>(context).add(Connect());

    return Scaffold(
      appBar: Design.screenAppBar("Transfer"),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: BlocBuilder<WebBloc, WebState>(
              builder: (context, state) {
                // Initialize Client
                return NeumorphicProgressIndeterminate();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ** Arguments to Pass Data to TransferScreen **
class TransferArguments {
  final Profile currentProfile;
  TransferArguments(this.currentProfile);
}
