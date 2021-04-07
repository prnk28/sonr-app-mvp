import 'package:sonr_app/theme/theme.dart';
import 'edit_dialog.dart';
import 'tile_item.dart';
import 'profile_controller.dart';
import 'create_tile.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          bottom: 8,
          right: 8,
          child: NeumorphicFloatingActionButton(
              child: SonrIcon.gradient(Icons.add, FlutterGradientNames.morpheusDen),
              style: NeumorphicStyle(intensity: 0.85, depth: 10, shape: NeumorphicShape.convex),
              onPressed: () {
                Get.dialog(CreateTileStepper());
              })),
      Container(
        width: Get.width,
        height: Get.height,
        margin: SonrStyle.viewMargin,
        child: Neumorphic(
            style: SonrStyle.normal,
            child: CustomScrollView(
              slivers: [
                // @ Builds Profile Header
                SonrHeaderBar.sliver(
                    leading: ShapeButton.circle(
                        icon: SonrIcon.close,
                        shape: NeumorphicShape.convex,
                        onPressed: () => Get.back(),
                        intensity: 0.85,
                        shadowLightColor: Colors.lightBlueAccent[100]),
                    action: ShapeButton.circle(
                      shape: NeumorphicShape.convex,
                      icon: SonrIcon.more,
                      onPressed: () => {},
                      intensity: 0.85,
                      shadowLightColor: Colors.lightBlueAccent[100],
                    ),
                    flexibleSpace: ContactHeader()),

                SliverPadding(padding: EdgeInsets.all(14)),

                // @ Builds List of Social Tile
                GetBuilder<ProfileController>(
                    id: 'social-grid',
                    builder: (_) {
                      return SliverGrid(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            return SocialTileItem(UserService.socials[index], index);
                          }),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12.0, crossAxisSpacing: 6.0));
                    })
              ],
            )),
      )
    ]);
  }
}

class ContactHeader extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      titlePadding: EdgeInsets.only(bottom: 24),
      title: _buildTitle(),
      centerTitle: true,
      background: NeumorphicBackground(
        backendColor: Colors.transparent,
        child: ClipPath(
          clipper: OvalBottomBorderClipper(),
          child: Neumorphic(
            style: NeumorphicStyle(color: Colors.lightBlue[100]),
            child: GestureDetector(
              onLongPress: () async {
                print("Launch Color picker to change header");
                HapticFeedback.heavyImpact();
              },
              child: Container(
                height: 285, // Same Header Color
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // @ Avatar
                    _AvatarField(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ^ Builds Flexible SpaceBar Title ^ //
  _buildTitle() {
    return GestureDetector(
        onLongPress: () async => SonrOverlay.edit(
              EditType.NameField,
              EditDialog.nameField(),
            ),
        child:
            Obx(() => SonrText.medium(UserService.firstName.value + " " + UserService.lastName.value, color: SonrColor.fromHex("FFFDFA"), size: 24)));
  }
}

class _AvatarField extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        print("Launch Profile Pic Camera View");
        HapticFeedback.heavyImpact();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Neumorphic(
          padding: EdgeInsets.all(10),
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            depth: -10,
          ),
          child: Icon(
            Icons.insert_emoticon,
            size: 120,
            color: SonrColor.Black.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}
