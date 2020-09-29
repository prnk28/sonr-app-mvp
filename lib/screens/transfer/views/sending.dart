import 'package:sonar_app/screens/screens.dart';

class SendingView extends StatelessWidget {
  final SendingPosition state;
  final WebBloc sonarBloc;

  SendingView(this.state, this.sonarBloc);
  @override
  Widget build(BuildContext context) {
    // Closeset Within Threshold
    if (state.matches.valid()) {
      // Begin Timer 2s
      // const twentySeconds = const Duration(seconds: 2);
      // new Timer(
      //     twentySeconds,
      //     () =>
      sonarBloc.add(Invite(state.matches.closestProfile()["id"]));

      // Return Text Widget
      return Text(
        state.currentMotion.state.toString() +
            " , " +
            state.currentDirection.degrees.toString() +
            ", Match/Client Difference: " +
            state.matches.closestProfile()["difference"].toString(),
        style: Design.text.medium(),
      );
    } else {
      // Return Text Widget
      return Text(
          state.currentMotion.state.toString() +
              " No Receivers, " +
              state.currentDirection.degrees.toString(),
          style: Design.text.header());
    }
  }
}
