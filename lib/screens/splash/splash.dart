import 'package:sonar_app/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set Screen Size
    setScreenSize(context);

    // Return
    return NeumorphicTheme(
      theme: Design.lightTheme,
      darkTheme: Design.darkTheme,
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        // Non Build States
        body: BlocBuilder<UserBloc, UserState>(buildWhen: (prev, curr) {
          // Home Screen
          if (curr is Online) {
            BlocProvider.of<WebBloc>(context).add(Connect());
            Navigator.pushReplacementNamed(context, "/home");
            return false;
          }
          // Register Screen
          else if (curr is Offline) {
            Navigator.pushReplacementNamed(context, "/register");
            return false;
          }
          // Default
          return true;
        }, builder: (context, state) {
          // Begin Local Status Check
          BlocProvider.of<UserBloc>(context).add(Initialize());

          // Return Loading
          return Center(child: NeumorphicProgressIndeterminate());
        }),
      ),
    );
  }
}
