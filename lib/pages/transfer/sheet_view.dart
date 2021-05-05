import 'package:sonr_app/theme/theme.dart';
import 'transfer_controller.dart';

class PayloadSheetView extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        decoration: Neumorph.floating(),
        child: Container(decoration: Neumorph.floating(), height: Height.ratio(0.15), child: _PayloadListItem()));
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
                  icon: SonrIcons.MoreVertical.gradient(gradient: SonrGradient.Primary),
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
      // Image
      if (controller.sonrFile.value.singleFile.mime.isImage) {
        return _PayloadItemThumbnail(item: controller.sonrFile.value);
      }

      // Other Media (Video, Audio)
      else {
        return controller.sonrFile.value.singleFile.mime.type.gradient(size: Height.ratio(0.125));
      }
    }

    // # Other File
    else {
      return controller.sonrFile.value.singleFile.mime.type.gradient(size: Height.ratio(0.125));
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
              child: [UserService.firstName.value.h6, " ".h6, UserService.lastName.value.l].row(),
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
              child: controller.sonrFile.value.prettyName().h6,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: controller.sonrFile.value.sizeToString().p_Grey,
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
              child: controller.sonrFile.value.prettyName().h6,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: controller.sonrFile.value.sizeToString().p_Grey,
            )
          ]));
    }
  }
}

// ^ Builds Thumbnail from Future
class _PayloadItemThumbnail extends StatelessWidget {
  final SonrFile item;

  const _PayloadItemThumbnail({Key key, @required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: item.setThumbnail(),
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data) {
          // Return View
          return GestureDetector(
            onTap: () => OpenFile.open(item.singleFile.path),
            child: Container(
                height: Height.ratio(0.125),
                width: Height.ratio(0.125),
                decoration: Neumorph.indented(),
                clipBehavior: Clip.hardEdge,
                child: Image.memory(
                  item.singleFile.thumbnail,
                  fit: BoxFit.cover,
                )),
          );
        } else {
          return Container(
            height: Height.ratio(0.125),
            width: Height.ratio(0.125),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[100], Colors.grey[300]],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          );
        }
      },
    );
  }
}
