import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'profile_controller.dart';

// ** Builds Add Social Form Dialog ** //
class AddDialog extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    Widget currentView = _DropdownAddView();
    return SonrTheme(
      Scaffold(
          backgroundColor: Colors.transparent,
          body: NeumorphicBackground(
              backendColor: Colors.black87,
              margin:
                  EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 100),
              borderRadius: BorderRadius.circular(40),
              child: Neumorphic(
                  child: Column(children: [
                // @ Top Right Close/Cancel Button
                closeButton(() {
                  // Pop Window
                  Get.back();
                }, padTop: 10, padRight: 10),

                // @ Current Add Popup View
                Padding(padding: EdgeInsets.all(25)),
                Align(
                    alignment: Alignment.topCenter,
                    child: AnimatedSwitcher(
                        duration: Duration(seconds: 1, milliseconds: 500),
                        child: currentView)),
                // @ Action Buttons
                Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        rectangleButton("Back", () {
                          print("Back Tapped");
                        }),
                        rectangleButton("Next", () {
                          print("Next Tapped");
                        }),
                      ]),
                ),
                Padding(padding: EdgeInsets.all(25))
              ])))),
    );
  }
}

class _DropdownAddView extends StatefulWidget {
  @override
  _DropdownAddViewState createState() => _DropdownAddViewState();
}

class _DropdownAddViewState extends State<_DropdownAddView> {
  // Initialize Tile
  Contact_SocialTile_Provider _provider;

  // Build View As Stateless
  @override
  Widget build(BuildContext context) {
    return Column(key: UniqueKey(), children: [
      // @ InfoGraph
      Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            child: Text("1",
                style: GoogleFonts.poppins(
                    fontSize: 108,
                    fontWeight: FontWeight.w900,
                    color: Colors.black38)),
          ),
          Container(
            width: Get.width / 2 + 20,
            padding: EdgeInsets.only(top: 15, left: 45),
            child: Text("Choose a Social Media",
                style: GoogleFonts.poppins(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
          ),
        ],
      ),
      Padding(padding: EdgeInsets.all(20)),
      // @ Drop Down
      Neumorphic(
          style: NeumorphicStyle(depth: 8, shape: NeumorphicShape.flat),
          margin: EdgeInsets.only(left: 14, right: 14),
          child: DropdownButton(
            value: _provider,
            underline: Container(),
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
            icon: Icon(Boxicons.bx_arrow_to_bottom),
            elevation: 0,
            hint: Text("Select... ",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black26,
                )),

            // @ Custom Dropdown Items
            items: <DropdownMenuItem>[
              DropdownMenuItem(
                child: Text("Facebook"),
                value: Contact_SocialTile_Provider.Facebook,
              ),
              DropdownMenuItem(
                child: Text("Instagram"),
                value: Contact_SocialTile_Provider.Instagram,
              ),
              DropdownMenuItem(
                child: Text("Twitter"),
                value: Contact_SocialTile_Provider.Twitter,
              ),
              DropdownMenuItem(
                child: Text("TikTok"),
                value: Contact_SocialTile_Provider.TikTok,
              ),
              DropdownMenuItem(
                child: Text("YouTube"),
                value: Contact_SocialTile_Provider.YouTube,
              ),
              DropdownMenuItem(
                child: Text("Spotify"),
                value: Contact_SocialTile_Provider.Spotify,
              ),
              DropdownMenuItem(
                child: Text("Medium"),
                value: Contact_SocialTile_Provider.Medium,
              ),
            ],
            onChanged: (value) {
              if (value is Contact_SocialTile_Provider) {
                setState(() {
                  _provider = value;
                });
              }
            },
          )),
    ]);
  }
}

class FormSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
        defaultTextColor: Color(0xFF3E3E3E),
        accentColor: Colors.grey,
        variantColor: Colors.black38,
        depth: 8,
        intensity: 0.65,
      ),
      themeMode: ThemeMode.light,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: NeumorphicBackground(
          margin: EdgeInsets.only(left: 20, right: 20, top: 45, bottom: 105),
          borderRadius: BorderRadius.circular(20),
          child: _Page(),
        ),
      ),
    );
  }
}

class _Page extends StatefulWidget {
  @override
  __PageState createState() => __PageState();
}

enum Gender { MALE, FEMALE, NON_BINARY }

