export 'views/add/add_social.dart';
export 'personal.dart';
export 'models/options.dart';
export 'models/status.dart';
export 'models/contact_utils.dart';
export 'controllers/personal_controller.dart';
export 'controllers/tile_controller.dart';

import 'package:sonr_app/pages/personal/views/social_search.dart';
import 'package:sonr_app/pages/personal/widgets/tile_item.dart';
import 'package:sonr_app/pages/settings/general/avatar_field.dart';
import 'package:sonr_app/style/style.dart';
import 'models/contact_utils.dart';
import 'models/status.dart';
import 'package:sonr_app/pages/personal/controllers/personal_controller.dart';

class PersonalView extends GetView<PersonalController> {
  PersonalView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _DefaultProfileView(key: ValueKey<PersonalViewStatus>(PersonalViewStatus.Viewing)),
    );
  }
}

class _DefaultProfileView extends GetView<PersonalController> {
  _DefaultProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: true,
      slivers: [
        // @ Builds Profile Header
        SliverToBoxAdapter(child: Center(child: ProfileAvatarField())),
        SliverToBoxAdapter(child: _ProfileContactButtons()),
        SliverToBoxAdapter(child: _ProfileInfoView()),
        SliverPadding(padding: EdgeInsets.all(14)),

        // @ Builds List of Social Tile
        GetBuilder<PersonalController>(
            id: 'social-grid',
            builder: (_) {
              return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var socialsList = ContactService.contact.value.socials.values.toList();
                      return SocialTileItem(socialsList[index], index);
                    },
                    childCount: ContactService.contact.value.socials.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12.0, crossAxisSpacing: 6.0));
            })
      ],
    );
  }
}

class _ProfileInfoView extends GetView<PersonalController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      width: Get.width,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 12)),
          Divider(color: AppTheme.DividerColor, indent: 16, endIndent: 16),
          Padding(padding: EdgeInsets.only(top: 12)),

          // First/Last Name
          ContactService.contact.value.fullName.subheading(color: AppTheme.ItemColor, fontSize: 32),

          // Username
          ContactSName(),
          Padding(padding: EdgeInsets.all(12)),

          // Bio/ LastTweet
          _buildBio(),
        ],
      ),
    );
  }

  Widget _buildBio() {
    if (ContactService.contact.value.hasBio()) {
      return '"${ContactService.contact.value.bio}"'.paragraph();
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
          child: ContactService.contact.value.hasSocialMedia(Contact_Social_Media.Twitter)
              ? Text("Last Tweet")
              : GestureDetector(
                  onTap: () => isLinkingTwitter(true),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [SimpleIcons.Twitter.gradient(size: 32), Padding(padding: EdgeInsets.all(8)), "Tap to Link Twitter".paragraph()],
                    ),
                  ),
                ),
        );
      }
    }, false.obs);
  }
}

class _ProfileContactButtons extends GetView<PersonalController> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 48),
        padding: EdgeInsets.only(top: 24),
        height: 86,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
          ActionButton(
            onPressed: () {},
            iconData: SimpleIcons.Call,
            label: "Call",
          ),
          ActionButton(
            onPressed: () {},
            iconData: SimpleIcons.Message,
            label: "SMS",
          ),
          ActionButton(
            onPressed: () {},
            iconData: SimpleIcons.Video,
            label: "Video",
          ),
          ActionButton(
            onPressed: () {},
            iconData: SimpleIcons.ATSign,
            label: "Me",
          ),
        ]),
      ),
    );
  }
}
