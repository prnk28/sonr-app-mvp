import 'package:sonar_app/screens/screens.dart';
export 'views/views.dart';

class TransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: NeumorphicText("Sonr",
            style: NeumorphicStyle(
              depth: 4, //customize depth here
              color: Colors.white, //customize color here
            ),
            textStyle: Design.text.logo(),
            textAlign: TextAlign.center),
      ),
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
                } else if (state is Transferring) {
                  return TransferView(
                      sonarBloc: BlocProvider.of<SonarBloc>(context),
                      state: state);
                } else if (state is Complete) {
                  return CompleteView(
                      sonarBloc: BlocProvider.of<SonarBloc>(context));
                } else {
                  return InitializeView(
                      sonarBloc: BlocProvider.of<SonarBloc>(context));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
