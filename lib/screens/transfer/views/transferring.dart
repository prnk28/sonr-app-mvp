import 'package:sonar_app/screens/screens.dart';

class TransferView extends StatelessWidget {
  final SonarBloc sonarBloc;
  final Transferring state;

  const TransferView({Key key, this.sonarBloc, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Yield Decline Result
    return Column(
      children: [
        NeumorphicProgressIndeterminate(),
        Divider(),
        // Text(
        //   "Receive Progress: " + (state.progress * 100).toString() + "%",
        //   style: Design.getTextStyle(TextDesign.DescriptionText),
        // )
      ],
    );
  }
}
