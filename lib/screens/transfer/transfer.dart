import 'package:sonar_app/screens/screens.dart';
import 'widgets/compass.dart';

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
      appBar: Design.leadingAppBar("/home", context, Icons.close,
          shouldPopScreen: true),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: BlocBuilder<WebBloc, WebState>(
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
    );
  }
}
