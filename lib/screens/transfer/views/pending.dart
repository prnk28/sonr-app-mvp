import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/screens/screens.dart';

class PendingView extends StatelessWidget {
  final Pending state;
  final WebBloc sonarBloc;

  const PendingView({Key key, this.state, this.sonarBloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (sonarBloc.device.status == PositionStatus.SENDER) {
      return Text(
          "Pending Authorization from " +
              state.match["profile"]["first_name"].toString(),
          style: Design.text.header());
    } else if (sonarBloc.device.status == PositionStatus.RECEIVER) {
      Vibration.vibrate();
      print("Pending approval");
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Return Text Widget
            Text(
                "Request from " +
                    state.match["profile"]["first_name"].toString(),
                style: Design.text.header()),
            Divider(),
            FloatingActionButton(
                child: Icon(Icons.check),
                onPressed: () {
                  BlocProvider.of<WebBloc>(context)
                      .add(SendAuthorization(true, state.match["id"], state.offer));
                }),
            FloatingActionButton(
                child: Icon(Icons.close),
                onPressed: () {
                  BlocProvider.of<WebBloc>(context)
                      .add(SendAuthorization(false, state.match["id"], state.offer));
                }),
          ]);
    } else {
      return Container();
    }
  }
}
