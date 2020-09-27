import 'package:sonar_app/screens/screens.dart';
export 'views/views.dart';

class SplashScreen extends StatelessWidget {
  final AccountBloc accountBloc;
  final DataBloc dataBloc;

  const SplashScreen({Key key, this.accountBloc, this.dataBloc})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Begin Local Status Check
    dataBloc.add(CheckLocalStatus());

    return NeumorphicTheme(
      theme: Design.lightTheme,
      darkTheme: Design.darkTheme,
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        // Launch Second Screen
        body: Center(
            child: BlocBuilder<DataBloc, DataState>(builder: (context, state) {
          if (state is Standby) {
            Navigator.pushNamed(context, '/home');
          } else if (state is Unavailable) {
            Navigator.pushNamed(context, '/register');
          } else {
            return NeumorphicProgressIndeterminate();
          }
        })),
      ),
    );
  }
}
