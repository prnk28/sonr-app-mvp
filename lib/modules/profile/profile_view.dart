import 'package:sonr_app/modules/common/tile/tile_item.dart';
import 'package:sonr_app/theme/theme.dart';
import 'profile.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        width: Get.width,
        height: Get.height,
        margin: SonrStyle.viewMargin,
        child: Neumorphic(
          style: SonrStyle.normal,
          child: AnimatedSlideSwitcher.fade(
            child: _buildView(controller.status.value),
            duration: const Duration(milliseconds: 2500),
          ),
        )));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(ProfileViewStatus status) {
    // Edit Details View
    if (status == ProfileViewStatus.EditDetails) {
      return EditDetailsView(key: ValueKey<ProfileViewStatus>(ProfileViewStatus.EditDetails));
    }

    // Edit Profile Picture
    else if (status == ProfileViewStatus.AddPicture) {
      return EditPictureView(key: ValueKey<ProfileViewStatus>(ProfileViewStatus.AddPicture));
    }

    // Add Social Tile
    else if (status == ProfileViewStatus.AddSocial) {
      return AddTileView(key: ValueKey<ProfileViewStatus>(ProfileViewStatus.AddSocial));
    }

    // Default View
    else {
      return _DefaultProfileView(key: ValueKey<ProfileViewStatus>(ProfileViewStatus.Viewing));
    }
  }
}

class _DefaultProfileView extends GetView<ProfileController> {
  _DefaultProfileView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: true,
      slivers: [
        // @ Builds Profile Header
        _ProfileHeaderBar(),

        SliverPadding(padding: EdgeInsets.all(14)),

        // @ Builds List of Social Tile
        GetBuilder<ProfileController>(
            id: 'social-grid',
            builder: (_) {
              return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return SocialTileItem(UserService.socials[index], index);
                    },
                    childCount: UserService.socials.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12.0, crossAxisSpacing: 6.0));
            })
      ],
    );
  }
}

class _ProfileHeaderBar extends GetView<ProfileController> {
  // Sliver Attributes
  final bool automaticallyImplyLeading;
  final double expandedHeight;

  const _ProfileHeaderBar({Key key, this.automaticallyImplyLeading, this.expandedHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      flexibleSpace: _ProfileHeaderView(),
      expandedHeight: Get.height / 5,
      title: Container(
          alignment: Alignment.topCenter,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            PlainButton(
              icon: SonrIcon.gradient(Icons.add, FlutterGradientNames.morpheusDen),
              onPressed: controller.setAddTile,
            ),
            PlainButton(
              icon: SonrIcon.more,
              onPressed: controller.setEditingMode,
            ),
          ])),
    );
  }
}

class _ProfileHeaderView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: true,
      background: GestureDetector(
        child: Container(
          height: Get.height / 5, // Same Header Color
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // @ Avatar
              _AvatarField(),
              Padding(padding: EdgeInsets.all(8)),
              GestureDetector(
                  onLongPress: controller.setEditingMode,
                  child: Obx(() =>
                      SonrText.medium(UserService.firstName.value + " " + UserService.lastName.value, color: SonrColor.fromHex("FFFDFA"), size: 24))),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarField extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        controller.setAddPicture();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Neumorphic(
          padding: EdgeInsets.all(10),
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            depth: -10,
          ),
          child: Obx(() => UserService.picture.value != null
              ? Container(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                    backgroundImage: MemoryImage(UserService.picture.value),
                  ),
                )
              : Icon(
                  Icons.insert_emoticon,
                  size: 120,
                  color: SonrColor.Black.withOpacity(0.5),
                )),
        ),
      ),
    );
  }
}
