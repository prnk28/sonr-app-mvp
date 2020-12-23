import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/data/social_model.dart';
import 'package:sonar_app/modules/profile/tile_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

// ** Builds Add Social Form Dialog ** //
class TileDialog extends GetView<TileController> {
  @override
  Widget build(BuildContext context) {
    // Update State
    controller.createTile();

    return NeumorphicBackground(
        backendColor: Colors.transparent,
        margin: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 100),
        borderRadius: BorderRadius.circular(40),
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          // @ Build View
          return Material(
              color: Colors.transparent,
              child: Neumorphic(
                style: NeumorphicStyle(color: K_BASE_COLOR),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.minHeight,
                        minWidth: viewportConstraints.minWidth,
                      ),
                      child: IntrinsicHeight(
                        child: Column(children: [
                          // @ Top Right Close/Cancel Button
                          closeButton(() {
                            // Pop Window
                            Get.back();

                            // Reset State
                            controller.state = TileState.None;
                          }, padTop: 12, padRight: 12),

                          // @ Current Add Popup View
                          Padding(padding: EdgeInsets.all(5)),
                          Align(
                              key: UniqueKey(),
                              alignment: Alignment.topCenter,
                              child: Container(child: _buildCurrentView())),

                          // @ Action Buttons
                          Spacer(),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildBackButton(),
                                  _buildNextButton()
                                ]),
                          ),
                          Padding(padding: EdgeInsets.all(15))
                        ]),
                      )),
                ),
              ));
        }));
  }

  // ^ Build Current View ^ //
  _buildCurrentView() {
    return GetBuilder<TileController>(
        id: "TileDialog",
        builder: (_) {
          if (controller.state == TileState.NewStepTwo) {
            return _SetInfoView();
          } else if (controller.state == TileState.NewStepThree) {
            return _SetSizePosView();
          } else {
            return _DropdownAddView();
          }
        });
  }

  // ^ Build Next Button with Finish at End ^ //
  _buildNextButton() {
    return GetBuilder<TileController>(
        id: "TileDialog",
        builder: (_) {
          // Set Finished By State
          if (controller.state == TileState.NewStepThree) {
            return NeumorphicButton(
                onPressed: () {
                  print("Finish Tapped");
                  controller.nextStep();
                },
                style: NeumorphicStyle(
                    depth: 8,
                    color: K_BASE_COLOR,
                    boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(20))),
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
                  controller.nextStep();
                },
                style: NeumorphicStyle(
                    depth: 8,
                    color: K_BASE_COLOR,
                    boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(20))),
                padding: const EdgeInsets.only(
                    top: 12.0, bottom: 12.0, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [normalText("Next"), Icon(Icons.arrow_right)],
                ));
          }
        });
  }

  // ^ Build Back Button with Disabled at Beginning ^ //
  _buildBackButton() {
    return GetBuilder<TileController>(
        id: "TileDialog",
        builder: (_) {
          // Set Disabled By State
          if (controller.state != TileState.NewStepTwo ||
              controller.state == TileState.NewStepThree) {
            return NeumorphicButton(
              onPressed: () {
                print("Back Tapped");
                controller.previousStep();
              },
              style: NeumorphicStyle(
                  depth: 8,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
              padding: const EdgeInsets.all(12.0),
              child: normalText("Back"),
            );
          } else {
            return IgnorePointer(
              ignoring: true,
              child: FlatButton(
                padding: const EdgeInsets.all(12.0),
                onPressed: null,
                child: normalText("Back", setColor: Colors.black45),
              ),
            );
          }
        });
  }
}

// ^ Step 1 Select Provider ^ //
class _DropdownAddView extends StatefulWidget {
  const _DropdownAddView({Key key}) : super(key: key);
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
      children: [
        // @ InfoGraph
        _InfoText(index: 1, text: "Choose a Social Media to Add"),
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
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
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
                      SonrIcon.socialFromProvider(IconType.Normal, value),
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
                      Get.find<TileController>().setProvider(value);

                      // Update Widget View
                      _provider = value;
                    });
                  }
                },
              ),
            )),
      ],
    );
  }
}

// ^ Step 2 Connect to the provider API ^ //
class _SetInfoView extends StatefulWidget {
  const _SetInfoView({
    Key key,
  }) : super(key: key);
// Initialize Tile
  @override
  _SetInfoViewState createState() => _SetInfoViewState();
}

class _SetInfoViewState extends State<_SetInfoView> {
  String _username = "";

