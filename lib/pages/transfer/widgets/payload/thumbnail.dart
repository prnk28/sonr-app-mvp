import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style.dart';

/// @ Builds Thumbnail from Future
class PayloadItemThumbnail extends StatelessWidget {
  const PayloadItemThumbnail({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final file = TransferController.invite.file;
    final invite = TransferController.invite;
    if (file.single.hasThumbnail()) {
      return GestureDetector(
        onTap: () => OpenFile.open(file.single.path),
        child: BoxContainer(
            clipBehavior: Clip.hardEdge,
            height: Height.ratio(0.125),
            width: Height.ratio(0.125),
            child: Image.memory(
              file.single.thumbnail!,
              fit: BoxFit.cover,
            )),
      );
    }

    // Non Thumbnail Media
    else {
      return Container(
        height: Height.ratio(0.125),
        width: Height.ratio(0.125),
        child: invite.payload.gradient(size: Height.ratio(0.125)),
      );
    }
  }
}
