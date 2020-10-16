part of 'transfer.dart';

class CompleteView extends StatelessWidget {
  final dynamic sonarBloc;

  const CompleteView({Key key, this.sonarBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sonarBloc.state.deviceStatus == "SENDER") {
      return Column(children: [
        Text("Complete.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            )),
        FloatingActionButton(
            child: Icon(Icons.done_all),
            onPressed: () {
              sonarBloc.add(Complete());
            }),
      ]);
    } else {
      File file = sonarBloc.state.file;

      return Column(children: [
        Text("Complete.", style: headerTextStyle()),
        Image.file(file),
        FloatingActionButton(
            child: Icon(Icons.done_all),
            onPressed: () {
              sonarBloc.add(Complete());
            }),
      ]);
    }
  }
}
