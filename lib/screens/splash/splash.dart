import 'package:sonar_app/screens/screens.dart';
export 'views/views.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Return
    return NeumorphicTheme(
      theme: Design.lightTheme,
      darkTheme: Design.darkTheme,
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        // Non Build States
        body: BlocBuilder<AccountBloc, AccountState>(buildWhen: (prev, curr) {
          // Home Screen
          if (curr is Online) {
            Navigator.pushReplacementNamed(context, "/home",
                arguments: HomeArguments(curr.profile));
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
          BlocProvider.of<AccountBloc>(context).add(CheckStatus());

          // Return Loading
          return Center(child: NeumorphicProgressIndeterminate());
        }),
      ),
    );
  }
}
