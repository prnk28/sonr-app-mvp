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
    // Update State
    controller.addSocialTileNextStep();
    
    // Get Current View
    Widget currentView = Obx(() {
      if (controller.state.value == ProfileState.AddingTileStepTwo) {
        return _SetInfoView();
      } else if (controller.state.value == ProfileState.AddingTileStepTwo) {
        return _SetSizePosView();
      } else {
        return _DropdownAddView();
      }
    });

    // Build View
    return SonrTheme(
      Scaffold(
          backgroundColor: Colors.transparent,
          body: NeumorphicBackground(
              backendColor: Colors.black54,
              margin:
                  EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 100),
              borderRadius: BorderRadius.circular(40),
              child: Neumorphic(
                  child: Column(children: [
                // @ Top Right Close/Cancel Button
                closeButton(() {
                  // Reset State
                  controller.state(ProfileState.Viewing);
                  controller.currentTile(Contact_SocialTile());

                  // Pop Window
                  Get.back();
                }, padTop: 12, padRight: 12),

                // @ Current Add Popup View
                Padding(padding: EdgeInsets.all(10)),
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
                        _buildBackButton(isDisabled: true),
                        _buildNextButton(),
                      ]),
                ),
                Padding(padding: EdgeInsets.all(25))
              ])))),
    );
  }

  // ^ Build Next Button with Finish at End ^ //
  _buildNextButton({bool isFinished = false}) {
    if (isFinished) {
      return NeumorphicButton(
          onPressed: () {
            controller.addSocialTileNextStep();
          },
          style: NeumorphicStyle(
              depth: 8,
              boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(20))),
          padding: const EdgeInsets.only(
              top: 12.0, bottom: 12.0, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [normalText("Finish"), Icon(Icons.check)],
          ));
    } else {
      return NeumorphicButton(
          onPressed: () {
            print("Next Tapped");
          },
          style: NeumorphicStyle(
              depth: 8,
              boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(20))),
          padding: const EdgeInsets.only(
              top: 12.0, bottom: 12.0, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [normalText("Next"), Icon(Icons.arrow_right)],
          ));
    }
  }

  // ^ Build Back Button with Disabled at Beginning ^ //
  _buildBackButton({bool isDisabled = false}) {
    if (isDisabled) {
      return IgnorePointer(
        ignoring: true,
        child: FlatButton(
          padding: const EdgeInsets.all(12.0),
          onPressed: null,
          child: normalText("Back", setColor: Colors.black45),
        ),
      );
    } else {
      return NeumorphicButton(
        onPressed: () {
          print("Back Tapped");
          controller.addSocialTilePrevStep();
        },
        style: NeumorphicStyle(
            depth: 8,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
        padding: const EdgeInsets.all(12.0),
        child: normalText("Back"),
      );
    }
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
    return Column(
        key: UniqueKey(),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // @ InfoGraph
          Center(
            child: Stack(
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
                  padding: EdgeInsets.only(top: 15, left: 55),
                  child: Text("Choose a Social Media",
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(20)),
          // @ Drop Down
          Neumorphic(
              style: NeumorphicStyle(depth: 8, shape: NeumorphicShape.flat),
              margin: EdgeInsets.only(left: 14, right: 14),
              child: Container(
                width: Get.width - 100,
                margin: EdgeInsets.only(left: 12, right: 12),
                child: DropdownButton(
                  isExpanded: true,
                  value: _provider,
                  underline: Container(),
                  style:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                  icon: Align(
                      child: Icon(Icons.arrow_downward),
                      alignment: Alignment.centerRight),
                  elevation: 0,
                  hint: Text("Select...",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black26,
                      )),

                  // @ Custom Dropdown Items
                  items: List<DropdownMenuItem>.generate(
                      Contact_SocialTile_Provider.values.length, (index) {
                    var value = Contact_SocialTile_Provider.values[index];
                    return DropdownMenuItem(
                      child: Row(children: [
                        iconFromSocialProvider(value),
                        Padding(padding: EdgeInsets.all(4)),
                        Text(value.toString())
                      ]),
                      value: value,
                    );
                  }),
                  onChanged: (value) {
                    if (value is Contact_SocialTile_Provider) {
                      setState(() {
                        // Update Controller
                        Get.find<ProfileController>()
                            .addSocialTileProvider(value);

                        // Update Widget View
                        _provider = value;
                      });
                    }
                  },
                ),
              )),
        ]);
  }
}

