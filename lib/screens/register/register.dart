import 'package:sonar_app/screens/screens.dart';
export 'views/views.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: NeumorphicText("Sonr",
            style: NeumorphicStyle(
              depth: 4, //customize depth here
              color: Colors.white, //customize color here
            ),
            textStyle: Design.text.logo(),
            textAlign: TextAlign.center),
      ),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: BlocBuilder<DataBloc, DataState>(buildWhen: (prev, curr) {
              if (curr is Standby) {
                Navigator.pushReplacementNamed(context, "/home");
                return false;
              }
              // Register Screen
              else if (curr is Unavailable) {
                return true;
                // Default
              } else {
                return false;
              }
            }, builder: (context, state) {
              // Display Login/Signup View
              if (state is Unavailable) {
                return InitializeView();
              }
              // On Error
              else {
                // Log
                log.e("User shouldnt be stuck at register page");

                // Dummy Widget
                return Center(child: NeumorphicProgressIndeterminate());
              }
            }),
          ),
        ],
      ),
    );
  }
}
