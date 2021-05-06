import 'package:sonr_app/style/style.dart';
import 'profile.dart';
import 'tile/tile_item.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => NeumorphicCard(child: _buildView(controller.status.value)));
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
  _DefaultProfileView({Key? key}) : super(key: key);
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
                      var socialsList = UserService.socials.values.toList();
                      return SocialTileItem(socialsList[index], index);
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
  final bool? automaticallyImplyLeading;
  final double? expandedHeight;

  const _ProfileHeaderBar({Key? key, this.automaticallyImplyLeading, this.expandedHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      expandedHeight: Get.height / 5 + 36,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: GestureDetector(
          child: Container(
            height: Get.height / 5, // Same Header Color
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // @ Avatar
                _ProfileAvatarField(),
                Padding(padding: EdgeInsets.all(8)),
                GestureDetector(
                    onLongPress: controller.setEditingMode, child: Obx(() => "${UserService.firstName.value} ${UserService.lastName.value}".h4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatarField extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (UserService.picture.value!.length > 0) {
        return GestureDetector(
          onLongPress: () async {
            controller.setAddPicture();
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: Neumorphic.indented(shape: BoxShape.circle),
              child: Obx(() => Container(
                    width: 120,
                    height: 120,
                    child: UserService.picture.value!.length > 0
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(UserService.picture.value!),
                          )
                        : SonrIcons.Avatar.greyWith(size: 120),
                  )),
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: () async {
            controller.setAddPicture();
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: Neumorphic.indented(shape: BoxShape.circle),
                child: Container(
                    width: 120,
                    height: 120,
                    child: CircleAvatar(
                      child: SonrAssetIllustration.AddPicture.widget,
                      backgroundColor: Color(0xfff0f6fa).withOpacity(0.8),
                    ))),
          ),
        );
      }
    });
  }
}
