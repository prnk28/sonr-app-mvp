import 'package:sonar_app/screens/screens.dart';

final _formKey = GlobalKey<FormState>();

class InitializeView extends StatefulWidget {
  InitializeView({Key key}) : super(key: key);

  @override
  _InitializeViewState createState() => _InitializeViewState();
}

class _InitializeViewState extends State<InitializeView> {
  String _firstName;
  String _lastName;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ****************** //
          // ** <First Name> ** //
          // ****************** //
          // Label
          Padding(
            padding: EdgeInsets.only(left: 22),
            child: Text("First Name", style: Design.text.hint()),
          ),

          // Input
          Neumorphic(
              // Padding from Label
              padding: EdgeInsets.only(top: 12),
              child: TextFormField(
                  // Align Inner Text
                  textAlign: TextAlign.left,
                  decoration: Design.textField.decoration(),

                  // Validate Entry
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter valid first name.';
                    }
                    return null;
                  },

                  // Update Value
                  onChanged: (String value) {
                    this._firstName = value;
                  }),

              // Obtain Style
              style: Design.textField.style()),

          // ***************** //
          // ** <Last Name> ** //
          // ***************** //
          // Label
          Padding(
            padding: EdgeInsets.only(left: 22, top: 30),
            child: Text("Last Name", style: Design.text.hint()),
          ),

          // Input
          Neumorphic(
              // Padding from Label
              padding: EdgeInsets.only(top: 12),
              child: TextFormField(
                  // Align Inner Text
                  textAlign: TextAlign.left,
                  decoration: Design.textField.decoration(),

                  // Validate Entry
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter valid last name.';
                    }
                    return null;
                  },

                  // Update Value
                  onChanged: (String value) {
                    this._lastName = value;
                  }),

              // Obtain Style
              style: Design.textField.style()),

          // ********************* //
          // ** <Submit Button> ** //
          // ********************* //
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: NeumorphicButton(
                margin: EdgeInsets.only(top: 12),
                style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    // Process data.
                    BlocProvider.of<UserBloc>(context).add(UpdateProfile(
                        Profile.fromValues(
                            this._firstName, this._lastName, null)));
                  }
                },
                child: Text('Submit',
                    style: TextStyle(color: Design.findTextColor(context))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
