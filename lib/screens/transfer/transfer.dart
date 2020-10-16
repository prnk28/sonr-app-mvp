import 'package:sonar_app/screens/screens.dart';
import 'widgets/compass.dart';
import 'widgets/bubble.dart';

// Views in Screen
part 'complete.dart';
part 'confirm.dart';
part 'progress.dart';
part 'searching.dart';
part 'waiting.dart';

class TransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fake Select File in Queue
    BlocProvider.of<DataBloc>(context).add(QueueFile());

    // Search
    BlocProvider.of<WebBloc>(context).add(Search());

    // Return Widget
    return Scaffold(
      appBar: leadingAppBar("/home", context, Icons.close,
          shouldPopScreen: true, shouldRevertToActive: true),
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
            return SearchingView(
                activePeers: state.activePeers,
                user: BlocProvider.of<UserBloc>(context));
          }

          // -- Pending State--
          else if (state is Pending) {
            // Check if Receiver
            if (BlocProvider.of<UserBloc>(context).node.status ==
                PeerStatus.Searching) {
              return ConfirmView();
            }
            // Check if Sender
            else if (BlocProvider.of<UserBloc>(context).node.status ==
                PeerStatus.Active) {
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
