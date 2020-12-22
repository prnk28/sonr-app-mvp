import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'profile_controller.dart';

// ** Builds Add Social Form Dialog ** //
class TileAddDialog extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    // Update State
    controller.addSocialTileNextStep();

    // Get Current View
    return Obx(() {
      // @ Views by State
      Widget nextButton;
      Widget backButton;
      Widget currentView;
      if (controller.state.value == ProfileState.AddingTileStepTwo) {
        nextButton = _buildNextButton();
        backButton = _buildBackButton();
        currentView = _SetInfoView(controller.currentTile.value.provider);
      } else if (controller.state.value == ProfileState.AddingTileStepThree) {
        nextButton = _buildNextButton(isFinished: true);
        backButton = _buildBackButton();
        currentView = _SetSizePosView();
      } else {
        nextButton = _buildNextButton();
        backButton = _buildBackButton(isDisabled: true);
        currentView = _DropdownAddView();
      }

      // @ Build View
      return SonrTheme(
        Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            body: NeumorphicBackground(
                backendColor: Colors.transparent,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 100),
                borderRadius: BorderRadius.circular(40),
                child: Neumorphic(
                    style: NeumorphicStyle(color: K_BASE_COLOR),
                    child: Column(children: [
                      // @ Top Right Close/Cancel Button
                      closeButton(() {
                        // Pop Window
                        Get.back();

                        // Reset State
                        controller.state(ProfileState.Viewing);
                        controller.currentTile(Contact_SocialTile());
                      }, padTop: 12, padRight: 12),

                      // @ Current Add Popup View
                      Padding(padding: EdgeInsets.all(10)),
                      Align(
                          key: UniqueKey(),
                          alignment: Alignment.topCenter,
                          child: FadeAnimatedSwitcher(child: currentView)),

                      // @ Action Buttons
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [backButton, nextButton]),
                      ),
                      Padding(padding: EdgeInsets.all(25))
                    ])))),
      );
    });
  }

  // ^ Build Next Button with Finish at End ^ //
  _buildNextButton({bool isFinished = false}) {
    if (isFinished) {
      return NeumorphicButton(
          onPressed: () {
            print("Finish Tapped");
            controller.addSocialTileNextStep();
          },
          style: NeumorphicStyle(
              depth: 8,
              color: K_BASE_COLOR,
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
            controller.addSocialTileNextStep();
          },
          style: NeumorphicStyle(
              depth: 8,
              color: K_BASE_COLOR,
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

// ^ Step 1 Select Provider ^ //
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
    return Container(
      child: Column(
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // @ InfoGraph
            _InfoText(index: 1, text: "Choose a Social Media"),
            Padding(padding: EdgeInsets.all(20)),

            // @ Drop Down
            Neumorphic(
                style: NeumorphicStyle(depth: 8, shape: NeumorphicShape.flat),
                margin: EdgeInsets.only(left: 14, right: 14),
                child: Container(
                  width: Get.width - 80,
                  margin: EdgeInsets.only(left: 12, right: 12),
                  child: DropdownButton(
                    isExpanded: true,
                    value: _provider,
                    underline: Container(),
                    style: GoogleFonts.poppins(
                        fontSize: 16, color: Colors.black87),
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
          ]),
    );
  }
}

// ^ Step 2 Connect to the provider API ^ //
class _SetInfoView extends StatefulWidget {
  final Contact_SocialTile_Provider provider;

  const _SetInfoView(
    this.provider, {
    Key key,
  }) : super(key: key);
// Initialize Tile
  @override
  _SetInfoViewState createState() => _SetInfoViewState();
}

class _SetInfoViewState extends State<_SetInfoView> {
  @override
  Widget build(BuildContext context) {
    Widget infoView = Container();
    switch (widget.provider) {
    }
    return Container(
      child: Column(
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // @ InfoGraph
            _InfoText(
                index: 2, text: "Set your ${widget.provider.toString()} info"),
            Padding(padding: EdgeInsets.all(20)),

            // @ Connect Button
            Neumorphic(
                style: NeumorphicStyle(depth: 8, shape: NeumorphicShape.flat),
                margin: EdgeInsets.only(left: 14, right: 14),
                child: Container(
                    width: Get.width - 80,
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: infoView)),
          ]),
    );
  }
}

// ^ Step 3 Set the Social Tile type ^ //
class _SetSizePosView extends StatefulWidget {
  const _SetSizePosView({Key key}) : super(key: key);
  @override
  _SetSizePosState createState() => _SetSizePosState();
}

class _SetSizePosState extends State<_SetSizePosView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          key: UniqueKey(),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // @ InfoGraph
            _InfoText(index: 3, text: "Set size and position"),
            Padding(padding: EdgeInsets.all(20)),

            // @ Toggle Buttons for Widget Size

            Row(
              children: [
                // Icon Tile
                NeumorphicRadio(),

                // Showcase Tile
                NeumorphicRadio(),

                // Feed Tile
                NeumorphicRadio(),
              ],
            ),
            Neumorphic(
                style: NeumorphicStyle(depth: 8, shape: NeumorphicShape.flat),
                margin: EdgeInsets.only(left: 14, right: 14),
                child: Container(
                    width: Get.width - 100,
                    margin: EdgeInsets.only(left: 12, right: 12),
                    child: Container())),
          ]),
    );
  }
}

// ^ Creates Infographic Text thats used in all Views ^ //
class _InfoText extends StatelessWidget {
  final int index;
  final String text;

  const _InfoText({Key key, @required this.index, @required this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(index.toString(),
                style: GoogleFonts.poppins(
                    fontSize: 108,
                    fontWeight: FontWeight.w900,
                    color: Colors.black38)),
          ),
          Container(
            width: Get.width / 2 + 30,
            child: Text(text,
                style: GoogleFonts.poppins(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
          ),
        ]);
  }
}
