import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/data/social_model.dart';
import 'package:sonar_app/modules/profile/profile_controller.dart';
import 'package:sonar_app/modules/profile/tile_controller.dart';
import 'package:sonar_app/modules/profile/tile_preview.dart';
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
                            child: GetBuilder<TileController>(
                                id: "TileDialog",
                                builder: (_) {
                                  Widget topButtons;
                                  Widget bottomButtons;

                                  // @ Step Three: No Buttom Buttons, Cancel and Confirm
                                  if (controller.state ==
                                      TileState.NewStepThree) {
                                    // Top Buttons
                                    topButtons = Container();

                                    // Bottom Buttons
                                    bottomButtons = Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // @ Top Left Close/Cancel Button
                                          closeButton(() {
                                            Get.back();
                                            controller.state = TileState.None;
                                          }),
                                          // @ Top Right Confirm Button
                                          acceptButton(() {
                                            controller.nextStep();
                                          }),
                                        ]);
                                  }
                                  // @ Step Two: Dual Bottom Buttons, Back and Next, Cancel Top Button
                                  else if (controller.state ==
                                      TileState.NewStepTwo) {
                                    topButtons = closeButton(() {
                                      Get.back();
                                      controller.state = TileState.None;
                                    });

                                    // Bottom Buttons
                                    bottomButtons = Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildBackButton(),
                                          _buildNextButton()
                                        ]);
                                  }
                                  // @ Step One: Top Cancel Button, Bottom wide Next Button
                                  else {
                                    // Top Buttons
                                    topButtons = closeButton(() {
                                      Get.back();
                                      controller.state = TileState.None;
                                    });

                                    // Bottom Buttons
                                    bottomButtons =
                                        _buildNextButton(expanded: true);
                                  }

                                  // ^ Build View ^ //
                                  return Column(children: [
                                    // Top Buttons
                                    topButtons,

                                    // Current View
                                    Padding(padding: EdgeInsets.all(5)),
                                    Align(
                                        key: UniqueKey(),
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                            child: _buildCurrentView())),

                                    // Bottom Buttons
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: bottomButtons,
                                    ),
                                    Padding(padding: EdgeInsets.all(15))
                                  ]);
                                })))),
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
            return _SetTypeView();
          } else {
            // Initialize List of Options
            var options = List<Contact_SocialTile_Provider>();

            // Iterate through All Options
            Contact_SocialTile_Provider.values.forEach((provider) {
              if (!Get.find<ProfileController>()
                  .tiles
                  .any((tile) => tile.provider == provider)) {
                options.add(provider);
              }
            });

            return _DropdownAddView(options);
          }
        });
  }

  // ^ Build Next Button with Finish at End ^ //
  _buildNextButton({bool expanded = false}) {
    return NeumorphicButton(
        margin:
            expanded ? EdgeInsets.only(left: 50, right: 50) : EdgeInsets.zero,
        onPressed: () {
          controller.nextStep();
        },
        style: NeumorphicStyle(
            depth: 8,
            color: K_BASE_COLOR,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20))),
        padding: expanded
            ? EdgeInsets.only(top: 12.0, bottom: 12.0, left: 20, right: 20)
            : EdgeInsets.only(top: 12.0, bottom: 12.0, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            expanded
                ? SonrText.normal("Next", size: 22)
                : SonrText.normal("Next"),
            SonrIcon.gradient(
                Icons.arrow_right, FlutterGradientNames.eternalConstance,
                size: 24)
          ],
        ));
  }

  // ^ Build Back Button with Disabled at Beginning ^ //
  _buildBackButton() {
    return NeumorphicButton(
      onPressed: () {
        controller.previousStep();
      },
      style: NeumorphicStyle(
          depth: 8,
          color: K_BASE_COLOR,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20))),
      padding:
          const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Icon(Icons.arrow_left), SonrText.normal("Back")],
      ),
    );
  }
}

// ^ Step 1 Select Provider ^ //
class _DropdownAddView extends StatefulWidget {
  final List<Contact_SocialTile_Provider> options;
  const _DropdownAddView(this.options, {Key key}) : super(key: key);
  @override
  _DropdownAddViewState createState() => _DropdownAddViewState();
}

class _DropdownAddViewState extends State<_DropdownAddView> {
  // Initialize Tile
  dynamic _dropValue;

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
            style: NeumorphicStyle(
              depth: 8,
              shape: NeumorphicShape.flat,
              color: K_BASE_COLOR,
            ),
            margin: EdgeInsets.only(left: 14, right: 14),
            child: Container(
              width: Get.width - 80,
              margin: EdgeInsets.only(left: 12, right: 12),
              child: DropdownButton(
                isExpanded: true,
                value: _dropValue,
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
                items: List<DropdownMenuItem>.generate(widget.options.length,
                    (index) {
                  // Pull Options
                  var value = widget.options[index];

                  // Create Dropdown Menu Items
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
                  setState(() {
                    this._dropValue = value;
                  });
                  Get.find<TileController>().setProvider(value);
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
  @override
  _SetInfoViewState createState() => _SetInfoViewState();
}

class _SetInfoViewState extends State<_SetInfoView> {
  String _username = "";

  @override
  Widget build(BuildContext context) {
    // Find Data
    Contact_SocialTile tile = Get.find<TileController>().currentTile;
    var item = SocialMediaItem.fromProviderData(tile.provider);

    // Build View
    return Column(key: UniqueKey(), children: [
      // @ InfoGraph
      _InfoText(index: 2, text: item.infoText),
      Padding(padding: EdgeInsets.all(20)),
      _buildView(item)
    ]);
  }

  _buildView(SocialMediaItem item) {
    if (item.reference == SocialRefType.Link) {
      return SonrTextField(
          label: item.label,
          hint: item.hint,
          value: _username,
          onChanged: (String value) {
            this._username = value;
          },
          onEditingComplete: () {
            setState(() {
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
class _SetTypeView extends StatefulWidget {
  const _SetTypeView({Key key}) : super(key: key);
  @override
  _SetSizePosState createState() => _SetSizePosState();
}

class _SetSizePosState extends State<_SetTypeView> {
  Contact_SocialTile_TileType _groupValue;
  @override
  Widget build(BuildContext context) {
    return Column(key: UniqueKey(), children: [
      // @ InfoGraph
      _InfoText(index: 3, text: "Set your Tile's type"),
      Padding(padding: EdgeInsets.all(20)),

      // @ Toggle Buttons for Widget Size
      Container(
          constraints: BoxConstraints(maxWidth: Get.width - 80),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Icon Option
                TilePreviewRadio(Contact_SocialTile_TileType.Icon,
                    groupValue: _groupValue, onChanged: (value) {
                  Get.find<TileController>().setType(value);
                  setState(() {
                    this._groupValue = value;
                  });
                }),

                // Showcase Option
                TilePreviewRadio(Contact_SocialTile_TileType.Showcase,
                    groupValue: _groupValue, onChanged: (value) {
                  Get.find<TileController>().setType(value);
                  setState(() {
                    this._groupValue = value;
                  });
                }),

                // Feed Option
                TilePreviewRadio(Contact_SocialTile_TileType.Feed,
                    groupValue: _groupValue, onChanged: (value) {
                  Get.find<TileController>().setType(value);
                  setState(() {
                    this._groupValue = value;
                  });
                }),
              ],
            ),
          )),
    ]);
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
              Padding(padding: EdgeInsets.all(14)),
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
