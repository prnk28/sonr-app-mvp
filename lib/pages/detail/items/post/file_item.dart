import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/pages/detail/items/post/views.dart';


import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

/// @ TransferCard as List item View
class PostFileItem extends StatelessWidget {
  final TransferCard item;

  const PostFileItem({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48.0, top: 16.0),
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 12),
        height: 400,
        decoration: SonrTheme.cardDecoration,
        child: Column(
          children: [
            // Owner Info
            _PostFileOwnerRow(profile: item.owner),

            // File Content
            Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: _PostFileContentView(
                  file: item.file!,
                ),
                height: 237),

            // Info of Transfer
            Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item.payload.toString().capitalizeFirst!.subheading(color: SonrTheme.textColor, fontSize: 20),
                  item.received.toString().subheading(color: SonrTheme.greyColor, fontSize: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// @ View for Post View owner of File Received
class _PostFileOwnerRow extends StatelessWidget {
  final Profile profile;
  const _PostFileOwnerRow({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.only(top: 8, left: 8),
                decoration: BoxDecoration(color: SonrColor.White, shape: BoxShape.circle, boxShadow: [
                  BoxShadow(offset: Offset(2, 2), blurRadius: 8, color: SonrColor.Black.withOpacity(0.2)),
                ]),
                padding: EdgeInsets.all(4),
                child: Container(
                  child: profile.hasPicture()
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(Uint8List.fromList(profile.picture)),
                        )
                      : SonrIcons.User.gradient(size: 32),
                )),
            Padding(child: profile.sNameText(isDarkMode: UserService.isDarkMode), padding: EdgeInsets.only(left: 4)),
            Spacer(),
            Padding(child: ActionButton(
              onPressed: () {},
              iconData: SonrIcons.Statistic,
            ), padding: EdgeInsets.only(right: 4)),
            ActionButton(
              onPressed: () {},
              iconData: SonrIcons.Menu,
            ),
          ],
        ));
  }
}

/// @ Post Content for File
class _PostFileContentView extends StatelessWidget {
  final SonrFile file;

  const _PostFileContentView({Key? key, required this.file}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // # Check for Media File Type
    if (file.isMedia) {
      // Image
      if (file.single.mime.type == MIME_Type.IMAGE) {
        return MetaImageBox(metadata: file.single, width: 72);
      }

      // Other Media (Video, Audio)
      else {
        return MetaIcon(iconSize: Height.ratio(0.125), metadata: file.single);
      }
    }

    // # Other File
    return MetaIcon(iconSize: Height.ratio(0.125), metadata: file.single);
  }
}
