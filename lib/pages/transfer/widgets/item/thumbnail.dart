import 'package:sonr_app/style.dart';

/// @ Builds Thumbnail from Future
class PayloadItemThumbnail extends StatelessWidget {
  const PayloadItemThumbnail({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (TransferService.thumbStatus.value == ThumbnailStatus.Complete) {
      return GestureDetector(
        onTap: () => OpenFile.open(TransferService.file.value.single.path),
        child: BoxContainer(
            clipBehavior: Clip.hardEdge,
            height: Height.ratio(0.125),
            width: Height.ratio(0.125),
            child: Image.memory(
              TransferService.file.value.single.thumbnail!,
              fit: BoxFit.cover,
            )),
      );
    }

    // Non Thumbnail Media
    else {
      return Container(
        height: Height.ratio(0.125),
        width: Height.ratio(0.125),
        child: TransferService.payload.value.gradient(size: Height.ratio(0.125)),
      );
    }
  }
}
