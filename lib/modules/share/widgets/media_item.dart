import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/style/style.dart';

class MediaItem extends GetWidget<MediaItemController> {
  final AssetEntity item;

  MediaItem({required this.item});

  @override
  Widget build(BuildContext context) {
    controller.initialize(item);
    return controller.obx(
      (state) => GestureDetector(
        onTap: () => controller.toggleImage(),
        onLongPress: () => controller.open(),
        child: Container(
          alignment: Alignment.center,
          child: Stack(children: [
            // Thumbnail
            Container(
                foregroundDecoration: controller.isSelected.value ? BoxDecoration(color: Colors.black54) : null,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: MemoryImage(state!.thumbnail),
                  fit: BoxFit.fitWidth,
                ))),

            // Video Icon
            item.type == AssetType.video
                ? Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Preferences.isDarkMode ? SonrColor.White.withOpacity(0.75) : SonrColor.Black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(16)),
                      padding: EdgeInsets.all(4),
                      child: SonrIcons.Video.gradient(size: 28, value: SonrGradients.NorseBeauty),
                    ),
                  )
                : Container(),

            // Select Icon
            controller.isSelected.value ? Center(child: SonrIcons.Check.whiteWith(size: 42)) : Container(),
          ]),
        ),
      ),
      onLoading: HourglassIndicator(),
      onError: (_) => item.icon(),
    );
  }
}
