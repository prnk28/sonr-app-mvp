import 'package:sonr_app/style/style.dart';

class PayloadSheetView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        decoration: Neumorphic.floating(
          theme: Get.theme,
        ),
        child: Container(height: Height.ratio(0.15), child: _PayloadListItem()));
  }
}

class _PayloadListItem extends StatelessWidget {
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
              child: [UserService.contact.value.firstName.h6, " ".h6, UserService.contact.value.lastName.l].row(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: "Contact Card".p_Grey,
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
              child: TransferService.file.value.prettyName().h6,
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
      if (TransferService.thumbStatus.value == ThumbnailStatus.Loading) {
        return Container(
          height: Height.ratio(0.125),
          width: Height.ratio(0.125),
          decoration: Neumorphic.floating(theme: Get.theme),
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
