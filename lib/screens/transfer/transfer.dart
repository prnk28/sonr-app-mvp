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
            child: BlocBuilder<SonarBloc, SonarState>(
              builder: (context, state) {
                if (state is Sending) {
                  return SendingView(
                      state, BlocProvider.of<SonarBloc>(context));
                } else if (state is Receiving) {
                  return ReceivingView(state: state);
                } else if (state is Pending) {
                  return PendingView(
                      state: state,
                      sonarBloc: BlocProvider.of<SonarBloc>(context));
                } else if (state is PreTransfer) {
                  return PreTransferView(state: state);
                } else if (state is Failed) {
                  return FailedView(
                      sonarBloc: BlocProvider.of<SonarBloc>(context),
                      state: state);
                } else if (state is InProgress) {
                  return TransferView(
                      sonarBloc: BlocProvider.of<SonarBloc>(context),
                      state: state);
                } else if (state is Complete) {
                  return CompleteView(
                      sonarBloc: BlocProvider.of<SonarBloc>(context));
                } else {
                  // Initialize Client
                  BlocProvider.of<SonarBloc>(context)
                      .add(Initialize(userProfile: args.currentProfile));
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
