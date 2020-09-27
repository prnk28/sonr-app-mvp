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
            child: BlocBuilder<SonarBloc, SonarState>(
              builder: (context, state) {
                return InitializeView();
              },
            ),
          ),
        ],
      ),
    );
  }
}
