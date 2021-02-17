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
    return Obx(() {
      // Get Details for Step
      var details = _TileStepDetails(controller: controller, step: controller.step.value);
      // Update State
      return AnimatedContainer(
        duration: 250.milliseconds,
        margin: EdgeInsets.symmetric(vertical: details.verticalMarginModifier(), horizontal: 6),
        child: NeumorphicBackground(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          borderRadius: BorderRadius.circular(30),
          backendColor: Colors.transparent,
          child: Neumorphic(
            style: NeumorphicStyle(color: SonrColor.base),
            child: Material(
              color: Colors.transparent,
              child: Column(children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(top: 8, left: 8),
                  child: SonrButton.circle(
                      icon: SonrIcon.close,
                      onPressed: () {
                        controller.reset();
                        Get.back();
                      }),
                ),
                Container(
                  height: Get.height - details.heightModifier(),
                  child: PageView.builder(
                    controller: controller.pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, idx) {
                      if (idx == 0) {
                        return _DropdownAddView();
                      } else if (idx == 1) {
                        return SingleChildScrollView(child: _SetInfoView());
                      } else {
                        return _SetTypeView();
                      }
                    },
                  ),
                ),

                // Bottom Buttons
                Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: details.bottomButtons,
                ),
                Spacer(),
              ]),
            ),
          ),
        ),
      );
    });
  }
}

