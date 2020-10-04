import 'package:sonar_app/screens/screens.dart';

// Views in Screen
part 'complete.dart';
part 'confirm.dart';
part 'progress.dart';
part 'receiving.dart';
part 'sending.dart';
part 'waiting.dart';

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
                // -- Searching State--
                if (state is Searching) {
                  // Check if Receiver
                  if (state.isReceiver) {
                  } else {}
                }
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
