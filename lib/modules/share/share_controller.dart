import 'dart:async';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/modules/media/media_picker.dart';
import 'package:sonr_app/theme/theme.dart';

// ** Share State Extension ** //
enum ShareButtonState { Default, Queue }

extension ShareStateUtils on ShareButtonState {
  bool get isQueued => this == ShareButtonState.Queue;
  bool get isDefault => this == ShareButtonState.Default;
}

// ** Share Reactive Controller ** //
class ShareController extends GetxController {
  // Permissions
  final cameraPermitted = RxBool(UserService.permissions.value.hasCamera);
  final galleryPermitted = RxBool(UserService.permissions.value.hasGallery);

  // Properties
  final size = Size(60, 60).obs;
  final heightFactor = 0.6.obs;
  final status = ShareButtonState.Default.obs;

  // References
  int _counter = 0;
  Timer _timer;

  @override
  onInit() {
    super.onInit();
  }

  // ^ Expand Share Button ^ //
  expand(double timeout, ShareButtonState previousState) {
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
      _presentGalleryView();
    }

    // Request Permissions
    else {
      galleryPermitted(await Get.find<UserService>().requestGallery());
      galleryPermitted.value ? _presentGalleryView() : SonrSnack.error("Sonr cannot open Media Picker without Gallery Permissions");
    }
  }

  // ^ Close Share Button ^ //
  void shrink({Duration delay = const Duration(milliseconds: 0)}) {
    Future.delayed(delay, () {
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
        HapticFeedback.mediumImpact();
        status(ShareButtonState.Default);
        _updateSize();
        _counter = 0;
      }
    });
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggle() {
    if (status.value == ShareButtonState.Default) {
      status(ShareButtonState.Queue);
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
    if (status.value == ShareButtonState.Queue) {
      heightFactor(0.2);
      size(Size(Get.width / 2 + 165, 120));
    } else {
      heightFactor(0.6);
      size(Size(60, 60));
    }
  }
}
