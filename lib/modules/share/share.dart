// Exports
export 'models/type.dart';
export 'views/button_view.dart';
export 'views/external_sheet.dart';
export 'views/share_view.dart';

// Imports
import 'package:get/get.dart';
import 'package:sonr_app/pages/transfer/models/arguments.dart';
import 'package:sonr_app/service/transfer/sender.dart';
import 'package:sonr_app/style.dart';
import 'package:photo_manager/photo_manager.dart';
import 'models/log.dart';
import 'models/type.dart';

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
  static void initAlert() {
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
      var done = await SenderService.choose(ChooseOption.Camera);
      _handleConfirmation(done);
    }
    // Request Permissions
    else {
      var result = await Get.find<MobileService>().requestCamera();
      if (result) {
        // Check Done
        var done = await SenderService.choose(ChooseOption.Camera);
        _handleConfirmation(done);
      } else {
        AppRoute.snack(SnackArgs.error("Sonr cannot open Camera without Permissions"));
      }
    }
  }

  /// Choose Contact Card for Share
  Future<void> chooseContact() async {
    var done = await SenderService.choose(ChooseOption.Contact);
    _handleConfirmation(done);
  }

  /// Open File Manager and Select File for Share
  Future<void> chooseFile() async {
    // Check Permissions
    if (MobileService.hasGallery.value) {
      var done = await SenderService.choose(ChooseOption.File);
      _handleConfirmation(done);
    } else {
      // Request Permissions
      var status = await Get.find<MobileService>().requestGallery();

      // Check Status
      if (status) {
        var done = await SenderService.choose(ChooseOption.File);
        _handleConfirmation(done);
      } else {
        AppRoute.snack(SnackArgs.error("Cannot pick Media without Permissions"));
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
      var result = await SenderService.choose(ChooseOption.Media, file: sonrFile);
      _handleConfirmation(result);
    } else {
      AppRoute.snack(SnackArgs.missing("No Files Selected"));
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

  void _handleConfirmation(InviteRequest? request) {
    // Check Result Success
    if (request != null) {
      // Reset Share Items
      selectedItems.clear();
      hasSelected(false);

      // Check View Type
      if (this.type.value.isViewPopup) {
        AppPage.Transfer.off(args: TransferArguments(request));
      } else {
        Get.back(closeOverlays: true);
      }
    }
  }
}

/// Button that opens share View
class ShareButton extends StatelessWidget {
  ShareButton() : super(key: GlobalKey());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: ObxValue<RxBool>(
          (isPressed) => AnimatedScale(
              duration: Duration(milliseconds: 150),
              scale: isPressed.value ? 1.1 : 1,
              child: Container(
                width: 95,
                height: 95,
                child: GestureDetector(
                  onTapDown: (details) => isPressed(true),
                  onTapUp: (details) {
                    isPressed(false);
                    Future.delayed(150.milliseconds, () => AppPage.Share.to(init: ShareController.initPopup));
                  },
                  child: PolyContainer(
                    radius: 24,
                    rotate: 30,
                    sides: 6,
                    child: SonrIcons.Share.gradient(size: 34, value: SonrGradients.PremiumWhite),
                  ),
                ),
              )),
          false.obs),
    );
  }
}
