import 'package:sonar_app/screens/screens.dart';
export 'views/views.dart';

class TransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransferArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: Design.screenAppBar("Transfer"),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: BlocBuilder<WebBloc, WebState>(
              builder: (context, state) {
                if (state is Sending) {
                  return SendingView(
                      state, BlocProvider.of<WebBloc>(context));
                } else if (state is Receiving) {
                  return ReceivingView(state: state);
                } else if (state is Pending) {
                  return PendingView(
                      state: state,
                      sonarBloc: BlocProvider.of<WebBloc>(context));
                } else if (state is PreTransfer) {
                  return PreTransferView(state: state);
                } else if (state is Failed) {
                  return FailedView(
                      sonarBloc: BlocProvider.of<WebBloc>(context),
                      state: state);
                } else if (state is InProgress) {
                  return TransferView(
                      sonarBloc: BlocProvider.of<WebBloc>(context),
                      state: state);
                } else if (state is Complete) {
                  return CompleteView(
                      sonarBloc: BlocProvider.of<WebBloc>(context));
                } else {
                  // Initialize Client
                  BlocProvider.of<WebBloc>(context)
                      .add(Connect(userProfile: args.currentProfile));
                  return NeumorphicProgressIndeterminate();
                }
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
