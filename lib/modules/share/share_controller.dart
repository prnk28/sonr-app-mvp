import 'package:get/get.dart';
import 'package:sonr_app/style.dart';
import 'package:photo_manager/photo_manager.dart';

enum ShareViewType {
  /// For Default State
  None,

  /// For when ShareView Presented from Home Screen.
  Popup,

  /// For when ShareView Presented from Transfer Screen
  Dialog
}

extension ShareViewTypeUtils on ShareViewType {
  /// Checks for Popup Type - Popup is for when in HomeScreen
  bool get isViewPopup => this == ShareViewType.Popup;

  /// Checks for Dialog Type - Dialog is for when in TransferScreen
  bool get isViewDialog => this == ShareViewType.Dialog;
}

class ShareController extends GetxController {
  // Properties
  final gallery = RxList<AssetPathEntity>();
  final currentAlbum = Rx<AssetPathAlbum>(AssetPathAlbum.blank());
  final selectedItems = RxList<Tuple<AssetEntity, Uint8List>>();
  final hasSelected = false.obs;

  final type = ShareViewType.None.obs;

  // References
  final ScrollController tagsScrollController = ScrollController();

  @override
  void onInit() {
    initGallery();
    super.onInit();
  }

  /// Initializes Controller for Popup - Popup is for when in HomeScreen
  static void initPopup() {
    Get.find<ShareController>().type(ShareViewType.Popup);
  }

  /// Initializes Controller for Dialog - Dialog is for when in TransferScreen
  static void initDialog() {
    Get.find<ShareController>().type(ShareViewType.Dialog);
  }

  /// Closes Current Window
  void close() {
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

  /// Open Camera and Take Picture for Share
  Future<void> chooseCamera() async {
    // Check for Permissions
    if (MobileService.hasCamera.value) {
      // Check Done
      var done = await TransferService.chooseCamera();
      _handleConfirmation(done);
    }
    // Request Permissions
    else {
      var result = await Get.find<MobileService>().requestCamera();
      if (result) {
        // Check Done
        var done = await TransferService.chooseCamera();
        _handleConfirmation(done);
      } else {
        Snack.error("Sonr cannot open Camera without Permissions");
      }
    }
  }

  /// Choose Contact Card for Share
  Future<void> chooseContact() async {
    var done = await TransferService.chooseContact();
    _handleConfirmation(done);
  }

  /// Open File Manager and Select File for Share
  Future<void> chooseFile() async {
    // Check Permissions
    if (MobileService.hasGallery.value) {
      var done = await TransferService.chooseFile();
      _handleConfirmation(done);
    } else {
      // Request Permissions
      var status = await Get.find<MobileService>().requestGallery();
      SonrOverlay.back();

      // Check Status
      if (status) {
        var done = await TransferService.chooseFile();
        _handleConfirmation(done);
      } else {
        Snack.error("Cannot pick Media without Permissions");
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
      var done = await TransferService.setFile(sonrFile);
      _handleConfirmation(done);
    } else {
      Snack.missing("No Files Selected");
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

  void _handleConfirmation(bool result) {
    // Check Result Success
    if (result) {
      // Reset Share Items
      selectedItems.clear();
      hasSelected(false);

      // Check View Type
      if (this.type.value.isViewPopup) {
        AppPage.Transfer.offNamed();
      } else {
        Get.back(closeOverlays: true);
      }
    }
  }
}
