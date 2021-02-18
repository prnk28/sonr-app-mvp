import 'dart:io';
import 'dart:typed_data';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_core/models/models.dart';
import 'package:media_gallery/media_gallery.dart';
import '../home/home_controller.dart';
import 'preview_controller.dart';

enum CameraControllerState { Default, Ready, Loading, Recording, Captured }

class MediaController extends GetxController {
  // State Properties
  final state = Rx<CameraControllerState>(CameraControllerState.Default);

  // Camera Properties
  final videoDuration = 0.obs;
  final videoInProgress = false.obs;
  final zoomLevel = 0.0.obs;
  final doubleZoomed = false.obs;

  // Media Picker Properties
  final allCollections = Rx<List<MediaCollection>>();
  final mediaCollection = Rx<MediaCollection>();
  final allMedias = <Media>[].obs;
  final selectedMediaIndex = (-1).obs;
  final hasGallery = false.obs;
  final loaded = false.obs;

  // References
  bool _isFlipped = false;
  Media _selectedMedia;
  Uint8List _selectedThumbnail;

  // Notifiers
  ValueNotifier<CameraFlashes> switchFlash = ValueNotifier(CameraFlashes.NONE);
  ValueNotifier<Sensors> sensor = ValueNotifier(Sensors.BACK);
  ValueNotifier<Size> photoSize = ValueNotifier(Size(Get.width, Get.height));
  ValueNotifier<double> zoomNotifier = ValueNotifier(0);
  ValueNotifier<CaptureModes> captureMode = ValueNotifier(CaptureModes.PHOTO);

  // Controllers
  PictureController pictureController = new PictureController();
  VideoController videoController = new VideoController();
  Stopwatch stopwatch = new Stopwatch();

  // ** Constructer ** //
  MediaController() {
    zoomLevel.listen((value) {
      zoomNotifier.value = 1.0 / value;
    });
  }

  // ^ Update Camera State ^ //
  setState(CameraControllerState newState) {
    state(newState);
    state.refresh();
  }

  // ^ Captures Photo ^ //
  capturePhoto() async {
    // Update State
    setState(CameraControllerState.Loading);

    // Set Path
    var now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd–jms').format(now);
    var docs = await getApplicationDocumentsDirectory();
    var path = docs.path + "/SONR_PICTURE_" + formattedDate + ".jpeg";

    // Capture Photo
    await pictureController.takePicture(path);
    Get.find<PreviewController>().setPhoto(path);

    // Update State
    setState(CameraControllerState.Captured);
  }

  // ^ Captures Video ^ //
  startCaptureVideo() async {
    // Update State
    setState(CameraControllerState.Loading);

    // Set Path
    var now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd–jms').format(now);
    var docs = await getApplicationDocumentsDirectory();
    var path = docs.path + "/SONR_VIDEO_" + formattedDate + ".mp4";
    Get.find<PreviewController>().initVideo(path);

    // Capture Photo
    captureMode.value = CaptureModes.VIDEO;
    videoInProgress(true);
    stopwatch.start();
    await videoController.recordVideo(path);

    // Update State
    setState(CameraControllerState.Recording);
  }

  // ^ Stops Video Capture ^ //
  stopCaptureVideo() async {
    // Close Parameters
    videoInProgress(false);
    stopwatch.stop();
    videoDuration(stopwatch.elapsedMilliseconds);

    // Save Video
    await videoController.stopRecordingVideo();
    Get.find<PreviewController>().setVideo();
    stopwatch.reset();

    // Update State
    setState(CameraControllerState.Captured);
  }

  // ^ Flip Camera ^ //
  toggleCameraSensor() async {
    // Toggle
    _isFlipped = !_isFlipped;

    if (_isFlipped) {
      sensor.value = Sensors.FRONT;
    } else {
      sensor.value = Sensors.BACK;
    }
  }

  // ^ Retreive Albums ^ //
  fetchMedia() async {
    // Get Collections
    List<MediaCollection> collections = await MediaGallery.listMediaCollections(
      mediaTypes: [MediaType.image, MediaType.video],
    );

    allCollections(collections);

    // List Collections
    collections.forEach((element) {
      // Set Has Gallery
      if (element.count > 0) {
        hasGallery(true);
      }

      // Check for Master Collection
      if (element.isAllCollection) {
        // Assign Values
        mediaCollection(element);
      }
    });

    if (mediaCollection.value.count > 0) {
      // Get Images
      final MediaPage imagePage = await mediaCollection.value.getMedias(
        mediaType: MediaType.image,
        take: 500,
      );

      // Get Videos
      final MediaPage videoPage = await mediaCollection.value.getMedias(
        mediaType: MediaType.video,
        take: 500,
      );

      // Combine Media
      final List<Media> combined = [
        ...imagePage.items,
        ...videoPage.items,
      ]..sort((x, y) => y.creationDate.compareTo(x.creationDate));

      // Set All Media
      allMedias.assignAll(combined);
    }
    loaded(true);
  }

  // ^ Method Updates the Current Media Collection ^ //
  updateMediaCollection(MediaCollection collection) async {
    // Reset Loaded
    loaded(false);
    mediaCollection(collection);

    // Get Images
    final MediaPage imagePage = await mediaCollection.value.getMedias(
      mediaType: MediaType.image,
      take: 500,
    );

    // Get Videos
    final MediaPage videoPage = await mediaCollection.value.getMedias(
      mediaType: MediaType.video,
      take: 500,
    );

    // Combine Media
    final List<Media> combined = [
      ...imagePage.items,
      ...videoPage.items,
    ]..sort((x, y) => y.creationDate.compareTo(x.creationDate));

    // Set All Media
    allMedias.assignAll(combined);
    loaded(true);
  }

  // ^ Set Media from Picker
  setMediaPickerItem(Media media, Uint8List thumb) {
    _selectedMedia = media;
    _selectedThumbnail = thumb;
  }

  // ^ Process Selected File ^ //
  confirmSelectedFile() async {
    // Validate File
    if (_selectedMedia != null) {
      // Retreive File and Process
      File mediaFile = await _selectedMedia.getFile();
      Get.find<SonrService>().setPayload(Payload.MEDIA, path: mediaFile.path, thumbnailData: _selectedThumbnail);

      // Go to Transfer
      Get.offNamed("/transfer");
    }
  }
}
