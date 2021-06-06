import 'package:sonr_app/modules/card/contact/tile/tile_item.dart';
import 'package:sonr_app/modules/search/social_search.dart';
import 'package:sonr_app/style/style.dart';
import 'editor/general/fields.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Posthog().screen(screenName: "Contact");
    return Obx(() => NeumorphicCard(themeData: Get.theme, child: _buildView(controller.status.value)));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(ProfileViewStatus status) {
    // Edit Profile Picture
    if (status == ProfileViewStatus.AddPicture || status == ProfileViewStatus.ViewPicture) {
      return EditPictureView(key: ValueKey<ProfileViewStatus>(ProfileViewStatus.AddPicture));
    }

    // Add Social Tile
    else if (status == ProfileViewStatus.AddSocial) {
      return AddTileView(key: ValueKey<ProfileViewStatus>(ProfileViewStatus.AddSocial));
    }

    // TODO: Edit Addresses
    // else if (status == ProfileViewStatus.FieldAddresses) {
    //   return EditNameView(key: ValueKey<ProfileViewStatus>(ProfileViewStatus.FieldName));
    // }

    // TODO: Edit Gender
    // else if (status == ProfileViewStatus.FieldGender) {
    //   return EditNameView(key: ValueKey<ProfileViewStatus>(ProfileViewStatus.FieldName));
    // }

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
        SliverToBoxAdapter(child: _ProfileInfoView()),
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
      leading: PlainIconButton(icon: SonrIcons.Edit.gradient(value: SonrGradient.Tertiary), onPressed: controller.setEditingMode),
      expandedHeight: Get.height / 6 + 16,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: GestureDetector(
          child: Container(
            height: Get.height / 6 + 16, // Same Header Color
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // @ Avatar
                Center(child: ProfileAvatarField()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      width: Get.width,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username
          ["${UserService.contact.value.sName}".subheading(), ".snr/".subheading(color: Get.theme.hintColor)].row(),

          // First/Last Name
          _buildName(),
          Padding(padding: EdgeInsets.all(12)),
          // Bio/ LastTweet
          _buildBio(),
          // TODO: _buildLastTweet(),
        ],
      ),
    );
  }

  Widget _buildName() {
    return GestureDetector(
        onLongPress: controller.setEditingMode,
        child: Obx(
            () => [UserService.contact.value.fullName.paragraph(), _ProfileContactButtons()].row(mainAxisAlignment: MainAxisAlignment.spaceBetween)));
  }

  Widget _buildBio() {
    if (UserService.contact.value.hasBio()) {
      return '"${UserService.contact.value.bio}"'.paragraph();
    }
    return Container();
  }

  // ignore: unused_element
  Widget _buildLastTweet() {
    return ObxValue<RxBool>((isLinkingTwitter) {
      if (isLinkingTwitter.value) {
        return SocialUserSearchField.twitter(value: "");
      } else {
        return Container(
          width: Get.width,
          height: 72,
          decoration: Neumorphic.indented(theme: Get.theme),
          child: UserService.contact.value.hasSocialMedia(Contact_Social_Media.Twitter)
              ? Text("Last Tweet")
              : GestureDetector(
                  onTap: () => isLinkingTwitter(true),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [SonrIcons.Twitter.gradient(size: 32), Padding(padding: EdgeInsets.all(8)), "Tap to Link Twitter".paragraph()],
                    ),
                  ),
                ),
        );
      }
    }, false.obs);
  }
}

class _ProfileContactButtons extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        PlainIconButton(onPressed: () {}, icon: SonrIcons.Call.gradient(value: SonrGradient.Secondary, size: 22)),
        Padding(padding: EdgeInsets.only(right: 4)),
        PlainIconButton(onPressed: () {}, icon: SonrIcons.Message.gradient(value: SonrGradient.Secondary, size: 22)),
        Padding(padding: EdgeInsets.only(right: 4)),
        PlainIconButton(onPressed: () {}, icon: SonrIcons.Video.gradient(value: SonrGradient.Secondary, size: 22)),
        Padding(padding: EdgeInsets.only(right: 4)),
        PlainIconButton(onPressed: () {}, icon: SonrIcons.ATSign.gradient(value: SonrGradient.Secondary, size: 22)),
      ]),
    );
  }
}
