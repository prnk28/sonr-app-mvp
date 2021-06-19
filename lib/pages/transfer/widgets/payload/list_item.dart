import 'package:sonr_app/pages/transfer/views/popup_view.dart';
import 'package:sonr_app/style.dart';

class SonrFileListItem extends StatelessWidget {
  final SonrFile_Item item;
  final int index;

  const SonrFileListItem({Key? key, required this.item, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      margin: EdgeInsets.all(8),
      child: Row(children: [
        item.hasThumbnail()
            ? Container(
                height: Height.ratio(0.125),
                width: Height.ratio(0.125),
                clipBehavior: Clip.hardEdge,
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
          padding: EdgeInsets.only(left: 24),
          alignment: Alignment.topRight,
          child: ActionButton(
            onPressed: () {
              AppRoute.popup(EditPayloadPopup(
                index: index,
                item: item,
              ));
            },
            iconData: SonrIcons.MoreVertical,
          ),
        ),
      ]),
    );
  }
}
