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
    BlocProvider.of<WebBloc>(context).add(Connect());

    return Scaffold(
      appBar: Design.screenAppBar("Transfer"),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: BlocBuilder<WebBloc, WebState>(
              // Set Build Requirements
              buildWhen: (prev, curr) {
                if (curr is Loading) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                // -- Searching State--
                if (state is Searching) {
                  // Check if Receiver
                  if (BlocProvider.of<UserBloc>(context).node.status ==
                      PeerStatus.Receiving) {
                    return ReceivingView(
                        pathfinder: state.pathfinder,
                        user: BlocProvider.of<UserBloc>(context));
                  }
                  // Check if Sender
                  else if (BlocProvider.of<UserBloc>(context).node.status ==
                      PeerStatus.Sending) {
                    return SendingView(
                        pathfinder: state.pathfinder,
                        user: BlocProvider.of<UserBloc>(context));
                  }
                  // Log Error
                  log.e("Invalid PeerStatus in Searching State");
                  return Container();
                }

                // -- Pending State--
                else if (state is Pending) {
                  // Check if Receiver
                  if (BlocProvider.of<UserBloc>(context).node.status ==
                      PeerStatus.Receiving) {
                    return ConfirmView();
                  }
                  // Check if Sender
                  else if (BlocProvider.of<UserBloc>(context).node.status ==
                      PeerStatus.Sending) {
                    return WaitingView();
                  }
                }

                // -- Transferring State--
                else if (state is Transferring) {
                  return ProgressView(web: BlocProvider.of<WebBloc>(context));
                }

                // -- Completed State--
                else if (state is Completed) {
                  return CompleteView();
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
