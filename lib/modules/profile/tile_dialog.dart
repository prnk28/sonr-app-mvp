import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonar_app/data/social_model.dart';
import 'package:sonar_app/modules/profile/profile_controller.dart';
import 'package:sonar_app/modules/profile/tile_controller.dart';
import 'package:sonar_app/widgets/radio.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

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
            expanded ? EdgeInsets.only(left: 60, right: 80) : EdgeInsets.zero,
        onPressed: () {
          controller.nextStep();
        },
        style: NeumorphicStyle(
            depth: 8,
            color: K_BASE_COLOR,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20))),
        padding: EdgeInsets.only(top: 12.0, bottom: 12.0, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            expanded
                ? SonrText.normal("Next", size: 22)
                : SonrText.normal("Next"),
            SonrIcon.gradient(
                Icons.arrow_right, FlutterGradientNames.eternalConstance,
                size: 30)
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
class _DropdownAddView extends GetView<TileController> {
  final List<Contact_SocialTile_Provider> options;
  _DropdownAddView(this.options, {Key key}) : super(key: key);

  // Build View As Stateless
  @override
  Widget build(BuildContext context) {
    return Column(
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

                // @ ValueBuilder for DropDown
                child: ValueBuilder<Contact_SocialTile_Provider>(
                  onUpdate: (value) {
                    print("Value updated: $value");
                    controller.currentTile.value.provider = value;
                    controller.currentTile.refresh();
                  },
                  builder: (item, updateFn) {
                    return DropDown<Contact_SocialTile_Provider>(
                      showUnderline: false,
                      isExpanded: true,
                      initialValue: item,
                      items: options,
                      customWidgets: List<Widget>.generate(
                          options.length, (index) => _buildOptionWidget(index)),
                      hint: Text("Select...",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black26,
                          )),
                      onChanged: updateFn,
                      isCleared:
                          controller.currentTile.value.hasProvider() == false,
                    );
                  },
                ))),
      ],
    );
  }

  // ^ Builds option at index
  _buildOptionWidget(int index) {
    var item = options.elementAt(index);
    return Row(children: [
      SonrIcon.socialFromProvider(IconType.Normal, item),
      Padding(padding: EdgeInsets.all(4)),
      Text(item.toString())
    ]);
  }
}

// ^ Step 2 Connect to the provider API ^ //
class _SetInfoView extends GetView<TileController> {
  final _username = "".obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TileController>(
        id: "TileDialog",
        builder: (_) {
          // Find Data
          Contact_SocialTile tile = controller.currentTile.value;
          var item = SocialMediaItem.fromProviderData(tile.provider);

          // Build View
          return Column(children: [
            // @ InfoGraph
            _InfoText(index: 2, text: item.infoText),
            Padding(padding: EdgeInsets.all(20)),
            _buildView(item)
          ]);
        });
  }

  _buildView(SocialMediaItem item) {
    if (item.reference == SocialRefType.Link) {
      // @ Text Field
      return Obx(() => SonrTextField(
          label: item.label,
          hint: item.hint,
          value: _username.value,
          onChanged: (String value) {
            _username(value);
          },
          onEditingComplete: () {
            controller.currentTile.value.username = _username.value;
            controller.currentTile.refresh();
            controller.nextStep();
          }));
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
    return Column(children: [
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
                AnimatedTileRadio(Contact_SocialTile_TileType.Icon,
                    groupValue: _groupValue, onChanged: (value) {
                  Get.find<TileController>().currentTile.value.type = value;
                  Get.find<TileController>().currentTile.refresh();
                  setState(() {
                    this._groupValue = value;
                  });
                }),

                // Showcase Option
                AnimatedTileRadio(Contact_SocialTile_TileType.Showcase,
                    groupValue: _groupValue, onChanged: (value) {
                  Get.find<TileController>().currentTile.value.type = value;
                  Get.find<TileController>().currentTile.refresh();
                  setState(() {
                    this._groupValue = value;
                  });
                }),

                // Feed Option
                AnimatedTileRadio(Contact_SocialTile_TileType.Feed,
                    groupValue: _groupValue, onChanged: (value) {
                  Get.find<TileController>().currentTile.value.type = value;
                  Get.find<TileController>().currentTile.refresh();
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

// ValueBuilder<Contact_SocialTile_TileType>(
//             initialValue: _groupValue,
//             builder: (value, updateFn) {
//               return AnimatedTileRadio(Contact_SocialTile_TileType.Icon,
//                   groupValue: value, onChanged: updateFn);
//             },
//             // if you need to call something outside the builder method.
//             onUpdate: (value) {
//               Get.find<TileController>().setType(value);
//               print("Value updated: $value");
//             },
//             onDispose: () => print("Widget unmounted"),
//           ),

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
