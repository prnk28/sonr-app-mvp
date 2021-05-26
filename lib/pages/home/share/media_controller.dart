import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaController extends GetxController {
  // Properties
  final gallery = RxList<AssetPathEntity>();
  final currentAlbum = Rx<AssetPathAlbum>(AssetPathAlbum.blank());
  final selectedItems = RxList<AssetEntity>();

  @override
  void onInit() {
    initGallery();
    super.onInit();
  }

  @override
  onClose() {
    super.onClose();
  }

  /// Checks if Provided Index is Current Album
  bool isCurrent(int index) {
    return currentAlbum.value.isIndex(index);
  }

  /// Initializes Gallery
  Future<void> initGallery() async {
    var list = await PhotoManager.getAssetPathList();
    gallery(list.where((e) => e.assetCount > 0).toList());
    var all = gallery.allAlbum();
    if (all != null) {
      currentAlbum(all);
    }
  }

  /// Changes Album to New Album
  Future<void> setAlbum(AssetPathEntity entity) async {
    currentAlbum(gallery.getAlbum(entity));
  }

  /// Adds Item to Selected Items List
  void addItem(AssetEntity item) {
    selectedItems.add(item);
    selectedItems.refresh();
  }

  /// Removes Item from Selected Items List
  void removeItem(AssetEntity item) {
    selectedItems.remove(item);
    selectedItems.refresh();
  }

  /// Confirms Selection
  Future<void> confirmSelection() async {
    var sonrFile = await selectedItems.toSonrFile();
    TransferService.setFile(sonrFile);
  }
}
