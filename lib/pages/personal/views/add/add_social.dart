import 'package:sonr_app/pages/personal/controllers/personal_controller.dart';
import 'package:sonr_app/style/style.dart';

/// ** Builds Add Social Form Dialog ** //
class AddTileView extends StatelessWidget {
  AddTileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetX<_SocialAddController>(builder: (controller) {
      // Update State
      return AnimatedContainer(
        duration: 250.milliseconds,
        // margin: EdgeInsets.symmetric(vertical: controller.step.value!.verticalMargin, horizontal: 6),
        child: Material(
          color: Colors.transparent,
          child: Column(children: [
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 8, left: 8),
                child: ActionButton(
                  onPressed: controller.exitToViewing,
                  iconData: SimpleIcons.Close,
                )),
            Container(
              // height: controller.step.value!.height,
              child: PageView.builder(
                controller: controller.pageController,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, idx) {
                  if (idx == 0) {
                    return DropdownAddView();
                  } else if (idx == 1) {
                    return SingleChildScrollView(child: SetInfoView());
                  } else {
                    return SetTypeView();
                  }
                },
              ),
            ),

            // Bottom Buttons
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              // child: controller.step.value!.bottomButtons,
            ),
            Spacer(),
          ]),
        ),
      );
    });
  }
}

/// #### Step 1 Select Provider
class DropdownAddView extends GetView<PersonalController> {
  // Build View As Stateless
  @override
  Widget build(BuildContext context) {
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
          // SonrDropdown.social(
          //   controller.options,
          //   index: controller.dropdownIndex,
          //   width: Get.width - 80,
          //   margin: EdgeInsets.only(left: 12, right: 12),
          // ),

          // @ Public/Private Checker
          // Obx(() => controller.step.value.provider.allowsVisibility
          //     ? SonrCheckbox(onUpdate: (val) => controller.isPrivate(val), label: "Is your account Private?")
          //     : Container())
        ],
      ),
    );
  }
}

/// #### Step 2 Connect to the provider API
class SetInfoView extends GetView<PersonalController> {
  SetInfoView();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        //_InfoText(index: 2, text: controller.step.value!.provider!.infoText),
        // Padding(padding: EdgeInsets.all(20)),
        // (controller.step.value!.provider!.authType == SocialAuthType.Link)
        //     ? Obx(() => SocialUserSearchField(
        //           controller.step.value!.provider,
        //           value: "",
        //           onEditingComplete: (value) => controller.user(value!),
        //         ))
        //     : Container()
      ]),
    );
  }
}

/// #### Step 3 Set the Social Tile type
class SetTypeView extends GetView<PersonalController> {
  const SetTypeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
        // @ InfoGraph
        _InfoText(index: 3, text: "Set your Tile's type"),
        Divider(),
        // @ Toggle Buttons for Widget Size
      ]),
    );
  }
}

/// #### Creates Infographic Text thats used in all Views
class _InfoText extends StatelessWidget {
  final int index;
  final String text;

  const _InfoText({Key? key, required this.index, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(padding: EdgeInsets.all(14)),
      Text(index.toString(),
          style: TextStyle(
              fontFamily: 'Manrope', fontSize: 108, fontWeight: FontWeight.w900, color: Preferences.isDarkMode ? Colors.white38 : Colors.black38)),
      Padding(padding: EdgeInsets.all(8)),
      Expanded(
        child: Text(text,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Preferences.isDarkMode ? Colors.white : AppColor.Black,
            )),
      ),
    ]);
  }
}

class _SocialAddController extends GetxController {
  final pageController = PageController();

  /// Exits from Social View to Viewing
  void exitToViewing() {
    Get.back();
    Get.find<PersonalController>().exitToViewing();
  }

  // // -- Set Privacy -- //
  // isPrivate(bool value) {
  //   step.update((val) {
  //     val!.isPrivate = value;
  //   });
  //   step.refresh();
  // }

  // // -- Set Current Provider -- //
  // provider(int index) {
  //   step.update((val) {
  //     val!.provider = options[index];
  //   });
  //   step.refresh();
  // }

  // // -- Set Tile Type -- //
  // type(Contact_Social_Tile type) {
  //   step.update((val) {
  //     val!.type = type;
  //   });
  //   step.refresh();
  // }

  // // -- Set Social User -- //
  // user(Contact_Social user) {
  //   step.update((val) {
  //     val!.user = user;
  //   });
  //   step.refresh();
  // }

  // /// #### Add Social Tile Move to Next Step
  // nextStep() async {
  //   // @ Step 2
  //   if (step.value!.current == 0) {
  //     if (dropdownIndex.value != -1) {
  //       provider(dropdownIndex.value);
  //       step.update((val) {
  //         val!.current = 1;
  //         pageController.nextPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
  //       });
  //       step.refresh();
  //     } else {
  //       // Display Error Snackbar
  //       SonrSnack.missing("Select a provider first");
  //     }
  //   }
  //   // @ Step 3
  //   else if (step.value!.current == 1) {
  //     // Update State
  //     if (step.value!.hasUser) {
  //       step.update((val) {
  //         val!.current = 2;
  //         pageController.nextPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
  //       });
  //       step.refresh();

  //       FocusScopeNode currentFocus = FocusScope.of(Get.context!);
  //       if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
  //         FocusManager.instance.primaryFocus!.unfocus();
  //       }
  //     }
  //   } else {
  //     // Display Error Snackbar
  //     SonrSnack.missing("Add your username or Link your account");
  //   }
  // }

  // /// #### Add Social Tile Move to Next Step
  // previousStep() {
  //   // Step 2
  //   if (step.value!.current == 1) {
  //     step.update((val) {
  //       val!.current = 0;
  //       pageController.previousPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
  //     });
  //     step.refresh();
  //   }
  //   // Step 3
  //   else if (step.value!.current == 2) {
  //     step.update((val) {
  //       val!.current = 1;
  //       pageController.previousPage(duration: 500.milliseconds, curve: Curves.easeOutBack);
  //     });
  //     step.refresh();
  //   }
  // }

  // /// #### Finish and Save new Tile
  // saveTile() {
  //   // Validate
  //   if (step.value!.hasType && step.value!.current == 2) {
  //     // Create Tile from Values
  //     var tile = Contact_Social(
  //       username: step.value!.user!,
  //       media: step.value!.provider,

  //     );

  //     // Save to Profile
  //     UserService.contact.addSocial(tile);

  //     // Revert Status
  //     status(ProfileViewStatus.Viewing);
  //     reset();
  //   } else {
  //     // Display Error Snackbar
  //     SonrSnack.missing("Pick a Tile Type", isLast: true);
  //   }
  // }

  // /// #### Resets current info
  // reset() {
  //   step(TileStep(nextStep, previousStep, saveTile));
  //   step.refresh();
  // }

  // /// #### Expand a Tile
  // toggleExpand(int index, bool isExpanded) {
  //   focused(FocusedTile(index, isExpanded));
  //   update(['social-grid']);
  // }
}
