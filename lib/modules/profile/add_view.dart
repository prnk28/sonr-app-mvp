import 'profile.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_social.dart';

// ** Builds Add Social Form Dialog ** //
class AddTileView extends GetView<ProfileController> {
  AddTileView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Update State
      return AnimatedContainer(
        duration: 250.milliseconds,
        margin: EdgeInsets.symmetric(vertical: controller.step.value.verticalMargin, horizontal: 6),
        child: Material(
          color: Colors.transparent,
          child: Column(children: [
            Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 8, left: 8),
                child: ShapeButton.rectangle(
                    radius: 20,
                    shape: NeumorphicShape.convex,
                    onPressed: controller.exitAddTile,
                    icon: SonrIcon.neumorphicGradient(Icons.close, FlutterGradientNames.phoenixStart, size: 38, style: SonrStyle.appBarIcon))),
            Container(
              height: controller.step.value.height,
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
              child: controller.step.value.bottomButtons,
            ),
            Spacer(),
          ]),
        ),
      );
    });
  }
}

// ^ Step 1 Select Provider ^ //
class DropdownAddView extends GetView<ProfileController> {
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
          SonrDropdown.social(
            controller.options,
            index: controller.dropdownIndex,
            width: Get.width - 80,
            margin: EdgeInsets.only(left: 12, right: 12),
          ),

          // @ Public/Private Checker
          Obx(() => controller.step.value.provider.allowsVisibility
              ? SonrCheckbox(onUpdate: (val) => controller.isPrivate(val), label: "Is your account Private?")
              : Container())
        ],
      ),
    );
  }
}

// ^ Step 2 Connect to the provider API ^ //
class SetInfoView extends GetView<ProfileController> {
  SetInfoView();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _InfoText(index: 2, text: controller.step.value.provider.infoText),
        Padding(padding: EdgeInsets.all(20)),
        (controller.step.value.provider.authType == SocialAuthType.Link)
            ? Obx(() => SocialUserSearchField(
                  controller.step.value.provider,
                  value: "",
                  onEditingComplete: (value) => controller.user(value),
                ))
            : Container()
      ]),
    );
  }
}

// ^ Step 3 Set the Social Tile type ^ //
class SetTypeView extends GetView<ProfileController> {
  const SetTypeView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
        // @ InfoGraph
        _InfoText(index: 3, text: "Set your Tile's type"),
        Divider(),
        // @ Toggle Buttons for Widget Size
        SonrRadio(
            options: [
              SonrRadioRowOption.animated(RiveBoard.Icon, "Link"),
              SonrRadioRowOption.animated(RiveBoard.Gallery, "Post"),
              SonrRadioRowOption.animated(RiveBoard.Feed, "Feed"),
            ],
            onUpdated: (int index, String title) {
              var type = Contact_SocialTile_Type.values.firstWhere((p) => p.toString() == title);
              controller.type(type);
            }),
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
      Text(index.toString(),
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 108, fontWeight: FontWeight.w900, color: UserService.isDarkMode ? Colors.white38 : Colors.black38)),
      Padding(padding: EdgeInsets.all(8)),
      Expanded(
        child: Text(text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: UserService.isDarkMode ? Colors.white : SonrColor.Black,
            )),
      ),
    ]);
  }
}
