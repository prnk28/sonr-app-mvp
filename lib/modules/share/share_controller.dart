import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';
import 'package:photo_manager/photo_manager.dart';

class ShareController extends GetxController {
  // Properties
  final gallery = RxList<AssetPathEntity>();
  final currentAlbum = Rx<AssetPathAlbum>(AssetPathAlbum.blank());
  final selectedItems = RxList<Tuple<AssetEntity, Uint8List>>();
  final hasSelected = false.obs;
  final isPopup = true.obs;

  // References
  final ScrollController tagsScrollController = ScrollController();

  @override
  void onInit() {
    initGallery();
    super.onInit();
  }

  /// Close Share View Reset Items/Status
  reset({bool withClose = true, bool isPopup = true}) {
    selectedItems.clear();
    hasSelected(false);

    if (withClose) {
      Get.back(closeOverlays: true);
    } else {
      this.isPopup(isPopup);
    }
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

  /// Open Camera and Take Picture for Share
  Future<void> chooseCamera() async {
    // Check for Permissions
    if (MobileService.hasCamera.value) {
      TransferService.chooseCamera(withRedirect: isPopup.value);
    }
    // Request Permissions
    else {
      var result = await Get.find<MobileService>().requestCamera();
      result ? TransferService.chooseCamera() : SonrSnack.error("Sonr cannot open Camera without Permissions");
    }
  }

  /// Choose Contact Card for Share
  Future<void> chooseContact() async {
    TransferService.chooseContact(withRedirect: isPopup.value);
  }

  /// Open File Manager and Select File for Share
  Future<void> chooseFile() async {
    // Check Permissions
    if (MobileService.hasGallery.value) {
      await TransferService.chooseFile(withRedirect: isPopup.value);
    } else {
      // Request Permissions
      var status = await Get.find<MobileService>().requestGallery();
      SonrOverlay.back();

      // Check Status
      if (status) {
        await TransferService.chooseFile(withRedirect: isPopup.value);
      } else {
        SonrSnack.error("Cannot pick Media without Permissions");
      }
    }
  }

  /// Adds Item to Selected Items List for Share
  void chooseMediaItem(AssetEntity item, Uint8List thumb) {
    selectedItems.add(Tuple(item, thumb));
    selectedItems.refresh();
    hasSelected(selectedItems.length > 0);
  }

  /// Confirms Selection for Media Items
  Future<void> confirmMediaSelection() async {
    if (hasSelected.value) {
      var sonrFile = await selectedItems.toSonrFile();
      TransferService.setFile(sonrFile, withRedirect: isPopup.value);
    } else {
      SonrSnack.missing("No Files Selected");
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

  /// Removes Item from Selected Items List
  void removeMediaItem(AssetEntity item, Uint8List thumb) {
    selectedItems.remove(Tuple(item, thumb));
    selectedItems.refresh();
    hasSelected(selectedItems.length > 0);
  }
}
