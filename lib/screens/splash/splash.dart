import 'package:sonar_app/screens/screens.dart';
export 'views/views.dart';

class SplashScreen extends StatelessWidget {
  final AccountBloc accountBloc;
  final DataBloc dataBloc;

  const SplashScreen({Key key, this.accountBloc, this.dataBloc})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: Design.lightTheme,
      darkTheme: Design.darkTheme,
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        // Launch Second Screen
        body: Center(
          child: NeumorphicButton(
            margin: EdgeInsets.only(top: 12),
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/register");
            },
            child: Text('Launch Home',
                style: TextStyle(color: Design.findTextColor(context))),
          ),
        ),
      ),
    );
  }
}
