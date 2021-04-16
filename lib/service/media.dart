import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/modules/share/sheet_view.dart';
import 'package:sonr_app/theme/form/theme.dart';
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
  final _incomingMedia = <SharedMediaFile>[].obs;
  final _incomingText = "".obs;
  final _state = Rx<GalleryState>(GalleryState.Initial);

  // Properties
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
    // Disable Log
    await PhotoManager.setLog(false);

    // Check Permissions
    if (UserService.permissions.value.hasGallery) {
      // Get Collections
      _state(GalleryState.Loading);
      _state(GalleryState.Ready);
    }
    return this;
  }

  // ^ Checks for Initial Media/Text to Share ^ //
  static checkInitialShare() async {
    // Initialize
    var controller = Get.find<MediaService>();

    // @ Check for Media
    if (controller._incomingMedia.length > 0 && !Get.isBottomSheetOpen) {
      // Open Sheet
      await Get.bottomSheet(ShareSheet.media(controller._incomingMedia), barrierColor: SonrColor.DialogBackground, isDismissible: false);

      // Reset Incoming
      controller._incomingMedia.clear();
      controller._incomingMedia.refresh();
    }

    // @ Check for Text
    if (controller._incomingText.value != "" && GetUtils.isURL(controller._incomingText.value) && !Get.isBottomSheetOpen) {
      var data = await SonrCore.getURL(controller._incomingText.value);
      // Open Sheet
      await Get.bottomSheet(ShareSheet.url(data), barrierColor: SonrColor.DialogBackground, isDismissible: false);

      // Reset Incoming
      controller._incomingText("");
      controller._incomingText.refresh();
    }
  }

  // ^ Load IO File from Metadata ^ //
  static Future<File> loadFileFromMetadata(Metadata metadata) async {
    var asset = await AssetEntity.fromId(metadata.id);
    return await asset.file;
  }

  // ^ Load MediaItem from Metadata ^ //
  static Future<MediaItem> loadItemFromMetadata(Metadata metadata) async {
    var asset = await AssetEntity.fromId(metadata.id);
    return MediaItem(asset, -1);
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
    if (meta.mime.type == MIME_Type.image && UserService.permissions.value.hasGallery) {
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
    else if (meta.mime.type == MIME_Type.video && UserService.permissions.value.hasGallery) {
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
    if (!Get.isBottomSheetOpen && UserService.hasUser.value) {
      await Get.bottomSheet(ShareSheet.media(data), barrierColor: SonrColor.DialogBackground, isDismissible: false);
    }
  }

  // ^ Saves Received Media to Gallery ^ //
  _handleSharedText(String text) async {
    if (!Get.isBottomSheetOpen && GetUtils.isURL(text) && UserService.hasUser.value) {
      // Get Data
      var data = await SonrCore.getURL(text);

      // Open Sheet
      await Get.bottomSheet(ShareSheet.url(data), barrierColor: SonrColor.DialogBackground, isDismissible: false);
    }
  }
}
