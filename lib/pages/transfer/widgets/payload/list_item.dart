import 'package:sonr_app/pages/transfer/controllers/transfer_controller.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style.dart';

class SonrFileListHeader extends GetView<ItemController> {
  @override
  Widget build(BuildContext context) {
    final file = TransferController.invite.file;
    return Container(
      decoration: BoxDecoration(color: SonrTheme.foregroundColor, borderRadius: BorderRadius.circular(37)),
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: file.prettyName().subheading(color: SonrTheme.itemColor),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: file.prettySize().light(color: SonrTheme.itemColor),
          )
        ],
      ),
    );
  }
}

class SonrFileListItem extends GetView<ItemController> {
  final SonrFile_Item item;
  final int index;
  final GlobalKey key;

  SonrFileListItem({required this.key, required this.item, required this.index});
  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      child: Row(children: [
        item.hasThumbnail()
            ? Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
                height: Height.ratio(0.125),
                width: Width.ratio(0.3),
                child: Image.memory(
                  Uint8List.fromList(item.thumbBuffer),
                  fit: BoxFit.cover,
                ))
            : item.mime.type.gradient(size: Height.ratio(0.125)),
        // Title
        Container(
            width: Width.ratio(0.5),
            height: Height.ratio(0.15),
            padding: EdgeInsets.only(left: 16, right: 8, bottom: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: item.prettyType().subheading(color: SonrTheme.itemColor),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: item.prettyName().paragraph(color: Get.theme.hintColor),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: item.prettySize().paragraph(color: Get.theme.hintColor),
              )
            ])),
        // Button
        Container(
          key: key,
          alignment: Alignment.topRight,
          child: InfoButton(
            onPressed: () {
              AppRoute.positioned(
                Infolist(options: [
                  InfolistOption("Replace", SonrIcons.Reload, controller.replace),
                  InfolistOption("Remove", SonrIcons.Trash, controller.delete),
                  InfolistOption("Cancel", SonrIcons.Cancel, controller.cancel),
                ]),
                parentKey: key,
              );
            },
          ),
        ),
      ]),
    );
  }
}