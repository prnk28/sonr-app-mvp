import 'package:sonar_app/repository/repository.dart';
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
                    return ReceivingView(
                        state.pathfinder, BlocProvider.of<UserBloc>(context));
                  } else {
                    return SendingView(
                        state.pathfinder, BlocProvider.of<UserBloc>(context));
                  }
                }

                // -- Pending State--
                else if (state is Pending) {
                  // Check if Receiver
                  if (state.isReceiver) {
                    return ConfirmView();
                  } else {
                    return WaitingView();
                  }
                }

                // -- Transferring State--
                else if (state is Transferring) {
                  return ProgressView();
                }

                // -- Completed State--
                else if (state is Completed) {
                  return CompleteView();
                }

                return Text(BlocProvider.of<UserBloc>(context)
                    .node
                    .direction
                    .toString());
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
