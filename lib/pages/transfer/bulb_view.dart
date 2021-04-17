import 'package:sonr_app/theme/theme.dart';
import 'transfer_controller.dart';

class BulbView extends GetView<TransferController> {
  const BulbView();
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: context.widthTransformer(reducedBy: 20),
      height: context.heightTransformer(reducedBy: 60),
      child: Stack(
        children: [
          /// Poistioned Top Right
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(4),
            height: 32,
            width: 86,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrPalette.AccentNavy.withOpacity(0.75)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [SonrIcons.Discover.white, Obx(() => " ${controller.directionTitle.value}".h6_White)]),
          ),

          /// Central Polygon
          Container(
            margin: EdgeInsets.all(32),
            alignment: Alignment.center,
            child: ClipPolygon(
              sides: 6,
              rotate: 30,
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: Neumorph.rainbow(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _BulbViewChild(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// Replace Button
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(right: 8),
            child: Opacity(
              opacity: 0.6,
              child: PlainIconButton(
                onPressed: () {},
                icon: SonrIcons.Edit.gradient(gradient: SonrPalette.secondary()),
              ),
            ),
          )
        ],
      ),
    );
  }
}

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
          return SizedBox(
              width: 80,
              height: 80,
              child: controller.fileItem.value.hasThumbnail
                  ? Image.memory(
                      controller.fileItem.value.thumbnail,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey[100], Colors.grey[300]],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ));
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
