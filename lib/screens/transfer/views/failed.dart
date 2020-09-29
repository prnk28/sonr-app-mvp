import 'package:sonar_app/screens/screens.dart';

class FailedView extends StatelessWidget {
  final WebBloc sonarBloc;
  final state;

  const FailedView({Key key, this.sonarBloc, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set Display Timer
    sonarBloc.add(Reset());

    // Yield Decline Result
    return Text(
        state.profile["profile"]["first_name"].toString() + " has Declined.",
        style: Design.text.header());
  }
}
