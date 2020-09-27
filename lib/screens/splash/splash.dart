import 'package:sonar_app/screens/screens.dart';
export 'views/views.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    // Return
    return NeumorphicTheme(
      theme: Design.lightTheme,
      darkTheme: Design.darkTheme,
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        // Launch Second Screen
        body: BlocBuilder<DataBloc, DataState>(buildWhen: (previous, current) {
          // Home Screen
          if (current is Standby) {
            Navigator.pushReplacementNamed(context, "/home");
            return false;
          }
          // Register Screen
          else if (current is Unavailable) {
            Navigator.pushReplacementNamed(context, "/register");
            return false;
            // Default
          } else {
            return true;
          }
        }, builder: (context, state) {
          // Begin Local Status Check
          BlocProvider.of<DataBloc>(context).add(CheckLocalStatus());

          // Return Loading
          return Center(child: NeumorphicProgressIndeterminate());
        }),
      ),
    );
  }
}
