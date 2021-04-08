import 'package:sonr_app/theme/theme.dart';
import 'profile.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width,
        height: Get.height,
        margin: SonrStyle.viewMargin,
        child: Neumorphic(
          style: SonrStyle.normal,
          child: AnimatedSlideSwitcher.fade(
            child: _buildView(controller.status.value),
            duration: const Duration(milliseconds: 2500),
          ),
        ));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(ProfileViewStatus status) {
    // Return View
    if (status == ProfileViewStatus.Editing) {
      return EditProfileView(key: ValueKey<ProfileViewStatus>(ProfileViewStatus.Editing));
    } else if (status == ProfileViewStatus.AddingSocial) {
      return AddTileView(key: ValueKey<ProfileViewStatus>(ProfileViewStatus.AddingSocial));
    } else {
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
        ProfileHeaderBar(),

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
