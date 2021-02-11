import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_app/modules/profile/profile_controller.dart';
import 'package:sonr_app/service/social_service.dart';
import 'package:sonr_app/widgets/radio.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

enum SocialAuthType { Link, OAuth }

// ** Builds Add Social Form Dialog ** //
class TileCreateStepper extends GetView<TileStepperController> {
  @override
  Widget build(BuildContext context) {
    // Update State
    controller.start();
    return NeumorphicBackground(
        backendColor: Colors.transparent,
        margin: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 150),
        borderRadius: BorderRadius.circular(40),
        child: Material(
            color: Colors.transparent,
            child: Neumorphic(
              style: NeumorphicStyle(color: K_BASE_COLOR),
              child: Container(
                width: 352,
                height: Get.height - 200,
                child: Obx(() {
                  Widget topButtons;
                  Widget bottomButtons;
                  Widget currentView;

                  // @ Step Three: No Buttom Buttons, Cancel and Confirm
                  if (controller.step.value == 3) {
                    // Top Buttons
                    currentView = _SetTypeView();
                    topButtons = Container();

                    // Bottom Buttons
                    bottomButtons = Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      // @ Bottom Left Close/Cancel Button
                      SonrButton.close(() {
                        Get.back();
                      }),
                      // @ Bottom Right Confirm Button
                      SonrButton.accept(() {
                        controller.saveTile();
                        Get.back(closeOverlays: true);
                      }),
                    ]);
                  }
                  // @ Step Two: Dual Bottom Buttons, Back and Next, Cancel Top Button
                  else if (controller.step.value == 2) {
                    currentView = _SetInfoView();
                    topButtons = SonrButton.close(() {
                      Get.back();
                    });

                    // Bottom Buttons
                    bottomButtons = Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      SonrButton.rectangle(text: SonrText.normal("Back"), onPressed: controller.previousStep, icon: SonrIcon.back),
                      SonrButton.rectangle(
                          text: SonrText.normal("Next"), onPressed: controller.nextStep, icon: SonrIcon.forward, iconPosition: WidgetPosition.Right),
                    ]);
                  }
                  // @ Step One: Top Cancel Button, Bottom wide Next Button
                  else {
                    // Initialize List of Options
                    var options = <Contact_SocialTile_Provider>[];

                    // Iterate through All Options
                    Contact_SocialTile_Provider.values.forEach((provider) {
                      if (!Get.find<ProfileController>().socials.any((tile) => tile.provider == provider)) {
                        options.add(provider);
                      }
                    });

                    currentView = _DropdownAddView(options);

                    // Top Buttons
                    topButtons = SonrButton.close(() {
                      Get.back();
                    });

                    // Bottom Buttons
                    bottomButtons = SonrButton.rectangle(
                        text: SonrText.normal("Next", size: 22),
                        onPressed: controller.nextStep,
                        icon: SonrIcon.forward,
                        margin: EdgeInsets.only(left: 60, right: 80),
                        iconPosition: WidgetPosition.Right);
                  }

                  // ^ Build View ^ //
                  return Column(children: [
                    // Top Buttons
                    topButtons,

                    // Current View
                    Padding(padding: EdgeInsets.all(5)),
                    Align(key: UniqueKey(), alignment: Alignment.topCenter, child: Container(child: currentView)),

                    // Bottom Buttons
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: bottomButtons,
                    ),
                    Padding(padding: EdgeInsets.all(15))
                  ]);
                }),
              ),
            )));
  }
}

// ^ Step 1 Select Provider ^ //
class _DropdownAddView extends GetView<TileStepperController> {
  final List<Contact_SocialTile_Provider> options;
  _DropdownAddView(this.options, {Key key}) : super(key: key);

