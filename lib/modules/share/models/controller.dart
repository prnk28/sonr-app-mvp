// Imports
import 'package:get/get.dart';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style/style.dart';
import 'package:photo_manager/photo_manager.dart';

class ShareController extends GetxController with StateMixin<Session> {
  // Properties
  final gallery = RxList<AssetPathEntity>();
  final currentAlbum = Rx<AssetPathAlbum>(AssetPathAlbum.blank());
  final selectedItems = RxList<Tuple<AssetEntity, Uint8List>>();
  final hasSelected = false.obs;
  final viewStatus = ShareViewStatus.Default.obs;
  final type = ShareViewType.None.obs;

  // References
  final keyOne = GlobalKey();
  final keyTwo = GlobalKey();
  final keyThree = GlobalKey();
  final keyFour = GlobalKey();
  final keyFive = GlobalKey();

  @override
  void onInit() {
    initGallery();
    super.onInit();
  }

  void initialize(ShareViewType givenType) {
    type(givenType);
    change(Session(), status: RxStatus.empty());
  }

  /// Initializes Controller for Popup - Popup is for when in HomeScreen
  static void initPopup() {
    Get.find<ShareController>().initialize(ShareViewType.Popup);
  }

  /// Initializes Controller for Dialog - Dialog is for when in TransferScreen
  static void initAlert() {
    Get.find<ShareController>().initialize(ShareViewType.Alert);
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

  /// Checks if AssetEntity is Selected
  bool isSelected(AssetEntity item) {
    for (var couple in selectedItems) {
      if (couple.item1.id == item.id) {
        return true;
      }
    }
    return false;
  }

  /// Initializes Gallery
  Future<void> initGallery() async {
    // Set Loading
    viewStatus(ShareViewStatus.Loading);

    // Setup Gallery
    var list = await PhotoManager.getAssetPathList();
    gallery(list.where((e) => e.assetCount > 0 && e.name.isNotEmpty).toList());
    var all = await gallery.allAlbum();
    if (all != null) {
      currentAlbum(all);
    }

    // Set Loading
    viewStatus(ShareViewStatus.Ready);
  }

  /// Open Camera and Take Picture for Share
  Future<void> chooseCamera() async {
    // Check for Permissions
    if (await Permissions.Camera.isGranted) {
      // Check Done
      var done = await SenderService.choose(ChooseOption.Camera);
      _handleConfirmation(done);
    }
    // Request Permissions
    else {
      if (await Permissions.Camera.request()) {
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
    if (await Permissions.Gallery.isGranted) {
      var done = await SenderService.choose(ChooseOption.File);
      _handleConfirmation(done);
    } else {
      // Request Permissions
      var status = await Permissions.Gallery.request();

      // Check Status
      if (status) {
        var done = await SenderService.choose(ChooseOption.File);
        _handleConfirmation(done);
      } else {
        AppRoute.snack(SnackArgs.error("Cannot pick Media without Permissions"));
      }
    }
  }

  /// Open Media Picker and Select Media for Share
  Future<void> chooseMedia() async {
    // Check Permissions
    if (await Permissions.Gallery.isGranted) {
      var done = await SenderService.choose(ChooseOption.Media);
      _handleConfirmation(done);
    } else {
      // Request Permissions
      var status = await Permissions.Gallery.request();

      // Check Status
      if (status) {
        var done = await SenderService.choose(ChooseOption.Media);
        _handleConfirmation(done);
      } else {
        AppRoute.snack(SnackArgs.error("Cannot pick Media without Permissions"));
      }
    }
  }

  /// Choose Payload then Immedietly Send Invite to Peer
  Future<void> chooseThenInvite({required Member peer, required ChooseOption option}) async {
    SenderService.choose(option).then((value) {
      if (value != null) {
        // Set Peer for Invite
        value.setMember(peer);

        // Create Session
        change(SenderService.invite(value), status: RxStatus.success());
      }
    });
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
      var SFile = await selectedItems.toSFile();
      var result = await SenderService.choose(ChooseOption.Media, file: SFile);
      _handleConfirmation(result);
    } else {
      AppRoute.snack(SnackArgs.missing("No Files Selected"));
    }
  }

  /// Changes Album to New Album
  Future<void> setAlbum(int index) async {
    viewStatus(ShareViewStatus.Loading);
    currentAlbum.call();
    currentAlbum(await AssetPathAlbum.init(index, gallery[index]));
    currentAlbum.refresh();
    viewStatus(ShareViewStatus.Ready);
  }

  /// Removes Item from Selected Items List
  void removeMediaItem(AssetEntity item) {
    for (var couple in selectedItems) {
      if (couple.item1.id == item.id) {
        selectedItems.remove(couple);
      }
    }
    selectedItems.refresh();
    hasSelected(selectedItems.length > 0);
  }

  void _handleConfirmation(InviteRequest? request) {
    // Check Result Success
    if (request != null) {
      // Check View Type
      if (this.type.value.isViewPopup) {
        AppPage.Transfer.off(args: TransferArguments(request));
      } else {
        Get.find<TransferController>().initialize(request: request);
        Get.back();
      }
      // Reset Share Items
      selectedItems.clear();
      hasSelected(false);
    }
  }
}
