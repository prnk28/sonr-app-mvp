import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'sonr.dart';
import 'user.dart';
import 'package:photo_manager/photo_manager.dart';

enum GalleryState { Initial, Loading, Ready }

class MediaService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<MediaService>();
  static MediaService get to => Get.find<MediaService>();

  // Reactive Instances
  final _albums = <MediaAlbum>[].obs;
  final _hasGallery = false.obs;
  final _incomingMedia = <SharedMediaFile>[].obs;
  final _incomingText = "".obs;
  final _state = Rx<GalleryState>(GalleryState.Initial);
  final _allMedia = Rx<MediaAlbum>();

  // Properties
  static Rx<MediaAlbum> get allAlbum => Get.find<MediaService>()._allMedia;
  static RxList<MediaAlbum> get albums => Get.find<MediaService>()._albums;
  static RxBool get hasGallery => Get.find<MediaService>()._hasGallery;
  static Rx<GalleryState> get state => Get.find<MediaService>()._state;

  // References
  StreamSubscription _externalMediaStream;
  StreamSubscription _externalTextStream;

  @override
  void onInit() {
    // @ For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> data) {
      if (data != null) {
        _incomingMedia(data);
        _incomingMedia.refresh();
      }
    });

    // @ For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String text) {
      if (text != null) {
        _incomingText(text);
        _incomingText.refresh();
      }
    });

    // @ Listen to Incoming Text
    _externalTextStream = ReceiveSharingIntent.getTextStream().listen(_handleSharedText);

    // @ Listen to Incoming File
    _externalMediaStream = ReceiveSharingIntent.getMediaStream().listen(_handleSharedFiles);
    super.onInit();
  }

  @override
  void onClose() {
    _externalMediaStream.cancel();
    _externalTextStream.cancel();
    super.onClose();
  }

  // ^ Initialize Service ^ //
  Future<MediaService> init() async {
    if (Get.find<PermissionService>().galleryPermitted.val) {
      // Get Collections
      _state(GalleryState.Loading);

      // Remove Non existing albums for android
      if (DeviceService.isAndroid) {
        await PhotoManager.editor.android.removeAllNoExistsAsset();
      }

      // Get Albums
      List<AssetPathEntity> list = await PhotoManager.getAssetPathList();
      var albums = <MediaAlbum>[];
      list.forEach((element) {
        // Validate Album
        if (element.name != "" && element.assetCount > 1) {
          var album = MediaAlbum(element);
          albums.add(album);
          if (element.isAll) {
            _allMedia(album);
          }
        }
      });

      // Set Gallery
      _albums.assignAll(albums);
      _albums.refresh();
      _state(GalleryState.Ready);
    }
    return this;
  }

  // ^ Checks for Initial Media/Text to Share ^ //
  static checkInitialShare() async {
    // Initialize
    var controller = Get.find<MediaService>();

    // @ Check for Media
    if (controller._incomingMedia.isNotEmpty && !Get.isBottomSheetOpen) {
      // Open Sheet
      Get.bottomSheet(ShareSheet.media(controller._incomingMedia), barrierColor: SonrColor.DialogBackground, isDismissible: false);

      // Reset Incoming
      controller._incomingMedia.clear();
      controller._incomingMedia.refresh();
    }

    // @ Check for Text
    if (controller._incomingText.value != "" && GetUtils.isURL(controller._incomingText.value) && !Get.isBottomSheetOpen) {
      var data = await SonrCore.getURL(controller._incomingText.value);
      // Open Sheet
      Get.bottomSheet(ShareSheet.url(data), barrierColor: SonrColor.DialogBackground, isDismissible: false);

      // Reset Incoming
      controller._incomingText("");
      controller._incomingText.refresh();
    }
  }

  // ^ Method Refreshes Gallery ^ //
  static Future refreshGallery() async {
    if (Get.find<PermissionService>().galleryPermitted.val) {
      // Get Collections
      to._state(GalleryState.Loading);

      // Remove Non existing albums for android
      if (DeviceService.isAndroid) {
        await PhotoManager.editor.android.removeAllNoExistsAsset();
      }

      // Get Albums
      List<AssetPathEntity> list = await PhotoManager.getAssetPathList();
      var albums = <MediaAlbum>[];
      list.forEach((element) {
        // Validate Album
        if (element.name != "" && element.assetCount > 1) {
          var album = MediaAlbum(element);
          albums.add(album);
          if (element.isAll) {
            to._allMedia(album);
          }
        }
      });

      // Set Gallery
      to._albums.assignAll(albums);
      to._albums.refresh();
      to._state(GalleryState.Ready);
    }
  }

  // ^ Saves Photo to Gallery ^ //
  static Future<bool> saveCapture(String path, bool isVideo) async {
    // Validate Path
    var file = File(path);
    var exists = await file.exists();
    if (!exists) {
      SonrSnack.error("Unable to save Captured Media to your Gallery");
      return false;
    } else {
      if (isVideo) {
        // Set Video File
        File videoFile = File(path);
        var asset = await PhotoManager.editor.saveVideo(videoFile);
        var result = await asset.exists;

        // Visualize Result
        if (result) {
          SonrSnack.error("Unable to save Captured Photo to your Gallery");
        }
        return result;
      } else {
        // Save Image to Gallery
        var asset = await PhotoManager.editor.saveImageWithPath(path);
        var result = await asset.exists;
        if (!result) {
          SonrSnack.error("Unable to save Captured Video to your Gallery");
        }
        return result;
      }
    }
  }

  // ^ Saves Received Media to Gallery ^ //
  static Future<AssetEntity> saveTransfer(Metadata meta) async {
    // Get Data from Media
    final path = meta.path;
      // Save Image to Gallery
      if (meta.mime.type == MIME_Type.image && Get.find<PermissionService>().galleryPermitted.val) {
        var asset = await PhotoManager.editor.saveImageWithPath(path);
        var result = await asset.exists;

        // Visualize Result
        if (result) {
          SonrSnack.success("Saved Transferred Photo to your Device's Gallery");
        } else {
          SonrSnack.error("Unable to save Photo to your Gallery");
        }
        return asset;
      }

      // Save Video to Gallery
      else if (meta.mime.type == MIME_Type.video && Get.find<PermissionService>().galleryPermitted.val) {
        // Set Video File
        File videoFile = File(path);
        var asset = await PhotoManager.editor.saveVideo(videoFile);
        var result = await asset.exists;

        // Visualize Result
        if (result) {
          SonrSnack.success("Saved Transferred Video to your Device's Gallery");
        } else {
          SonrSnack.error("Unable to save Video to your Gallery");
        }
        return asset;
      } else {
        return null;
      }
  }

  // ^ Saves Received Media to Gallery ^ //
  _handleSharedFiles(List<SharedMediaFile> data) async {
    if (!Get.isBottomSheetOpen && UserService.isExisting.value) {
      Get.bottomSheet(ShareSheet.media(data), barrierColor: SonrColor.DialogBackground, isDismissible: false);
    }
  }

  // ^ Saves Received Media to Gallery ^ //
  _handleSharedText(String text) async {
    if (!Get.isBottomSheetOpen && GetUtils.isURL(text) && UserService.isExisting.value) {
      // Get Data
      var data = await SonrCore.getURL(text);

      // Open Sheet
      Get.bottomSheet(ShareSheet.url(data), barrierColor: SonrColor.DialogBackground, isDismissible: false);
    }
  }
}