  // Build View As Stateless
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    controller.provider(value);
                    controller.provider.refresh();
                  },
                  builder: (item, updateFn) {
                    return DropDown<Contact_SocialTile_Provider>(
                      showUnderline: false,
                      isExpanded: true,
                      initialValue: item,
                      items: options,
                      customWidgets: List<Widget>.generate(options.length, (index) => _buildOptionWidget(index)),
                      hint: Text("Select...",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black26,
                          )),
                      onChanged: updateFn,
                      isCleared: controller.provider.value == null,
                    );
                  },
                ))),
        // @ Public/Private Checker
        Obx(() {
          // Check Selected
          if (controller.provider.value != null) {
            // Check Privacy
            if (controller.doesProviderAllowVisibility(controller.provider.value)) {
              return Container(
                padding: EdgeInsets.only(top: 25),
                width: Get.width - 160,
                margin: EdgeInsets.only(left: 12, right: 12),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  // @ Set Text
                  SonrText.normal("Is your account Public?", size: 18),

                  // @ Create Check Box
                  ValueBuilder<bool>(
                      initialValue: false,
                      onUpdate: (value) {
                        controller.isPrivate(!value);
                      },
                      builder: (isPublic, updateFn) {
                        return Container(
                          width: 35,
                          height: 35,
                          child: NeumorphicCheckbox(
                            onChanged: updateFn,
                            value: isPublic,
                          ),
                        );
                      })
                ]),
              );
            }
          }
          return Container();
        })
      ],
    );
  }

  // @ Builds option at index
  _buildOptionWidget(int index) {
    var item = options.elementAt(index);
    return Row(children: [SonrIcon.social(IconType.Normal, item), Padding(padding: EdgeInsets.all(4)), Text(item.toString())]);
  }
}

// ^ Step 2 Connect to the provider API ^ //
class _SetInfoView extends GetView<TileStepperController> {
  _SetInfoView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Column(children: [
        // @ InfoGraph
        _InfoText(index: 2, text: _getInfoText(controller.provider.value)),
        Padding(padding: EdgeInsets.all(20)),
        (controller.getAuthType() == SocialAuthType.Link)
            ? Obx(
                () => SonrTextField(
                    label: _getLabelHintText(controller.provider.value).first,
                    hint: _getLabelHintText(controller.provider.value).last,
                    value: controller.username.value,
                    onChanged: (String value) {
                      controller.username(value);
                    },
                    onEditingComplete: () {
                      controller.nextStep();
                    }),
              )
            : Neumorphic(
                style: NeumorphicStyle(depth: 8, shape: NeumorphicShape.flat),
                margin: EdgeInsets.only(left: 14, right: 14),
                child: Container(width: Get.width - 80, margin: EdgeInsets.only(left: 12, right: 12), child: Container()))
      ]),
    );
  }

  _getInfoText(Contact_SocialTile_Provider provider) {
    // Link Item
    if (provider == Contact_SocialTile_Provider.Medium ||
        provider == Contact_SocialTile_Provider.Spotify ||
        provider == Contact_SocialTile_Provider.YouTube) {
      return "Link your ${provider.toString()}";
    }
    // OAuth Item
    else {
      return "Connect with ${provider.toString()}";
    }
  }

  List<String> _getLabelHintText(Contact_SocialTile_Provider provider) {
    switch (provider) {
      case Contact_SocialTile_Provider.Facebook:
        return ["Profile", "Insert facebook username "];
      case Contact_SocialTile_Provider.Instagram:
        return ["Profile", "Insert instagram username "];
      case Contact_SocialTile_Provider.Medium:
        return ["Account Username", "@prnk28 (Incredible Posts BTW) "];
      case Contact_SocialTile_Provider.Spotify:
        return ["Account Username", "Any public playlist or profile "];
      case Contact_SocialTile_Provider.TikTok:
        return ["Account Username", "Insert TikTok username "];
      case Contact_SocialTile_Provider.Twitter:
        return ["Twitter Handle", "Insert Twitter username "];
      case Contact_SocialTile_Provider.YouTube:
        return ["YouTube Video or Channel", "Insert channel name "];
    }
    return ["N/A", "Not Available"];
  }
}

// ^ Step 3 Set the Social Tile type ^ //
class _SetTypeView extends GetView<TileStepperController> {
  const _SetTypeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // @ InfoGraph
      _InfoText(index: 3, text: "Set your Tile's type"),
      Padding(padding: EdgeInsets.all(20)),

      // @ Toggle Buttons for Widget Size
      Container(
          constraints: BoxConstraints(maxWidth: Get.width - 80),
          height: Get.height - 600,
          width: Get.width,
          child: Obx(() => Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Icon Option
                  AnimatedTileRadio("Link", groupValue: controller.radioGroupValue.value, onChanged: (value) {
                    // Update Group Value
                    controller.radioGroupValue(value);
                    controller.radioGroupValue.refresh();

                    // Set Type
                    var type = Contact_SocialTile_Type.values.firstWhere((p) => p.toString() == value);
                    controller.type(type);
                  }),

                  // Showcase Option
                  AnimatedTileRadio("Post", groupValue: controller.radioGroupValue.value, onChanged: (value) {
                    // Update Group Value
                    controller.radioGroupValue(value);
                    controller.radioGroupValue.refresh();

                    // Set Type
                    var type = Contact_SocialTile_Type.values.firstWhere((p) => p.toString() == value);
                    controller.type(type);
                  }),

                  // Feed Option
                  controller.doesProviderAllowFeed(controller.provider.value)
                      ? AnimatedTileRadio("Feed", groupValue: controller.radioGroupValue.value, onChanged: (value) {
                          // Update Group Value
                          controller.radioGroupValue(value);
                          controller.radioGroupValue.refresh();

                          // Set Type
                          var type = Contact_SocialTile_Type.values.firstWhere((p) => p.toString() == value);
                          controller.type(type);
                        })
                      : Container(),
                ],
              ))),
    ]);
  }
}

