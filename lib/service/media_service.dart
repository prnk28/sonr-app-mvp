import 'dart:async';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'sonr_service.dart';
import 'user_service.dart';

enum GalleryState { Initial, Loading, Ready }

class MediaService extends GetxService {
  // Reactive Instances
  final _gallery = <MediaCollection>[].obs;
  final _hasGallery = false.obs;
  final _incomingMedia = <SharedMediaFile>[].obs;
  final _incomingText = "".obs;
  final _state = Rx<GalleryState>(GalleryState.Initial);
  final _totalMedia = <Media>[].obs;

  // Properties
  static RxList<MediaCollection> get gallery => Get.find<MediaService>()._gallery;
  static RxBool get hasGallery => Get.find<MediaService>()._hasGallery;
  static Rx<GalleryState> get state => Get.find<MediaService>()._state;
  static RxList<Media> get totalMedia => Get.find<MediaService>()._totalMedia;

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
    if (Get.find<DeviceService>().galleryPermitted.val) {
      // Get Collections
      _state(GalleryState.Loading);
      List<MediaCollection> collections = await MediaGallery.listMediaCollections(
        mediaTypes: [MediaType.image, MediaType.video],
      );

      // Set Gallery
      _gallery(collections);

      // @ List Collections
      var totalCollection;
      collections.forEach((element) {
        // Set Has Gallery
        if (element.count > 0) {
          _hasGallery(true);
        }

        // Check for Master Collection
        if (element.isAllCollection) {
          totalCollection = element;
        }
      });

      // @ Get Initial Media
      if (totalCollection.count > 0) {
        // Get Images
        final MediaPage imagePage = await totalCollection.getMedias(
          mediaType: MediaType.image,
          take: 500,
        );

        // Get Videos
        final MediaPage videoPage = await totalCollection.getMedias(
          mediaType: MediaType.video,
          take: 500,
        );

        // Combine Media
        final List<Media> combined = [
          ...imagePage.items,
          ...videoPage.items,
        ]..sort((x, y) => y.creationDate.compareTo(x.creationDate));

        // Set All Media
        _totalMedia.assignAll(combined);
      }
      _state(GalleryState.Ready);
    }

    return this;
  }

  // ^ Checks for Initial Media/Text to Share ^ //
  static checkInitialShare() {
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
      // Open Sheet
      Get.bottomSheet(ShareSheet.url(controller._incomingText.value), barrierColor: SonrColor.DialogBackground, isDismissible: false);

      // Reset Incoming
      controller._incomingText("");
      controller._incomingText.refresh();
    }
  }

  // ^ Method Returns Media from Current Collection ^ //
  static Future<List<Media>> getMediaFromCollection(MediaCollection updatedCollection) async {
    // Initialize
    var controller = Get.find<MediaService>();
    controller._state(GalleryState.Loading);

    // Set All Media
    controller._state(GalleryState.Ready);

    // Get Images
    final MediaPage imagePage = await updatedCollection.getMedias(
      mediaType: MediaType.image,
      take: 500,
    );

    // Get Videos
    final MediaPage videoPage = await updatedCollection.getMedias(
      mediaType: MediaType.video,
      take: 500,
    );

    // Combine Media
    return [
      ...imagePage.items,
      ...videoPage.items,
    ]..sort((x, y) => y.creationDate.compareTo(x.creationDate));
  }

  // ^ Method Refreshes Gallery ^ //
  static Future refreshGallery() async {
    final controller = Get.find<MediaService>();
    // Get Collections
    controller._state(GalleryState.Loading);
    List<MediaCollection> collections = await MediaGallery.listMediaCollections(
      mediaTypes: [MediaType.image, MediaType.video],
    );

    // Set Gallery
    controller._gallery(collections);

    // @ List Collections
    var totalCollection;
    collections.forEach((element) {
      // Set Has Gallery
      if (element.count > 0) {
        controller._hasGallery(true);
      }

      // Check for Master Collection
      if (element.isAllCollection) {
        totalCollection = element;
      }
    });

    // @ Get Initial Media
    if (totalCollection.count > 0) {
      // Get Images
      final MediaPage imagePage = await totalCollection.getMedias(
        mediaType: MediaType.image,
        take: 500,
      );

      // Get Videos
      final MediaPage videoPage = await totalCollection.getMedias(
        mediaType: MediaType.video,
        take: 500,
      );

      // Combine Media
      final List<Media> combined = [
        ...imagePage.items,
        ...videoPage.items,
      ]..sort((x, y) => y.creationDate.compareTo(x.creationDate));

      // Set All Media
      controller._totalMedia.assignAll(combined);
    }
    controller._state(GalleryState.Ready);
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
        // Save Image to Gallery
        var result = await GallerySaver.saveVideo(path, albumName: "Sonr");

        // Visualize Result
        if (result) {
          SonrSnack.error("Unable to save Captured Photo to your Gallery");
        }
        return result;
      } else {
        // Save Image to Gallery
        var result = await GallerySaver.saveImage(path, albumName: "Sonr");
        if (!result) {
          SonrSnack.error("Unable to save Captured Video to your Gallery");
        }
        return result;
      }
    }
  }

  // ^ Saves Received Media to Gallery ^ //
  static Future<bool> saveTransfer(TransferCard card) async {
    // Await Permissions

    // Get Data from Media
    final path = card.metadata.path;
    if (card.hasMetadata()) {
      // Save Image to Gallery
      if (card.metadata.mime.type == MIME_Type.image && Get.find<DeviceService>().galleryPermitted.val) {
        var result = await GallerySaver.saveImage(path, albumName: "Sonr");

        // Visualize Result
        if (result) {
          SonrSnack.success("Saved Transferred Photo to your Device's Gallery");
        } else {
          SonrSnack.error("Unable to save Photo to your Gallery");
        }
        return result;
      }

      // Save Video to Gallery
      else if (card.metadata.mime.type == MIME_Type.video && Get.find<DeviceService>().galleryPermitted.val) {
        var result = await GallerySaver.saveVideo(path, albumName: "Sonr");

        // Visualize Result
        if (result) {
          SonrSnack.success("Saved Transferred Video to your Device's Gallery");
        } else {
          SonrSnack.error("Unable to save Video to your Gallery");
        }
        return result;
      } else {
        return false;
      }
    } else {
      SonrSnack.success("Unable to save Media to Gallery");
      return false;
    }
  }

  // ^ Saves Received Media to Gallery ^ //
  _handleSharedFiles(List<SharedMediaFile> data) async {
    if (!Get.isBottomSheetOpen && UserService.exists.value) {
      Get.bottomSheet(ShareSheet.media(data), barrierColor: SonrColor.DialogBackground, isDismissible: false);
    }
  }

  // ^ Saves Received Media to Gallery ^ //
  _handleSharedText(String text) async {
    if (!Get.isBottomSheetOpen && GetUtils.isURL(text) && UserService.exists.value) {
      Get.bottomSheet(ShareSheet.url(text), barrierColor: SonrColor.DialogBackground, isDismissible: false);
    }
  }
}
