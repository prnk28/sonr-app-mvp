part of 'register.dart';

final _formKey = GlobalKey<FormState>();

class FormView extends StatefulWidget {
  FormView({Key key}) : super(key: key);

  @override
  _FormViewState createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  String _firstName;
  String _lastName;

  // @ Helpers

// Hint Text
  TextStyle hintTextStyle({Color setColor}) {
    return TextStyle(
      fontFamily: "Raleway",
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: setColor ?? Colors.black87,
    );
  }

// Input Text
  TextStyle inputTextStyle({Color setColor}) {
    return TextStyle(
        fontFamily: "Raleway",
        fontWeight: FontWeight.normal,
        fontSize: 28,
        color: setColor ?? Colors.cyan);
  }

// Description Text
  TextStyle descriptionTextStyle({Color setColor}) {
    return TextStyle(
        fontFamily: "Raleway",
        fontWeight: FontWeight.normal,
        fontSize: 24,
        color: setColor ?? Colors.black45);
  }

  // Text Field Decoration
  InputDecoration textFieldDecoration() {
    return new InputDecoration(
        // Disable Line
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,

        // Input Text Style
        hintStyle: inputTextStyle(),

        // Pad for Border
        contentPadding: const EdgeInsets.only(left: 20.0, bottom: 7.5));
  }

// Text Field Style
  NeumorphicStyle textFieldStyle() {
    return NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(45)),
        depth: -6,
        lightSource: LightSource.topLeft,
        color: Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    // Connect to Sonr Network
    final DeviceService device = Get.find();

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
            child: Text("First Name", style: hintTextStyle()),
          ),

          // Input
          Neumorphic(
              // Padding from Label
              padding: EdgeInsets.only(top: 12),
              child: TextFormField(
                  // Align Inner Text
                  textAlign: TextAlign.left,
                  decoration: textFieldDecoration(),

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
              style: textFieldStyle()),

          // ***************** //
          // ** <Last Name> ** //
          // ***************** //
          // Label
          Padding(
            padding: EdgeInsets.only(left: 22, top: 30),
            child: Text("Last Name", style: hintTextStyle()),
          ),

          // Input
          Neumorphic(
              // Padding from Label
              padding: EdgeInsets.only(top: 12),
              child: TextFormField(
                  // Align Inner Text
                  textAlign: TextAlign.left,
                  decoration: textFieldDecoration(),

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
              style: textFieldStyle()),

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
                    device.createUser(contact, "@Temp_Username");
                  }
                },
                child: Text('Submit',
                    style: TextStyle(color: findTextColor(context))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
