import 'package:sonr_app/modules/common/tile/tile_item.dart';
import 'package:sonr_app/theme/form/theme.dart';
import 'profile.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        width: Get.width,
        height: Get.height,
        margin: SonrStyle.viewMargin,
        decoration: Neumorph.floating(radius: 20),
        child: AnimatedSlideSwitcher.fade(
          child: _buildView(controller.status.value),
          duration: const Duration(milliseconds: 2500),
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
      expandedHeight: Get.height / 5 + 36,
      title: Container(
          alignment: Alignment.topCenter,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            PlainIconButton(
              icon: SonrIcons.Add.gradient(gradient: SonrPalette.primary(), size: 36),
              onPressed: controller.setAddTile,
            ),
            PlainIconButton(
              icon: SonrIcons.More_Vertical.gradient(gradient: SonrPalette.secondary(), size: 36),
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
                  onLongPress: controller.setEditingMode, child: Obx(() => "${UserService.firstName.value} ${UserService.lastName.value}".h4)),
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
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: Neumorph.indented(shape: BoxShape.circle),
          child: Obx(() => Container(
                width: 120,
                height: 120,
                child: UserService.picture.value.length > 0
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(UserService.picture.value),
                      )
                    : SonrIcons.Avatar.greyWith(size: 120),
              )),
        ),
      ),
    );
  }
}
