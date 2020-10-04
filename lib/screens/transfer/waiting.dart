part of 'transfer.dart';

class WaitingView extends StatelessWidget {
  final WebBloc sonarBloc;
  final Transferring state;

  const WaitingView({Key key, this.sonarBloc, this.state}) : super(key: key);

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