class __PageState extends State<_Page> {
  String firstName = "";
  String lastName = "";
  double age = 12;
  Gender gender;
  Set<String> rides = Set();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Neumorphic(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              style: NeumorphicStyle(
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 8,
                  ),
                  // @ Top Right Close/Cancel Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: closeButton(() {
                      // Pop Window
                      Get.back();
                    }, padTop: 8, padRight: 8),
                  ),
                  _AvatarField(),
                  SizedBox(
                    height: 8,
                  ),
                  _TextField(
                    label: "First name",
                    hint: "",
                    onChanged: (firstName) {
                      setState(() {
                        this.firstName = firstName;
                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _TextField(
                    label: "Last name",
                    hint: "",
                    onChanged: (lastName) {
                      setState(() {
                        this.lastName = lastName;
                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _AgeField(
                    age: this.age,
                    onChanged: (age) {
                      setState(() {
                        this.age = age;
                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _GenderField(
                    gender: gender,
                    onChanged: (gender) {
                      setState(() {
                        this.gender = gender;
                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  /*
                  _RideField(
                    rides: this.rides,
                    onChanged: (rides) {
                      setState(() {
                        this.rides = rides;
                      });
                    },
                  ),
                  SizedBox(
                    height: 28,
                  ),
                   */
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool _isButtonEnabled() {
    return this.firstName.isNotEmpty && this.lastName.isNotEmpty;
  }
}

class _AvatarField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Neumorphic(
        padding: EdgeInsets.all(10),
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.circle(),
          depth: NeumorphicTheme.embossDepth(context),
        ),
        child: Icon(
          Icons.insert_emoticon,
          size: 120,
          color: Colors.black.withOpacity(0.2),
        ),
      ),
    );
  }
}

class _AgeField extends StatelessWidget {
  final double age;
  final ValueChanged<double> onChanged;

  _AgeField({@required this.age, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            "Age",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: NeumorphicSlider(
                  min: 8,
                  max: 75,
                  value: this.age,
                  onChanged: (value) {
                    this.onChanged(value);
                  },
                ),
              ),
            ),
            Text("${this.age.floor()}"),
            SizedBox(
              width: 18,
            )
          ],
        ),
      ],
    );
  }
}

class _TextField extends StatefulWidget {
  final String label;
  final String hint;

  final ValueChanged<String> onChanged;

  _TextField({@required this.label, @required this.hint, this.onChanged});

  @override
  __TextFieldState createState() => __TextFieldState();
}

class __TextFieldState extends State<_TextField> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.hint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            this.widget.label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
        ),
        Neumorphic(
          margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
          style: NeumorphicStyle(
            depth: NeumorphicTheme.embossDepth(context),
            boxShape: NeumorphicBoxShape.stadium(),
          ),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          child: TextField(
            onChanged: this.widget.onChanged,
            controller: _controller,
            decoration: InputDecoration.collapsed(hintText: this.widget.hint),
          ),
        )
      ],
    );
  }
}

class _GenderField extends StatelessWidget {
  final Gender gender;
  final ValueChanged<Gender> onChanged;

  const _GenderField({
    @required this.gender,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            "Gender",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            SizedBox(width: 12),
            NeumorphicRadio(
              groupValue: this.gender,
              padding: EdgeInsets.all(20),
              style: NeumorphicRadioStyle(
                boxShape: NeumorphicBoxShape.circle(),
              ),
              value: Gender.MALE,
              child: Icon(Icons.account_box),
              onChanged: (value) => this.onChanged(value),
            ),
            SizedBox(width: 12),
            NeumorphicRadio(
              groupValue: this.gender,
              padding: EdgeInsets.all(20),
              style: NeumorphicRadioStyle(
                boxShape: NeumorphicBoxShape.circle(),
              ),
              value: Gender.FEMALE,
              child: Icon(Icons.pregnant_woman),
              onChanged: (value) => this.onChanged(value),
            ),
            SizedBox(width: 12),
            NeumorphicRadio(
              groupValue: this.gender,
              padding: EdgeInsets.all(20),
              style: NeumorphicRadioStyle(
                boxShape: NeumorphicBoxShape.circle(),
              ),
              value: Gender.NON_BINARY,
              child: Icon(Icons.supervised_user_circle),
              onChanged: (value) => this.onChanged(value),
            ),
            SizedBox(
              width: 18,
            )
          ],
        ),
      ],
    );
  }
}
