import 'package:sonr_app/modules/card/tile/tile_item.dart';
import 'package:sonr_app/style/style.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => NeumorphicCard(themeData: Get.theme, child: _buildView(controller.status.value)));
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
                      var socialsList = UserService.contact.value.socials.values.toList();
                      return SocialTileItem(socialsList[index], index);
                    },
                    childCount: UserService.contact.value.socials.length,
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
                ProfileAvatarField(),
                Padding(padding: EdgeInsets.all(8)),
                GestureDetector(
                    onLongPress: controller.setEditingMode,
                    child: Obx(() => "${UserService.contact.value.firstName} ${UserService.contact.value.lastName}".h4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
