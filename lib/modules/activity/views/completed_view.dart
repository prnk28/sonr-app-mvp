import 'package:sonr_app/modules/common/fileItem_utils.dart';
import 'package:sonr_app/style.dart';
import '../activity.dart';

/// @ Completed Transfer Popup View
class CompletedPopup extends GetView<ActivityController> {
  final Transfer transfer;
  CompletedPopup({Key? key, required this.transfer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      // Lotte Animation
      LottieFile.Celebrate.lottie(width: Get.width, height: Get.height, repeat: false, fit: BoxFit.fitHeight),

      // Scaffold Box
      AnimatedBounce(direction: BounceDirection.Up, isDisplayed: true, child: _PostTransferItem(transfer: transfer)),
    ]);
  }
}

/// @ TransferCard as List item View
class _PostTransferItem extends StatelessWidget {
  final Transfer transfer;

  const _PostTransferItem({Key? key, required this.transfer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48.0, top: 16.0),
      child: BoxContainer(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 12),
        height: 400,
        child: Column(
          children: [
            // Owner Info
            _PostFileOwnerRow(profile: transfer.owner),

            // File Content
            Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                child: _PostFileContentView(
                  file: transfer.file,
                ),
                height: 237),
            Padding(padding: EdgeInsets.only(top: 8)),
            // Info of Transfer
            Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 8),
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PayloadText(payload: transfer.payload, file: transfer.file),
                  DateText.fromMilliseconds(transfer.received * 1000),
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
                padding: EdgeInsets.all(8),
                child: Container(
                  child: profile.hasPicture()
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(Uint8List.fromList(profile.picture)),
                        )
                      : SonrIcons.User.gradient(size: 24),
                )),
            Padding(child: ProfileSName(profile: profile), padding: EdgeInsets.only(left: 4)),
            Spacer(),
            Padding(
                child: ActionButton(
                  onPressed: () {},
                  iconData: SonrIcons.Statistic,
                ),
                padding: EdgeInsets.only(right: 4)),
            ActionButton(
              onPressed: () {},
              iconData: SonrIcons.Close,
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
        return MetaImageBox(
          metadata: file.single,
          width: Get.width,
        );
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
