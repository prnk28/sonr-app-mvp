import 'package:sonar_app/screens/screens.dart';

part 'auth.dart';
part 'download.dart';

class Sheet {
  static Widget showAuth(BuildContext context, Requested state) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: MediaQuery.of(context).size.height / 3,
        child: buildAuthenticationView(context, state));
  }

  static Widget showTransferring(BuildContext context) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: MediaQuery.of(context).size.height / 3,
        child: buildProgressView(context));
  }

  static Widget showComplete(BuildContext context, Completed state) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: MediaQuery.of(context).size.height / 3,
        child: buildCompleteView(context, state));
  }
}

class Window extends StatelessWidget {
  final Widget view;

  const Window({Key key, this.view}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
            depth: 8,
            lightSource: LightSource.topLeft,
            color: Colors.blueGrey[50]),
        child: Container(
            color: NeumorphicTheme.baseColor(context),
            height: MediaQuery.of(context).size.height / 3,
            child: view));
  }
}
