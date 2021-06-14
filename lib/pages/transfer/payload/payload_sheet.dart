import 'package:sonr_app/modules/share/share_controller.dart';
import 'package:sonr_app/style.dart';
import 'edit_popup.dart';

class PayloadSheetView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (TransferService.hasPayload.value) {
        return TransferService.payload.value.isMultipleFiles
            // Build List View
            ? DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.20,
                maxChildSize: 0.5,
                minChildSize: 0.2,
                builder: (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    foregroundDecoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: TransferService.file.value.items.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          return index == 0
                              ? _SonrFileListHeader()
                              : _SonrFileListItem(
                                  item: TransferService.file.value.items[index - 1],
                                  index: index - 1,
                                );
                        }),
                  );
                })
            :
            // Build Single Item
            Container(
                padding: EdgeInsets.all(8),
                decoration: SonrTheme.boxDecoration,
                child: Container(height: Height.ratio(0.15), child: _PayloadSingleItem()));
      } else {
        return Container(
          alignment: Alignment.center,
          height: Height.ratio(0.15),
          margin: EdgeInsets.all(24),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 42, vertical: 24),
              child: ColorButton.primary(
                icon: SonrIcons.Add,
                text: "Add File",
                onPressed: () => AppPage.Share.to(init: ShareController.initAlert),
              )),
        );
      }
    });
  }
}

class _SonrFileListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Height.ratio(0.125),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TransferService.file.value.prettyName().subheading(color: SonrTheme.textColor),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TransferService.file.value.prettySize().light(color: SonrTheme.textColor),
          )
        ],
      ),
    );
  }
}

class _SonrFileListItem extends StatelessWidget {
  final SonrFile_Item item;
  final int index;

  const _SonrFileListItem({Key? key, required this.item, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: SonrTheme.boxDecoration,
      child: Row(children: [
        item.hasThumbnail()
            ? Container(
                height: Height.ratio(0.125),
                width: Height.ratio(0.125),
                decoration: Neumorphic.indented(theme: Get.theme),
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
                child: item.prettyType().subheading(color: SonrTheme.textColor),
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
              SonrOverlay.show(EditPayloadPopup(
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

class _PayloadSingleItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Obx(() => Row(children: [
              _buildLeading(),
              _buildTitle(),
              Container(
                padding: EdgeInsets.only(left: 24),
                alignment: Alignment.topRight,
                child: ActionButton(
                  onPressed: () {
                    AppRoute.popup(EditPayloadPopup(
                      index: 0,
                      item: TransferService.file.value.single,
                    ));
                  },
                  iconData: SonrIcons.MoreVertical,
                ),
              ),
            ])));
  }

  Widget _buildLeading() {
    // # Undefined Type
    if (TransferService.payload.value == Payload.NONE) {
      return CircularProgressIndicator();
    }

    // # Check for Media File Type
    else if (TransferService.payload.value == Payload.MEDIA) {
      return _PayloadItemThumbnail();
    }

    // # Other Types
    else {
      return TransferService.payload.value.gradient(size: Height.ratio(0.125));
    }
  }

  Widget _buildTitle() {
    if (TransferService.payload.value == Payload.CONTACT) {
      // Build Text View
      return Container(
          width: Width.ratio(0.5),
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: [
                UserService.contact.value.firstName.paragraph(color: SonrTheme.textColor),
                " ".paragraph(color: SonrTheme.textColor),
                UserService.contact.value.lastName.light(color: SonrTheme.textColor)
              ].row(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: "Contact Card".paragraph(),
            )
          ]));
    } else if (TransferService.payload.value == Payload.URL) {
      // Build Text View
      return Container(
          width: Width.ratio(0.5),
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TransferService.file.value.prettyName().paragraph(color: SonrTheme.textColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TransferService.file.value.prettySize().paragraph(color: Get.theme.hintColor),
            )
          ]));
    } else {
      // Build Text View
      return Container(
          width: Width.ratio(0.5),
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, right: 8, top: 0, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(padding: const EdgeInsets.only(top: 16.0), child: TransferService.file.value.prettyType().subheading(color: SonrTheme.textColor)),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: TransferService.file.value.prettyName().light(color: Get.theme.hintColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: TransferService.file.value.prettySize().paragraph(color: Get.theme.hintColor),
            )
          ]));
    }
  }
}

/// @ Builds Thumbnail from Future
class _PayloadItemThumbnail extends StatelessWidget {
  const _PayloadItemThumbnail({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Thumbnail Loading
      if (TransferService.thumbStatus.value == ThumbnailStatus.Loading) {
        return Container(
          height: Height.ratio(0.125),
          width: Height.ratio(0.125),
          decoration: SonrTheme.boxDecoration,
          child: CircularProgressIndicator(),
        );
      }

      // Media with Thumbnail
      else if (TransferService.thumbStatus.value == ThumbnailStatus.Complete) {
        return GestureDetector(
          onTap: () => OpenFile.open(TransferService.file.value.single.path),
          child: Container(
              height: Height.ratio(0.125),
              width: Height.ratio(0.125),
              decoration: Neumorphic.indented(theme: Get.theme),
              clipBehavior: Clip.hardEdge,
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
          child: TransferService.file.value.single.mime.type.gradient(size: Height.ratio(0.125)),
        );
      }
    });
  }
}