class _SetInfoView extends StatefulWidget {
// Initialize Tile
  @override
  _SetInfoViewState createState() => _SetInfoViewState();
}

class _SetInfoViewState extends State<_SetInfoView> {
  Contact_SocialTile_Provider _provider;

  @override
  Widget build(BuildContext context) {
    return Column(
        key: UniqueKey(),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // @ InfoGraph
          Center(
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  child: Text("2",
                      style: GoogleFonts.poppins(
                          fontSize: 108,
                          fontWeight: FontWeight.w900,
                          color: Colors.black38)),
                ),
                Container(
                  width: Get.width / 2 + 20,
                  padding: EdgeInsets.only(top: 15, left: 55),
                  child: Text("Set your info",
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(20)),
          // @ Drop Down
          Neumorphic(
              style: NeumorphicStyle(depth: 8, shape: NeumorphicShape.flat),
              margin: EdgeInsets.only(left: 14, right: 14),
              child: Container(
                width: Get.width - 100,
                margin: EdgeInsets.only(left: 12, right: 12),
                child: DropdownButton(
                  isExpanded: true,
                  value: _provider,
                  underline: Container(),
                  style:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                  icon: Align(
                      child: Icon(Icons.arrow_downward),
                      alignment: Alignment.centerRight),
                  elevation: 0,
                  hint: Text("Select...",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black26,
                      )),

                  // @ Custom Dropdown Items
                  items: List<DropdownMenuItem>.generate(
                      Contact_SocialTile_Provider.values.length, (index) {
                    var value = Contact_SocialTile_Provider.values[index];
                    return DropdownMenuItem(
                      child: Row(children: [
                        iconFromSocialProvider(value),
                        Padding(padding: EdgeInsets.all(4)),
                        Text(value.toString())
                      ]),
                      value: value,
                    );
                  }),
                  onChanged: (value) {
                    if (value is Contact_SocialTile_Provider) {
                      setState(() {
                        // Update Controller
                        Get.find<ProfileController>()
                            .addSocialTileProvider(value);

                        // Update Widget View
                        _provider = value;
                      });
                    }
                  },
                ),
              )),
        ]);
  }
}

class _SetSizePosView extends StatefulWidget {
// Initialize Tile
  @override
  _SetSizePosState createState() => _SetSizePosState();
}

class _SetSizePosState extends State<_SetSizePosView> {
  Contact_SocialTile_Provider _provider;

  @override
  Widget build(BuildContext context) {
    return Column(
        key: UniqueKey(),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // @ InfoGraph
          Center(
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  child: Text("3",
                      style: GoogleFonts.poppins(
                          fontSize: 108,
                          fontWeight: FontWeight.w900,
                          color: Colors.black38)),
                ),
                Container(
                  width: Get.width / 2 + 20,
                  padding: EdgeInsets.only(top: 15, left: 55),
                  child: Text("Set size and position",
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(20)),
          // @ Drop Down
          Neumorphic(
              style: NeumorphicStyle(depth: 8, shape: NeumorphicShape.flat),
              margin: EdgeInsets.only(left: 14, right: 14),
              child: Container(
                width: Get.width - 100,
                margin: EdgeInsets.only(left: 12, right: 12),
                child: DropdownButton(
                  isExpanded: true,
                  value: _provider,
                  underline: Container(),
                  style:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                  icon: Align(
                      child: Icon(Icons.arrow_downward),
                      alignment: Alignment.centerRight),
                  elevation: 0,
                  hint: Text("Select...",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black26,
                      )),

                  // @ Custom Dropdown Items
                  items: List<DropdownMenuItem>.generate(
                      Contact_SocialTile_Provider.values.length, (index) {
                    var value = Contact_SocialTile_Provider.values[index];
                    return DropdownMenuItem(
                      child: Row(children: [
                        iconFromSocialProvider(value),
                        Padding(padding: EdgeInsets.all(4)),
                        Text(value.toString())
                      ]),
                      value: value,
                    );
                  }),
                  onChanged: (value) {
                    if (value is Contact_SocialTile_Provider) {
                      setState(() {
                        // Update Controller
                        Get.find<ProfileController>()
                            .addSocialTileProvider(value);

                        // Update Widget View
                        _provider = value;
                      });
                    }
                  },
                ),
              )),
        ]);
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
