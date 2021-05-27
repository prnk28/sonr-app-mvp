import 'package:sonr_app/style/style.dart';

class PayloadSheetView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (TransferService.sharedItem.value.isSingleItem) {
        return Container(
            padding: EdgeInsets.all(8),
            decoration: Neumorphic.floating(
              theme: Get.theme,
            ),
            child: Container(height: Height.ratio(0.15), child: _PayloadSingleItem()));
      } else if (TransferService.sharedItem.value.isMultiItems) {
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.20,
            maxChildSize: 0.5,
            minChildSize: 0.2,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: TransferService.file.value.items.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      return index == 0 ? _SonrFileListHeader() : _SonrFileListItem(item: TransferService.file.value.items[index - 1]);
                    }),
              );
            });
      }
      return Container();
    });
  }
}

class _SonrFileListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: SonrColor.AccentBlue.withOpacity(0.10),
      width: Get.width,
      height: Height.ratio(0.125),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TransferService.file.value.prettyName().h4,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TransferService.file.value.prettySize().h5,
          )
        ],
      ),
    );
  }
}

class _SonrFileListItem extends StatelessWidget {
  final SonrFile_Item item;

  const _SonrFileListItem({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: Neumorphic.floating(
        theme: Get.theme,
      ),
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
            padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: item.prettyType().h6,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: item.prettyName().p_Grey,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: item.prettySize().p_Grey,
              )
            ])),
        // Button
        Container(
          padding: EdgeInsets.only(left: 8),
          alignment: Alignment.topRight,
          child: PlainIconButton(
            onPressed: () {},
            icon: SonrIcons.MoreVertical.gradient(value: SonrGradient.Primary),
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
                padding: EdgeInsets.only(left: 8),
                alignment: Alignment.topRight,
                child: PlainIconButton(
                  onPressed: () {},
                  icon: SonrIcons.MoreVertical.gradient(value: SonrGradient.Primary),
                ),
              ),
            ])));
  }

  Widget _buildLeading() {
    // # Undefined Type
    if (!TransferService.sharedItem.value.exists) {
      return CircularProgressIndicator();
    }

    // # Check for Media File Type
    else if (TransferService.sharedItem.value.isMedia) {
      return _PayloadItemThumbnail();
    }

    // # Other Types
    else {
      return TransferService.sharedItem.value.payload.gradient(size: Height.ratio(0.125));
    }
  }

  Widget _buildTitle() {
    if (TransferService.sharedItem.value.isContact) {
      // Build Text View
      return Container(
          width: Width.ratio(0.5),
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: [UserService.contact.value.firstName.h6, " ".h6, UserService.contact.value.lastName.l].row(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: "Contact Card".p_Grey,
            )
          ]));
    } else if (TransferService.sharedItem.value.isUrl) {
      // Build Text View
      return Container(
          width: Width.ratio(0.5),
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TransferService.file.value.prettyName().h6,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TransferService.file.value.prettySize().p_Grey,
            )
          ]));
    } else {
      // Build Text View
      return Container(
          width: Width.ratio(0.5),
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TransferService.file.value.prettyType().h6,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TransferService.file.value.prettyName().p_Grey,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TransferService.file.value.prettySize().p_Grey,
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
      if (TransferService.sharedItem.value.thumbStatus == ThumbnailStatus.Loading) {
        return Container(
          height: Height.ratio(0.125),
          width: Height.ratio(0.125),
          decoration: Neumorphic.floating(theme: Get.theme),
          child: CircularProgressIndicator(),
        );
      }

      // Media with Thumbnail
      else if (TransferService.sharedItem.value.thumbStatus == ThumbnailStatus.Complete) {
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
