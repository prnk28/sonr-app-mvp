import 'package:sonar_app/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set Screen Size
    context.setScreenSize();

    // Return
    return NeumorphicTheme(
      theme: lightTheme(),
      darkTheme: darkTheme(),
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        // Non Build States
        body: BlocBuilder<UserBloc, UserState>(buildWhen: (prev, curr) {
          // Home Screen
          if (curr is Online) {
            context.goHome(initial: true);
            return false;
          }
          // Register Screen
          else if (curr is Offline) {
            context.goRegister();
            return false;
          }
          // Default
          return true;
        }, builder: (context, state) {
          // Get PlaceId
          context.emitDeviceBlocEvent(DeviceEventType.GetLocation);

          // Begin Local Status Check
          context.emitUserBlocEvent(UserEventType.Initialize);

          // Return Loading
          return Center(child: NeumorphicProgressIndeterminate());
        }),
      ),
    );
  }
}
