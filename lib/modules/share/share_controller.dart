import 'dart:async';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';

// ** Share Reactive Controller ** //
class ShareController extends GetxController {
  // Permissions
  final cameraPermitted = RxBool(UserService.permissions.value.hasCamera);
  final galleryPermitted = RxBool(UserService.permissions.value.hasGallery);

  // Properties
  final alignment = Alignment.bottomCenter.obs;
  final size = Size(60, 60).obs;
  final translation = Rx<Matrix4>(Matrix4.translationValues(0, -30, 0));
  final status = ShareStatus.Default.obs;

  // Shared Files
  final currentMedia = Rx<MediaItem>(null);

  // References
  int _counter = 0;
  Timer _timer;

  @override
  onInit() {
    super.onInit();
  }

  // ^ Expand Share Button ^ //
  expand(double timeout, ShareStatus previousState) {
    HapticFeedback.heavyImpact();

    // Create Timeout
    _timer = Timer.periodic(500.milliseconds, (_) {
      // Add to Counter
      _counter = _counter += 500;

      // Check if Timeout Reached
      if (_counter == timeout) {
        if (status.value == previousState) {
          shrink();
        }
      }
    });
  }

  // ^ Check if User Granted Camera, or Request ^ //
  onCameraShare() async {
    // Check for Permissions
    if (cameraPermitted.value) {
      _presentCameraView();
    }

    // Request Permissions
    else {
      var result = await Get.find<UserService>().requestCamera();
      result ? _presentCameraView() : SonrSnack.error("Sonr cannot open Camera without Permissions");
    }
  }

  // ^ Check if User Granted Gallery, or Request ^ //
  onGalleryShare() async {
    // Check for Permissions
    if (galleryPermitted.value) {
      status(ShareStatus.PickMedia);
      _updateSize();
    }

    // Request Permissions
    else {
      galleryPermitted(await Get.find<UserService>().requestGallery());
      galleryPermitted.value ? _presentGalleryView() : SonrSnack.error("Sonr cannot open Media Picker without Gallery Permissions");
    }
  }

  // ^ Set current Media Item ^ //
  setMedia(MediaItem item) async {
    currentMedia(item);
    status(ShareStatus.Lobby);
  }

  // ^ Close Share Button ^ //
  void shrink({Duration delay = const Duration(milliseconds: 0)}) {
    Future.delayed(delay, () {
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
        HapticFeedback.mediumImpact();
        status(ShareStatus.Default);
        _updateSize();
        _counter = 0;
      }
    });
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggle() {
    if (status.value == ShareStatus.Default) {
      status(ShareStatus.Queue);
      _updateSize();
      expand(6000, status.value);
    } else {
      shrink();
    }
  }

  // # Present Camera View ^ //
  _presentCameraView() {
    // Move to View
    Get.to(CameraView.withPreview(onMediaSelected: (MediaFile file) {
      SonrService.queueCapture(file);
      Get.toNamed("/transfer");
    }), transition: Transition.downToUp);

    // Shrink Button after Delay
    shrink(delay: 150.milliseconds);
  }

  // # Present Picker View for Gallery ^ //
  _presentGalleryView() {
    // Present Sheet
    Get.bottomSheet(MediaPickerSheet(onMediaSelected: (file) {
      SonrService.queueMedia(file);
      Get.toNamed("/transfer");
    }), isDismissible: false);

    // Shrink button after delay
    shrink(delay: 150.milliseconds);
  }

  // # Update Size Based on State
  _updateSize() {
    size(status.value.size);
    alignment(status.value.alignment);
    translation(status.value.translation);
  }
}

// ** Share State Extension ** //
enum ShareStatus { Default, Queue, PickMedia, Lobby }

extension ShareStatusUtils on ShareStatus {
  bool get isQueued => this == ShareStatus.Queue;
  bool get isPickMedia => this == ShareStatus.PickMedia;
  bool get isLobby => this == ShareStatus.Lobby;
  bool get isDefault => this == ShareStatus.Default;

  // @ Method Builds Alignment for Status
  Alignment get alignment {
    switch (this) {
      case ShareStatus.PickMedia:
        return Alignment.center;
        break;
      case ShareStatus.Lobby:
        return Alignment.center;
        break;
      case ShareStatus.Queue:
        return Alignment.bottomCenter;
        break;

      default:
        return Alignment.bottomCenter;
    }
  }

  // @ Method Builds Size for Status
  Size get size {
    switch (this) {
      case ShareStatus.Queue:
        return Size(Get.width / 2 + 165, 110);
        break;
      case ShareStatus.PickMedia:
        return Size(Get.width * 0.9, Get.height * 0.75);
        break;
      case ShareStatus.Lobby:
        return Size(Get.width * 0.9, Get.height * 0.75);
        break;
      default:
        return Size(60, 60);
    }
  }

  // @ Method Builds Position for Status
  Matrix4 get translation {
    switch (this) {
      case ShareStatus.Queue:
        return Matrix4.translationValues(0, -30, 0);
      case ShareStatus.PickMedia:
        return Matrix4.translationValues(0, 100, 0);
      case ShareStatus.Lobby:
        return Matrix4.translationValues(0, -30, 0);
      default:
        return Matrix4.translationValues(0, -30, 0);
    }
  }
}
