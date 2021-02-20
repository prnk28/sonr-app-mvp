import 'package:rive/rive.dart';
import 'package:sonr_app/modules/profile/profile_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/service/constant_service.dart';

// ** Builds Add Social Form Dialog ** //
class CreateTileStepper extends GetView<ProfileController> {
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
class _DropdownAddView extends GetView<ProfileController> {
  // Build View As Stateless
  @override
  Widget build(BuildContext context) {
    // Build View
    var options = SocialMediaService.options;

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
          SonrDropdown.social(
            options,
            onChanged: (index) {
              // Set Provider
              controller.provider(options[index]);
              controller.provider.refresh();

              // Notify Provider Set
              controller.hasSetProvider(true);
              controller.hasSetProvider.refresh();
            },
            width: Get.width - 80,
            margin: EdgeInsets.only(left: 12, right: 12),
          ),
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
}

// ^ Step 2 Connect to the provider API ^ //
class _SetInfoView extends GetView<ProfileController> {
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
class _SetTypeView extends GetView<ProfileController> {
  const _SetTypeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
        // @ InfoGraph
        _InfoText(index: 3, text: "Set your Tile's type"),
        Divider(),
        // @ Toggle Buttons for Widget Size
        Container(
            height: 85,
            width: Get.width,
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Icon Option
                    SonrAnimatedRadioItem(ArtboardType.Icon, "Link", groupValue: controller.radioGroupValue.value, onChanged: (value) {
                      // Update Group Value
                      controller.radioGroupValue(value);
                      controller.radioGroupValue.refresh();

                      // Set Type
                      var type = Contact_SocialTile_Type.values.firstWhere((p) => p.toString() == value);
                      controller.type(type);
                    }),

                    // Showcase Option
                    SonrAnimatedRadioItem(ArtboardType.Gallery, "Post", groupValue: controller.radioGroupValue.value, onChanged: (value) {
                      // Update Group Value
                      controller.radioGroupValue(value);
                      controller.radioGroupValue.refresh();

                      // Set Type
                      var type = Contact_SocialTile_Type.values.firstWhere((p) => p.toString() == value);
                      controller.type(type);
                    }),

                    // Feed Option
                    controller.doesProviderAllowFeed(controller.provider.value)
                        ? SonrAnimatedRadioItem(ArtboardType.Feed, "Feed", groupValue: controller.radioGroupValue.value, onChanged: (value) {
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

// ** Returns View Details by Step ** //
class _TileStepDetails {
  final int step;
  final ProfileController controller;

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
