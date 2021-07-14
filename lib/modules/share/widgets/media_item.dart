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
      (state) => Obx(() => GestureDetector(
            onTap: () => controller.toggleImage(),
            onLongPress: () => controller.open(),
            child: Container(
              alignment: Alignment.center,
              child: Stack(children: [
                // Thumbnail
                Container(
                  foregroundDecoration: _buildForegroundDecoration(controller.isSelected.value),
                  decoration: _buildThumbnailDecoration(state!.thumbnail),
                ),

                // Video Icon
                _buildVideoIcon(),

                // Select Icon
                _buildSelectedIcon(controller.isSelected.value),
              ]),
            ),
          )),
      onLoading: CircleLoader(),
      onError: (_) => item.icon(),
    );
  }

  Widget _buildVideoIcon() {
    if (item.type == AssetType.video) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: BoxDecoration(
              color: Preferences.isDarkMode ? AppColor.White.withOpacity(0.75) : AppColor.Black.withOpacity(0.75),
              borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.all(4),
          child: SimpleIcons.Video.gradient(size: 28, value: DesignGradients.NorseBeauty),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildSelectedIcon(bool isSelected) {
    if (isSelected) {
      return Center(child: SimpleIcons.Check.whiteWith(size: 42));
    } else {
      return Container();
    }
  }

  Decoration? _buildForegroundDecoration(bool isSelected) {
    if (isSelected) {
      return BoxDecoration(color: Colors.black54);
    } else {
      return null;
    }
  }

  Decoration _buildThumbnailDecoration(Uint8List thumb) {
    return BoxDecoration(
        image: DecorationImage(
      image: MemoryImage(thumb),
      fit: BoxFit.fitWidth,
    ));
  }
}
