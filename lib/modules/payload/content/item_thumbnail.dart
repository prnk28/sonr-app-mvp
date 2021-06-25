import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style/style.dart';

/// ### Builds Thumbnail from Future
class PayloadThumbnail extends StatelessWidget {
  final SonrFile_Item? item;
  const PayloadThumbnail({Key? key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleOnTap(),
      child: BoxContainer(
        clipBehavior: Clip.hardEdge,
        height: Height.ratio(0.125),
        width: Height.ratio(0.125),
        child: item != null ? _buildItemChild(item!) : _buildSingleChild(),
      ),
    );
  }

  Widget _buildItemChild(SonrFile_Item item) {
    if (item.hasThumbnail()) {
      return Image.memory(
        Uint8List.fromList(item.thumbBuffer),
        fit: BoxFit.cover,
      );
    } else {
      return item.mime.type.gradient(
        size: Height.ratio(0.125),
      );
    }
  }

  Widget _buildSingleChild() {
    final invite = TransferController.invite;
    if (invite.file.single.hasThumbnail()) {
      return Image.memory(
        invite.file.single.thumbnail!,
        fit: BoxFit.cover,
      );
    } else {
      return invite.payload.gradient(
        size: Height.ratio(0.125),
      );
    }
  }

  void _handleOnTap() {
    if (item != null) {
      OpenFile.open(item!.path);
    } else {
      if (TransferController.invite.payload.isTransfer) {
        OpenFile.open(TransferController.invite.file.single.path);
      }
    }
  }
}
