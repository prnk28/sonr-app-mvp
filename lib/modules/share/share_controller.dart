import 'dart:async';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/model/model_file.dart';
import 'package:sonr_app/modules/camera/camera.dart';
import 'package:sonr_app/pages/transfer/transfer_page.dart';
import 'package:sonr_app/theme/theme.dart';
export 'share_view.dart';
export 'share_controller.dart';
export 'sheet_view.dart';

// ** Share Reactive Controller ** //
class ShareController extends GetxController with SingleGetTickerProviderMixin {
  // Permissions
  final cameraPermitted = RxBool(UserService.permissions.value.hasCamera);
  final galleryPermitted = RxBool(UserService.permissions.value.hasGallery);

  // Properties
  final status = ShareStatus.Default.obs;

  // References
  AnimationController animator;
  int _counter = 0;
  Timer _timer;

  @override
  onInit() {
    super.onInit();
    animator = AnimationController(duration: Duration(milliseconds: 650), vsync: this);
  }

  @override
  void onClose() {
    animator.dispose();
    super.onClose();
  }

  // ^ Expand Share Button ^ //
  void expand(double timeout, ShareStatus previousState) {
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
  void openCamera() async {
    // Check for Permissions
    if (cameraPermitted.value) {
      // Move to View
      Get.to(CameraView.withPreview(onMediaSelected: (MediaFile file) {
        // Shrink Button after Delay
        shrink(delay: 150.milliseconds);

        // Transfer with File
        Transfer.transferWithFile(FileItem.capture(file));
      }), transition: Transition.downToUp);
    }

    // Request Permissions
    else {
      var result = await Get.find<UserService>().requestCamera();
      result
          ? Get.to(CameraView.withPreview(onMediaSelected: (MediaFile file) {
              // Shrink Button after Delay
              shrink(delay: 150.milliseconds);

              // Transfer with File
              Transfer.transferWithFile(FileItem.capture(file));
            }), transition: Transition.downToUp)
          : SonrSnack.error("Sonr cannot open Camera without Permissions");
    }
  }

  // ^ Select Contact to Transfer ^
  void selectContact() async {
    // Shrink Button after Delay
    shrink(delay: 150.milliseconds);

    // Push to Transfer
    Transfer.transferWithContact();
  }

  // ^ Select a File
  void selectFile() async {
    // Check Permissions
    if (UserService.permissions.value.hasGallery) {
      var result = await FileService.selectMedia();
      if (result.hasItem) {
        // Shrink Button after Delay
        shrink(delay: 150.milliseconds);

        // Push to Transfer Screen
        Transfer.transferWithFile(result.fileItem);
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
          // Shrink Button after Delay
          shrink(delay: 150.milliseconds);

          // Push to Transfer
          Transfer.transferWithFile(result.fileItem);
        }
      } else {
        SonrSnack.error("Cannot pick Media without Permissions");
      }
    }
  }

  // ^ Select Media
  void selectMedia() async {
    // Check Permissions
    if (UserService.permissions.value.hasGallery) {
      var result = await FileService.selectMedia();
      if (result.hasItem) {
        // Push to Transfer
        Transfer.transferWithFile(result.fileItem);

        // Shrink Button after Delay
        shrink(delay: 150.milliseconds);
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
          // Push to Transfer
          Transfer.transferWithFile(result.fileItem);

          // Shrink Button after Delay
          shrink(delay: 150.milliseconds);
        }
      } else {
        SonrSnack.error("Cannot pick Media without Permissions");
      }
    }
  }

  // ^ Select a URL ^ //
  void selectExternal(Payload payload, URLLink url, MediaFile mediaFile) {
    if (payload == Payload.URL) {
      Transfer.transferWithUrl(url.link);
    } else {
      Transfer.transferWithFile(FileItem.capture(mediaFile));
    }
  }

  // ^ Close Share Button ^ //
  void shrink({Duration delay = const Duration(milliseconds: 600)}) {
    Future.delayed(delay, () {
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
        animator.reverse();
        status(ShareStatus.Default);
        HapticFeedback.mediumImpact();
        _counter = 0;
      }
    });
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggle() {
    if (status.value == ShareStatus.Default) {
      animator.forward();
      status(ShareStatus.Queue);
      expand(6000, status.value);
    } else {
      shrink();
    }
  }
}

enum ShareStatus { Default, Queue }

extension ShareStatusUtils on ShareStatus {
  bool get isExpanded => this != ShareStatus.Default;
}
