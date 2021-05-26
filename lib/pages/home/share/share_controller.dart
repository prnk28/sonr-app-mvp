import 'dart:async';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style/style.dart';

import 'share_view.dart';
export 'button_view.dart';
export 'share_controller.dart';
export 'sheet_view.dart';

/// ** Share State Extension ** //

enum ShareStatus { Default, Queue }

extension ShareStatusUtils on ShareStatus {
  bool get isExpanded => this != ShareStatus.Default;

  // @ Method Builds Size for Status
  Size get size {
    switch (this) {
      case ShareStatus.Queue:
        return Size(Width.ratio(0.95), 110);
      default:
        return Size(90, 90);
    }
  }
}

/// ** Share Reactive Controller ** //
class ShareController extends GetxController {
  // Permissions
  final cameraPermitted = RxBool(MobileService.hasCamera.value);
  final galleryPermitted = RxBool(MobileService.hasGallery.value);

  // Properties
  final size = Size(60, 60).obs;
  final status = ShareStatus.Default.obs;

  // Shared Files
  final currentMedia = Rx<SonrFile?>(null);

  // References
  int _counter = 0;
  Timer? _timer;

  @override
  onInit() {
    status.listen(_handleStatus);
    super.onInit();
  }

  /// @ Expand Share Button
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

  /// @ Present Camera View
  presentCameraView() {
    TransferService.chooseCamera();
  }

  /// @ Select Contact to Transfer
  selectContact() async {
    // Shrink Button after Delay
    shrink(delay: 150.milliseconds);

    // Push to Transfer
    TransferService.chooseContact();
  }

  /// @ Select a File
  selectFile() async {
    // Check Permissions
    if (MobileService.hasGallery.value) {
      // Shrink Button after Delay
      shrink(delay: 150.milliseconds);
      await TransferService.chooseFile();
    } else {
      // Request Permissions
      var status = await Get.find<MobileService>().requestGallery();
      SonrOverlay.back();

      // Check Status
      if (status) {
        await Future.delayed(100.milliseconds);
        shrink(delay: 150.milliseconds);
        await TransferService.chooseFile();
      } else {
        SonrSnack.error("Cannot pick Media without Permissions");
      }
    }
  }

  /// @ Select Media
  selectMedia() async {
    // Check Permissions
    if (MobileService.hasGallery.value) {
      // Shrink Button after Delay
      shrink(delay: 150.milliseconds);
      await TransferService.chooseMedia();
    } else {
      // Request Permissions
      var status = await Get.find<MobileService>().requestGallery();
      SonrOverlay.back();

      // Check Status
      if (status) {
        await Future.delayed(100.milliseconds);
        // Shrink Button after Delay
        shrink(delay: 150.milliseconds);
        await TransferService.chooseMedia();
      } else {
        SonrSnack.error("Cannot pick Media without Permissions");
      }
    }
  }

  /// @ Select a URL
  selectExternal(Payload payload, URLLink? url, SonrFile? mediaFile) {
    if (payload == Payload.URL) {
      TransferService.chooseURLExternal(url!.url);
    } else {
      TransferService.chooseMediaExternal(mediaFile!);
    }
  }

  /// @ Close Share Button
  void shrink({Duration delay = const Duration(milliseconds: 600)}) {
    Future.delayed(delay, () {
      if (_timer != null) {
        _timer!.cancel();
        _timer = null;
        status(ShareStatus.Default);
        HapticFeedback.mediumImpact();
        _counter = 0;
      }
    });
  }

  /// @ Toggles Expanded Share Button
  void toggle() {
    Get.to(SharePopupView(), transition: Transition.downToUp, duration: 350.milliseconds);
    // if (status.value == ShareStatus.Default) {
    //   status(ShareStatus.Queue);
    //   expand(6000, status.value);
    // } else {
    //   shrink();
    // }
  }

  // # Present Camera View

  // # Update Size Based on State
  _handleStatus(ShareStatus status) {
    size(status.size);
  }
}
