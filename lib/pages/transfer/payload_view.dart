import 'package:sonr_app/style/style.dart';
import 'transfer_controller.dart';

class PayloadSheetView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        decoration: Neumorphic.floating(),
        child: Container(decoration: Neumorphic.floating(), height: Height.ratio(0.15), child: _PayloadListItem()));
  }
}

class _PayloadListItem extends GetView<TransferController> {
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
    if (controller.inviteRequest.value.payload == Payload.NONE) {
      return CircularProgressIndicator();
    }

    // # Check for Media File Type
    else if (controller.inviteRequest.value.payload == Payload.MEDIA) {
      return _PayloadItemThumbnail();
    }

    // # Other Types
    else {
      return controller.inviteRequest.value.payload.gradient(size: Height.ratio(0.125));
    }
  }

  Widget _buildTitle() {
    if (controller.inviteRequest.value.payload == Payload.CONTACT) {
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
    } else if (controller.inviteRequest.value.payload == Payload.URL) {
      // Build Text View
      return Container(
          width: Width.ratio(0.5),
          height: Height.ratio(0.15),
          padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: controller.sonrFile.value!.prettyName().h6,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: controller.sonrFile.value!.sizeToString().p_Grey,
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
              child: controller.sonrFile.value!.prettyName().h6,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: controller.sonrFile.value!.sizeToString().p_Grey,
            )
          ]));
    }
  }
}

// ^ Builds Thumbnail from Future
class _PayloadItemThumbnail extends GetView<TransferController> {
  const _PayloadItemThumbnail({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Thumbnail Loading
      if (controller.thumbStatus.value == ThumbnailStatus.Loading) {
        return Container(
          height: Height.ratio(0.125),
          width: Height.ratio(0.125),
          decoration: Neumorphic.compact(),
          child: CircularProgressIndicator(),
        );
      }

      // Media with Thumbnail
      else if (controller.thumbStatus.value == ThumbnailStatus.Complete) {
        return GestureDetector(
          onTap: () => OpenFile.open(controller.sonrFile.value!.single.path),
          child: Container(
              height: Height.ratio(0.125),
              width: Height.ratio(0.125),
              decoration: Neumorphic.indented(),
              clipBehavior: Clip.hardEdge,
              child: Image.memory(
                Uint8List.fromList(controller.sonrFile.value!.single.thumbnail),
                fit: BoxFit.cover,
              )),
        );
      }

      // Non Thumbnail Media
      else {
        return Container(
          height: Height.ratio(0.125),
          width: Height.ratio(0.125),
          child: controller.sonrFile.value!.single.mime.type.gradient(size: Height.ratio(0.125)),
        );
      }
    });
  }
}