// ^ Step 1 Select Provider ^ //
class _DropdownAddView extends GetView<TileStepperController> {
  // Build View As Stateless
  @override
  Widget build(BuildContext context) {
    // Initialize List of Options
    var options = <Contact_SocialTile_Provider>[];

    // Iterate through All Options
    Contact_SocialTile_Provider.values.forEach((provider) {
      if (!Get.find<ProfileController>().socials.any((tile) => tile.provider == provider)) {
        options.add(provider);
      }
    });

    // Build View
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: Column(
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
                color: SonrColor.base,
              ),
              margin: EdgeInsets.only(left: 14, right: 14),
              child: Container(
                  width: Get.width - 80,
                  margin: EdgeInsets.only(left: 12, right: 12),

                  // @ ValueBuilder for DropDown
                  child: ValueBuilder<Contact_SocialTile_Provider>(
                    onUpdate: (value) {
                      // Set Provider
                      controller.provider(value);
                      controller.provider.refresh();

                      // Notify Provider Set
                      controller.hasSetProvider(true);
                      controller.hasSetProvider.refresh();
                    },
                    builder: (item, updateFn) {
                      return DropDown<Contact_SocialTile_Provider>(
                        showUnderline: false,
                        isExpanded: true,
                        initialValue: item,
                        items: options,
                        customWidgets: List<Widget>.generate(options.length, (index) => _buildOptionWidget(options, index)),
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
                    SonrText.normal("Is your account Private?", size: 18),

                    // @ Create Check Box
                    ValueBuilder<bool>(
                        initialValue: false,
                        onUpdate: (value) {
                          controller.isPrivate(value);
                        },
                        builder: (isPrivate, updateFn) {
                          return Container(
                            width: 40,
                            height: 40,
                            child: NeumorphicCheckbox(
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              onChanged: updateFn,
                              value: isPrivate,
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
      ),
    );
  }

  // @ Builds option at index
  _buildOptionWidget(List<Contact_SocialTile_Provider> options, int index) {
    var item = options.elementAt(index);
    return Row(children: [SonrIcon.social(IconType.Normal, item), Padding(padding: EdgeInsets.all(4)), Text(item.toString())]);
  }
}

// ^ Step 2 Connect to the provider API ^ //
class _SetInfoView extends GetView<TileStepperController> {
  _SetInfoView();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // @ InfoGraph
        _InfoText(index: 2, text: _getInfoText(controller.provider.value)),
        Padding(padding: EdgeInsets.all(20)),
        (controller.getAuthType() == SocialAuthType.Link)
            ? Obx(
                () => SonrTextField(
                    label: _getLabelHintText(controller.provider.value).first,
                    hint: _getLabelHintText(controller.provider.value).last,
                    autoCorrect: false,
                    // TODO autoFocus: false,
                    value: controller.username.value,
                    onChanged: (String value) {
                      controller.username(value);
                    },
                    onEditingComplete: () {
                      controller.nextStep();
                    }),
              )
            : Container()
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
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
        // @ InfoGraph
        _InfoText(index: 3, text: "Set your Tile's type"),
        Divider(),
        //Padding(padding: EdgeInsets.all(8)),

        // @ Toggle Buttons for Widget Size
        Container(
            height: 85,
            width: Get.width,
            child: Obx(() => Row(
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
      ]),
    );
  }
}

// ^ Creates Infographic Text thats used in all Views ^ //
class _InfoText extends StatelessWidget {
  final int index;
  final String text;

  const _InfoText({Key key, @required this.index, @required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
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
    ]);
  }
}

// ** Tile Creation Controller for Stepper ** //
class TileStepperController extends GetxController {
  // Properties
  final username = "".obs;
  final isPrivate = false.obs;
  final hasSetProvider = false.obs;
  final provider = Rx<Contact_SocialTile_Provider>();
  final type = Rx<Contact_SocialTile_Type>();
  final radioGroupValue = "".obs;

  // References
  final step = 0.obs;
  final pageController = PageController();

  // ^ Add Social Tile Move to Next Step ^ //
  nextStep() async {
    // @ Step 2
    if (step.value == 0) {
      // Move to Next Step
      if (provider.value != null && hasSetProvider.value) {
        step(1);
        pageController.nextPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
      } else {
        // Display Error Snackbar
        SonrSnack.missing("Select a provider first");
      }
    }
    // @ Step 3
    else if (step.value == 1) {
      // Update State
      if (username.value != "") {
        if (await Get.find<SocialMediaService>().validate(provider.value, username.value, isPrivate.value)) {
          step(2);
          pageController.nextPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
          FocusScopeNode currentFocus = FocusScope.of(Get.context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
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
    if (step.value == 0) {
      step(0);
    }
    // Step 2
    else if (step.value == 1) {
      step(0);
      pageController.previousPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
    }
    // Step 3
    else if (step.value == 2) {
      step(1);
      pageController.previousPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
    }
  }

  // ^ Finish and Save new Tile ^ //
  saveTile() {
    // Validate
    if (type.value != null && step.value == 2) {
      // Set Acquired Data
      var position = Contact_SocialTile_Position(index: Get.find<ProfileController>().socials.length);
      var links = Get.find<SocialMediaService>().getLinks(provider.value, username.value);

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
      reset();
      Get.find<ProfileController>().saveSocialTile(tile);
      Get.back(closeOverlays: true);
    } else {
      // Display Error Snackbar
      SonrSnack.missing("Pick a Tile Type", isLast: true);
    }
  }

  // ^ Resets current info ^
  reset() {
    username("");
    isPrivate(false);
    hasSetProvider(false);
    provider(null);
    type(null);
    radioGroupValue("");
    step(0);
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

// ** Returns View Details by Step ** //
class _TileStepDetails {
  final int step;
  final TileStepperController controller;

  _TileStepDetails({@required this.step, @required this.controller});

  // ^ Adjusted Container Height ^
  final kBaseModifier = 260.0;
  double heightModifier({double toolbarModifier}) {
    if (step == 0) {
      return 200 + kBaseModifier;
    } else if (step == 1) {
      return 250 + kBaseModifier;
    } else {
      return 200 + kBaseModifier;
    }
  }

  // ^ Adjusted Container Margin ^
  double verticalMarginModifier() {
    if (step == 0) {
      return 10;
    } else if (step == 1) {
      return 15;
    } else {
      return 10;
    }
  }

  // ^ Presented View by Step ^
  Widget get currentView {
    if (step == 2) {
      return _SetTypeView();
    } else if (controller.step.value == 1) {
      return _SetInfoView();
    } else {
      return _DropdownAddView();
    }
  }

  // ^ Bottom Buttons for View by Step ^
  Widget get bottomButtons {
    //  Step Three: Cancel and Confirm
    if (step == 2) {
      return SonrButton.stadium(
        text: SonrText.semibold("Save"),
        onPressed: controller.saveTile,
        icon: SonrIcon.success,
        margin: EdgeInsets.only(left: 60, right: 80),
      );
    }
    // Step Two: Dual Bottom Buttons, Back and Next
    else if (controller.step.value == 1) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SonrButton.stadium(text: SonrText.semibold("Back"), onPressed: controller.previousStep, icon: SonrIcon.back),
        SonrButton.stadium(
            text: SonrText.semibold("Next"), onPressed: controller.nextStep, icon: SonrIcon.forward, iconPosition: WidgetPosition.Right),
      ]);
    }
    // Step One: Top Cancel Button
    else {
      return SonrButton.stadium(
          text: SonrText.semibold("Next", size: 22),
          onPressed: controller.nextStep,
          icon: SonrIcon.forward,
          margin: EdgeInsets.only(left: 60, right: 80),
          iconPosition: WidgetPosition.Right);
    }
  }
}
