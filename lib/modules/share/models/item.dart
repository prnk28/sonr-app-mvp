import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/style/style.dart';

class MediaItemController extends GetxController with StateMixin<MediaItemData> {
  late AssetEntity _asset;
  late Uint8List? _thumbnail;
  final isSelected = false.obs;

  /// Sets Default Initial State
  @override
  onInit() {
    this.change(null, status: RxStatus.loading());
    super.onInit();
  }

  /// Initialize AssetEntity Item
  Future<void> initialize(AssetEntity item) async {
    // Get Thumbnail
    final thumb = await item.thumbData;
    isSelected(Get.find<ShareController>().isSelected(item));

    // Set References
    _asset = item;
    _thumbnail = thumb;

    // Check Thumbnail
    if (thumb != null) {
      final data = MediaItemData(item, thumb);
      this.change(data, status: RxStatus.success());
    } else {
      this.change(null, status: RxStatus.error());
    }
  }

  /// Open Asset Entity
  Future<void> open() async {
    var file = await _asset.file;
    if (file != null) {
      OpenFile.open(file.path);
    }
  }

  void toggleImage() {
    isSelected(!isSelected.value);
    if (isSelected.value) {
      Get.find<ShareController>().chooseMediaItem(_asset, _thumbnail!);
    } else {
      Get.find<ShareController>().removeMediaItem(_asset);
    }
  }
}

/// Media Item Data Class
class MediaItemData {
  final AssetEntity item;
  final Uint8List thumbnail;
  MediaItemData(this.item, this.thumbnail);
}
