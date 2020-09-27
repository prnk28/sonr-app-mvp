import 'package:sonar_app/screens/screens.dart';
export 'views/views.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Design.logoAppBar,
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: BlocBuilder<AccountBloc, AccountState>(buildWhen: (prev, curr) {
        if (curr is Online) {
          // Push to Home with Profile
          Navigator.pushReplacementNamed(context, "/home",
              arguments: HomeArguments(curr.profile));
          return false;
        }
        // Register Screen
        else if (curr is Offline) {
          return true;
          // Default
        } else {
          return false;
        }
      }, builder: (context, state) {
        // Display Login/Signup View
        if (state is Offline) {
          return Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: InitializeView())
          ]);
        }
        // On Error
        else {
          // Log
          log.e("User shouldnt be stuck at register page");

          // Dummy Widget
          return Center(child: NeumorphicProgressIndeterminate());
        }
      }),
    );
  }
}
