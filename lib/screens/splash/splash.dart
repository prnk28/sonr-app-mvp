import 'package:sonar_app/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set Screen Size
    context.setScreenSize();

    // Get References
    var dataBloc = context.getBloc(BlocType.Data);
    var signalBloc = context.getBloc(BlocType.Signal);

    // Check Permissions
    context
        .getBloc(BlocType.Device)
        .add(LocationPermissionCheck(dataBloc, signalBloc));

    // Return
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        // Non Build States
        body: BlocListener<UserBloc, UserState>(
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
            child: Center(child: NeumorphicProgressIndeterminate())));
  }
}