  @override
  Widget build(BuildContext context) {
    // Find Data
    Contact_SocialTile tile = Get.find<TileController>().currentTile;
    Widget authView;
    Widget infoText;
    var item = SocialMediaItem.fromProviderData(tile.provider);

    // Create Widgets
    if (item.reference == SocialRefType.Link) {
      authView = _buildView(isButton: false);
      infoText = _InfoText(
          index: 2, text: "Add your ${tile.provider.toString()} username");
    } else {
      authView = _buildView(isButton: true);
      infoText =
          _InfoText(index: 2, text: "Connect with ${tile.provider.toString()}");
    }

    // Build View
    return Column(key: UniqueKey(), children: [
      // @ InfoGraph
      infoText,
      Padding(padding: EdgeInsets.all(20)),
      authView
    ]);
  }

  _buildView({bool isButton = true}) {
    if (isButton == false) {
      return NeuomorphicTextField(
          label: "Username",
          hint: "@prnk28 (Incredible Posts BTW) ",
          value: _username,
          onChanged: (String value) {
            this._username = value;
          },
          onEditingComplete: () {
            setState(() {
              // Update Controller
              Get.find<TileController>().setUsername(_username);
              Get.find<TileController>().nextStep();
            });
          });
    } else {
      // @ Connect Button
      return Neumorphic(
          style: NeumorphicStyle(depth: 8, shape: NeumorphicShape.flat),
          margin: EdgeInsets.only(left: 14, right: 14),
          child: Container(
              width: Get.width - 80,
              margin: EdgeInsets.only(left: 12, right: 12),
              child: Container()));
    }
  }
}

// ^ Step 3 Set the Social Tile type ^ //
class _SetSizePosView extends StatefulWidget {
  const _SetSizePosView({Key key}) : super(key: key);
  @override
  _SetSizePosState createState() => _SetSizePosState();
}

class _SetSizePosState extends State<_SetSizePosView> {
  Contact_SocialTile_TileType _groupValue;
  @override
  Widget build(BuildContext context) {
    return Column(key: UniqueKey(), children: [
      // @ InfoGraph
      _InfoText(index: 3, text: "Set your Tile's type"),
      Padding(padding: EdgeInsets.all(20)),

      // @ Toggle Buttons for Widget Size
      _buildRadios(),
      Neumorphic(
          style: NeumorphicStyle(depth: 8, shape: NeumorphicShape.flat),
          margin: EdgeInsets.only(left: 14, right: 14),
          child: Container(
              width: Get.width - 100,
              margin: EdgeInsets.only(left: 12, right: 12),
              child: Container())),
    ]);
  }

  Widget _buildRadios() {
    return Container(
        constraints: BoxConstraints(maxWidth: Get.width - 80),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 6),
              NeumorphicRadio(
                style: NeumorphicRadioStyle(
                    boxShape: NeumorphicBoxShape.stadium()),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(child: normalText("Icon")),
                ),
                value: Contact_SocialTile_TileType.Icon,
                groupValue: _groupValue,
                onChanged: (value) {
                  setState(() {
                    _groupValue = value;
                    Get.find<TileController>().setType(_groupValue);
                  });
                },
              ),
              SizedBox(width: 6),
              NeumorphicRadio(
                style: NeumorphicRadioStyle(
                    boxShape: NeumorphicBoxShape.stadium()),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(child: normalText("Showcase")),
                ),
                value: Contact_SocialTile_TileType.Showcase,
                groupValue: _groupValue,
                onChanged: (value) {
                  setState(() {
                    _groupValue = value;
                    Get.find<TileController>().setType(_groupValue);
                  });
                },
              ),
              SizedBox(width: 6),
              NeumorphicRadio(
                style: NeumorphicRadioStyle(
                    boxShape: NeumorphicBoxShape.stadium()),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Center(child: normalText("Feed")),
                ),
                value: Contact_SocialTile_TileType.Feed,
                groupValue: _groupValue,
                onChanged: (value) {
                  setState(() {
                    _groupValue = value;
                    Get.find<TileController>().setType(_groupValue);
                  });
                },
              ),
            ],
          ),
        ));
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
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width - 80),
      child: Center(
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(index.toString(),
                  style: GoogleFonts.poppins(
                      fontSize: 108,
                      fontWeight: FontWeight.w900,
                      color: Colors.black38)),
              Padding(padding: EdgeInsets.all(8)),
              Expanded(
                child: Text(text,
                    style: GoogleFonts.poppins(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
              ),
            ]),
      ),
    );
  }
}