// ^ Creates Infographic Text thats used in all Views ^ //
class _InfoText extends StatelessWidget {
  final int index;
  final String text;

  const _InfoText({Key key, @required this.index, @required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: Get.width - 80),
      child: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(padding: EdgeInsets.all(14)),
          Text(index.toString(), style: GoogleFonts.poppins(fontSize: 108, fontWeight: FontWeight.w900, color: Colors.black38)),
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

// ** Tile Creation Controller for Stepper ** //
class TileStepperController extends GetxController {
  // Properties
  final username = "".obs;
  final isPrivate = false.obs;
  final provider = Rx<Contact_SocialTile_Provider>();
  final type = Rx<Contact_SocialTile_Type>();
  final radioGroupValue = "".obs;

  // References
  final step = 0.obs;

  // ^ Start New Tile Creation ^ //
  start() {
    step(1);
  }

  // ^ Add Social Tile Move to Next Step ^ //
  nextStep() async {
    // @ Step 2
    if (step.value == 1) {
      // Move to Next Step
      if (provider.value != null) {
        step(2);
      } else {
        // Display Error Snackbar
        SonrSnack.missing("Select a provider first");
      }
    }
    // @ Step 3
    else if (step.value == 2) {
      // Update State
      if (username.value != "") {
        if (await Get.find<SocialMediaService>().validate(provider.value, username.value)) {
          step(3);
        }
      } else {
        // Display Error Snackbar
        SonrSnack.missing("Add your username or Link your account");
      }
    }
  }

  // ^ Add Social Tile Move to Next Step ^ //
  previousStep() {
    // First Step
    if (step.value == 1) {
      step(1);
    }
    // Step 2
    else if (step.value == 2) {
      step(1);
    }
    // Step 3
    else if (step.value == 3) {
      step(2);
    }
  }

  // ^ Finish and Save new Tile ^ //
  saveTile() {
    // Validate
    if (type.value != null && step.value == 3) {
      // Set Acquired Data
      var position = Contact_SocialTile_Position(index: Get.find<ProfileController>().socials.length - 1);
      var links = Contact_SocialTile_Links(userLink: Get.find<SocialMediaService>().getProfileLink(provider.value, username.value));

      // Create Tile from Values
      var tile = Contact_SocialTile(
        username: username.value,
        isPrivate: isPrivate.value,
        provider: provider.value,
        type: type.value,
        links: links,
        position: position,
      );

      // Save to Profile
      Get.find<ProfileController>().saveSocialTile(tile);
    } else {
      // Display Error Snackbar
      SonrSnack.missing("Pick a Tile Type", isLast: true);
    }
  }

  // ^ Determine Auth Type ^
  getAuthType() {
    if (!isPrivate.value) {
      return SocialAuthType.Link;
    } else {
      // Link Item
      if (provider.value == Contact_SocialTile_Provider.Medium ||
          provider.value == Contact_SocialTile_Provider.Spotify ||
          provider.value == Contact_SocialTile_Provider.YouTube) {
        return SocialAuthType.Link;
      }
      // OAuth Item
      else {
        return SocialAuthType.OAuth;
      }
    }
  }

  // ^ Helper method to judge Privacy^ //
  bool doesProviderAllowVisibility(Contact_SocialTile_Provider provider) {
    return (provider == Contact_SocialTile_Provider.Twitter ||
        provider == Contact_SocialTile_Provider.Spotify ||
        provider == Contact_SocialTile_Provider.TikTok ||
        provider == Contact_SocialTile_Provider.YouTube);
  }

  // ^ Helper to Display Tile Options ^ //
  bool doesProviderAllowFeed(Contact_SocialTile_Provider provider) {
    return (provider == Contact_SocialTile_Provider.Twitter || provider == Contact_SocialTile_Provider.Medium);
  }
}
