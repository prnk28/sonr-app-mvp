import 'dart:async';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';
import 'share.dart';

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
    status.listen(_handleStatus);
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

  // ^ Present Camera View ^ //
  presentCameraView() {
    // Move to View
    Get.to(CameraView.withPreview(onMediaSelected: (MediaFile file) {
      SonrService.queueCapture(file);
      Get.toNamed("/transfer");
    }), transition: Transition.downToUp);

    // Shrink Button after Delay
    shrink(delay: 150.milliseconds);
  }

  // ^ Select a File
  selectFile() async {
    // Check Permissions
    if (UserService.permissions.value.hasGallery) {
      var result = await FileService.selectMedia();
      if (result.hasItem) {
        print(result.item2.toString());
      }
    } else {
      // Request Permissions
      var status = await Get.find<UserService>().requestGallery();
      SonrOverlay.back();

      // Check Status
      if (status) {
        await Future.delayed(100.milliseconds);

        // Continue With Picker
        var result = await FileService.selectFile();
        if (result.hasItem) {
          print(result.item2.toString());
        }
      } else {
        SonrSnack.error("Cannot pick Media without Permissions");
      }
    }
  }

  // ^ Select Media
  selectMedia() async {
    // Check Permissions
    if (UserService.permissions.value.hasGallery) {
      var result = await FileService.selectMedia();
      if (result.hasItem) {
        print(result.item2.toString());
      }
    } else {
      // Request Permissions
      var status = await Get.find<UserService>().requestGallery();
      SonrOverlay.back();

      // Check Status
      if (status) {
        await Future.delayed(100.milliseconds);

        // Continue With Picker
        var result = await FileService.selectMedia();
        if (result.hasItem) {
          print(result.item2.toString());
        }
      } else {
        SonrSnack.error("Cannot pick Media without Permissions");
      }
    }
  }

  // ^ Set current Media Item ^ //
  setMedia(MediaItem item) async {
    SonrService.queueMedia(item);
    await Get.toNamed("/transfer");
    status(ShareStatus.Default);
  }

  // ^ Close Share Button ^ //
  void shrink({Duration delay = const Duration(milliseconds: 0)}) {
    Future.delayed(delay, () {
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
        HapticFeedback.mediumImpact();
        status(ShareStatus.Default);
        _counter = 0;
      }
    });
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggle() {
    if (status.value == ShareStatus.Default) {
      status(ShareStatus.Queue);
      expand(6000, status.value);
    } else {
      shrink();
    }
  }

  // # Present Camera View ^ //

  // # Update Size Based on State
  _handleStatus(ShareStatus status) {
    size(status.size);
    alignment(status.alignment);
    translation(status.translation);
  }
}
