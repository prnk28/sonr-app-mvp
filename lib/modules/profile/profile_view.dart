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
          child: CustomScrollView(
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
          )),
    );
  }
}
