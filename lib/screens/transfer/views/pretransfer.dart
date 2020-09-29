import 'package:sonar_app/screens/screens.dart';

class PreTransferView extends StatelessWidget {
  final state;

  const PreTransferView({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Vibration.vibrate();
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(state.profile["profile"]["first_name"].toString() + " has Accepted.",
          style: Design.text.header()),
      Divider(),
      FloatingActionButton(
          child: Icon(Icons.image),
          onPressed: () {
            BlocProvider.of<WebBloc>(context).add(BeginTransfer());
          }),
      FloatingActionButton(
          child: Icon(Icons.surround_sound),
          onPressed: () {
            BlocProvider.of<WebBloc>(context).add(BeginTransfer());
          }),
    ]);
  }
}
