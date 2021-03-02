import 'dart:io';
import 'package:media_gallery/media_gallery.dart';
import 'package:sonr_app/core/core.dart';
import 'package:sonr_app/core/core.dart';
import 'camera_view.dart';
import 'preview_view.dart';

// @ Constants
enum MediaScreenState { Default, Camera, Loading, Captured }

class MediaScreen extends GetView<MediaController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.value == MediaScreenState.Captured) {
        return MediaPreviewView();
      } else {
        return CameraView();
      }
    });
  }
}

// ** Main Camera Screen Controller ** //
class MediaController extends GetxController {
  // Properties
  final state = Rx<MediaScreenState>(MediaScreenState.Default);

  // References
  var _isVideo = false;
  var _photoCapturePath = "";
  var _videoCapturePath = "";
  Media _selectedMedia;
  Uint8List _selectedThumbnail;

  // ^ Set State to Ready ^ //
  static ready() {
    Get.find<MediaController>().state(MediaScreenState.Camera);
    Get.find<MediaController>().state.refresh();
  }

  // ^ Set State to Loading ^ //
  static loading() {
    Get.find<MediaController>().state(MediaScreenState.Loading);
    Get.find<MediaController>().state.refresh();
  }

  // ^ Set State to Recording, Set Video Capture Path ^ //
  static recording(String path) {
    Get.find<MediaController>()._isVideo = true;
    Get.find<MediaController>()._videoCapturePath = path;
  }

  // ^ Set State to Captured, Set Photo Capture Path ^ //
  static setPhoto(String path) {
    Get.find<MediaController>()._isVideo = false;
    Get.find<PreviewController>().setPhoto(path);
    Get.find<MediaController>().state(MediaScreenState.Captured);
    Get.find<MediaController>().state.refresh();
  }

  static selectMedia(int index, Media media, Uint8List thumb) {
    Get.find<MediaController>()._selectedMedia = media;
    Get.find<MediaController>()._selectedThumbnail = thumb;
  }

  // ^ Set State to Captured, Set Video Capture Path ^ //
  static completeVideo(int milliseconds) async {
    Get.find<MediaController>()._isVideo = true;
    await Future.delayed(Duration(milliseconds: 300));
    Get.find<PreviewController>().setVideo(Get.find<MediaController>()._videoCapturePath);
    Get.find<MediaController>().state(MediaScreenState.Captured);
    Get.find<MediaController>().state.refresh();
  }

  // ^ Confirm with Captured Media ^ //
  static confirmCaptured() {
    // @ Get Data
    var isVideo = Get.find<MediaController>()._isVideo;
    var photoPath = Get.find<MediaController>()._photoCapturePath;
    var videoPath = Get.find<MediaController>()._videoCapturePath;

    // @ Check For Video
    if (isVideo) {
      // Save Video
      MediaService.saveCapture(videoPath, isVideo);
      //SonrService.queueMedia(videoPath);
    } else {
      // Save Photo
      MediaService.saveCapture(photoPath, isVideo);
      //SonrService.queueMedia(photoPath);
    }

    // Go to Transfer
    Get.offNamed("/transfer");
  }
}
