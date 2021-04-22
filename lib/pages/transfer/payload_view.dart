import 'package:sonr_app/data/model/model_file.dart';
import 'package:sonr_app/theme/theme.dart';
import 'transfer_controller.dart';

class PayloadView extends GetView<TransferController> {
  const PayloadView();
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: context.widthTransformer(reducedBy: 20),
      height: context.heightTransformer(reducedBy: 60),
      child: Stack(
        children: [
          /// Poistioned Top Right
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(4),
              height: 32,
              width: 86,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.AccentNavy.withOpacity(0.75)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [SonrIcons.Discover.white, Obx(() => " ${controller.directionTitle.value}".h6_White)]),
            ),
          ),

          /// Central Polygon
          Container(
            margin: EdgeInsets.all(24),
            padding: EdgeInsets.only(bottom: 16),
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.5,
              child: Container(
                width: 250,
                height: 250,
                decoration: Neumorph.rainbow(shape: BoxShape.circle),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _BulbViewChild(),
                  ],
                ),
              ),
            ),
          ),

          /// Cancel Button
          Container(
            alignment: Alignment.topLeft,
            child: Opacity(
              opacity: 0.6,
              child: PlainIconButton(
                onPressed: () {},
                icon: SonrIcons.Close.gradient(gradient: SonrGradient.Critical),
              ),
            ),
          ),

          /// Replace Button
          Container(
            alignment: Alignment.topRight,
            child: Opacity(
              opacity: 0.6,
              child: PlainIconButton(
                onPressed: () {},
                icon: SonrIcons.More_Vertical.gradient(gradient: SonrGradient.Secondary),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ^ Builds Hexagon Child View
class _BulbViewChild extends GetView<TransferController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // # Undefined Type
      if (controller.inviteRequest.value.payload == Payload.UNDEFINED) {
        return CircularProgressIndicator();
      }

      // # Check for Media File Type
      else if (controller.inviteRequest.value.payload == Payload.MEDIA) {
        // Image
        if (controller.fileItem.value.mime.type == MIME_Type.image) {
          return _BulbViewThumbnail(item: controller.fileItem.value);
        }

        // Other Media (Video, Audio)
        else {
          return controller.fileItem.value.mime.type.gradient(size: 80);
        }
      }

      // # Other File
      else {
        return controller.inviteRequest.value.payload.gradient(size: 80);
      }
    });
  }
}

// ^ Builds Thumbnail from Future
class _BulbViewThumbnail extends GetView<TransferController> {
  final FileItem item;

  const _BulbViewThumbnail({Key key, @required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: item.isThumbnailReady(),
      initialData: false,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data) {
          // Set Thumbnail
          controller.setThumbnail(item.thumbnail);

          // Return View
          return GestureDetector(
            onTap: () => OpenFile.open(item.path),
            child: Container(
                decoration: Neumorph.indented(),
                width: 140,
                height: 140,
                clipBehavior: Clip.hardEdge,
                child: Image.memory(
                  item.thumbnail,
                  fit: BoxFit.cover,
                )),
          );
        } else {
          return Container(
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
