
import 'package:sonr_app/modules/search/social_search.dart';
import 'package:sonr_app/pages/detail/items/contact/tile/tile_item.dart';
import 'package:sonr_app/style.dart';
import 'editor/general/fields.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        decoration: SonrTheme.cardDecoration, padding: EdgeInsets.all(8), margin: EdgeInsets.only(left:24, right: 24, bottom: 56), child: _buildView(controller.status.value)));
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
        SliverToBoxAdapter(child:Center(child: ProfileAvatarField())),
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

class _ProfileInfoView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      padding: EdgeInsets.only(top: 8),
      width: Get.width,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                    // First/Last Name
  UserService.contact.value.fullName.subheading(color: SonrTheme.textColor),

          // Username
          ["${UserService.contact.value.sName}".light(color: SonrTheme.textColor), ".snr/".light(color: SonrTheme.greyColor),
          Spacer(), _ProfileContactButtons(),].row(),


          Padding(padding: EdgeInsets.all(12)),
          // Bio/ LastTweet
          _buildBio(),
          // TODO: _buildLastTweet(),
        ],
      ),
    );
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
