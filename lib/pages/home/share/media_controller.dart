import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaController extends GetxController {
  // Properties
  final gallery = RxList<AssetPathEntity>();
  final currentAlbum = Rx<AssetPathAlbum>(AssetPathAlbum.blank());
  final selectedItems = RxList<Tuple<AssetEntity, Uint8List>>();
  final hasSelected = false.obs;

  final ScrollController tagsScrollController = ScrollController();

  @override
  void onInit() {
    initGallery();
    super.onInit();
  }

  close() {
    selectedItems.clear();
    hasSelected(false);
    Get.back(closeOverlays: true);
  }

  /// Checks if Provided Index is Current Album
  bool isCurrent(int index) {
    return currentAlbum.value.isIndex(index);
  }

  /// Initializes Gallery
  Future<void> initGallery() async {
    var list = await PhotoManager.getAssetPathList();
    gallery(list.where((e) => e.assetCount > 0 && e.name.isNotEmpty).toList());
    var all = await gallery.allAlbum();
    if (all != null) {
      currentAlbum(all);
    }
  }

  /// Changes Album to New Album
  Future<void> setAlbum(int index) async {
    currentAlbum(await AssetPathAlbum.init(index, gallery[index]));
    currentAlbum.refresh();
    tagsScrollController.animateTo(currentAlbum.value.index * 40, duration: 100.milliseconds, curve: Curves.easeIn);
  }

  /// Changes Album to Previous Album
  Future<void> shiftPrevAlbum() async {
    if (currentAlbum.value.index > 0) {
      var newIndex = currentAlbum.value.index - 1;
      currentAlbum(await AssetPathAlbum.init(newIndex, gallery[newIndex]));
    } else {
      currentAlbum(await AssetPathAlbum.init(0, gallery[0]));
    }
    currentAlbum.refresh();
    tagsScrollController.animateTo(currentAlbum.value.index * currentAlbum.value.nameOffset, duration: 100.milliseconds, curve: Curves.easeIn);
  }

  /// Changes Album to Previous Album
  Future<void> shiftNextAlbum() async {
    if (currentAlbum.value.index < gallery.length - 1) {
      var newIndex = currentAlbum.value.index + 1;
      currentAlbum(await AssetPathAlbum.init(newIndex, gallery[newIndex]));
    } else {
      currentAlbum(await AssetPathAlbum.init(gallery.length - 1, gallery[gallery.length - 1]));
    }
    currentAlbum.refresh();
    tagsScrollController.animateTo(currentAlbum.value.index * 40, duration: 100.milliseconds, curve: Curves.easeIn);
  }

  /// Adds Item to Selected Items List
  void addItem(AssetEntity item, Uint8List thumb) {
    selectedItems.add(Tuple(item, thumb));
    selectedItems.refresh();
    hasSelected(selectedItems.length > 0);
  }

  /// Removes Item from Selected Items List
  void removeItem(AssetEntity item, Uint8List thumb) {
    selectedItems.remove(Tuple(item, thumb));
    selectedItems.refresh();
    hasSelected(selectedItems.length > 0);
  }

  /// Confirms Selection
  Future<void> confirmSelection() async {
    if (hasSelected.value) {
      var sonrFile = await selectedItems.toSonrFile();
      TransferService.setFile(sonrFile);
    } else {
      SonrSnack.missing("No Files Selected");
    }
  }
}
