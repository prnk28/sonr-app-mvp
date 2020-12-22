part of 'register_screen.dart';

final _formKey = GlobalKey<FormState>();

class FormView extends StatefulWidget {
  FormView({Key key}) : super(key: key);

  @override
  _FormViewState createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  String _firstName;
  String _lastName;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ****************** //
          // ** <First Name> ** //
          // ****************** //
          NeuomorphicTextField(
              label: "First Name",
              hint: "Enter your first name",
              onChanged: (String value) {
                this._firstName = value;
              }),

          // ***************** //
          // ** <Last Name> ** //
          // ***************** //
          NeuomorphicTextField(
              label: "Last Name",
              hint: "Enter your last name",
              onChanged: (String value) {
                this._lastName = value;
              }),

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
                    // Get Contact from Values
                    var contact = new Contact();
                    contact.firstName = _firstName;
                    contact.lastName = _lastName;

                    // Process data.
                    Get.find<DeviceService>()
                        .createUser(contact, "@Temp_Username");
                  }
                },
                child: defaultText("Submit"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
