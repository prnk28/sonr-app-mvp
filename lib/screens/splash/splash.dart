import 'package:sonar_app/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set Screen Size
    context.setScreenSize();

    // Initialize Device
    context.getBloc(BlocType.Device).add(LocationPermissionCheck());

    // Return
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        // Non Build States
        body: _SplashView());
  }
}

class _SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // We use the BlocListener widget in order to DO THINGS in response to state changes in our DataBloc.
    return BlocListener<UserBloc, UserState>(
        listener: (past, curr) {
          // Home Screen
          if (curr is ProfileLoadSuccess) {
            context.goHome(initial: true);
          }
          // Register Screen
          else if (curr is ProfileLoadFailure) {
            context.goRegister();
          }
        },
        child: Center(child: NeumorphicProgressIndeterminate()));
  }
}
