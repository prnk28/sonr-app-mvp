import 'dart:async';
import 'dart:io';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonr_app/pages/transfer/transfer_page.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'preview_widget.dart';

enum CameraViewType { Default, Preview }

class CameraView extends GetView<CameraController> {
  // Properties
  final Function(SonrFile file) onMediaSelected;
  final CameraViewType type;
  CameraView({@required this.onMediaSelected, this.type = CameraViewType.Default});

  factory CameraView.withPreview({@required Function(SonrFile file) onMediaSelected}) {
    return CameraView(onMediaSelected: onMediaSelected, type: CameraViewType.Preview);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to Updates
    controller.hasCaptured.listen((val) {
      if (val) {
        if (type == CameraViewType.Default) {
          onMediaSelected(controller.getFile());
        } else if (type == CameraViewType.Preview) {
          Get.dialog(
              MediaPreviewView(
                  mediaFile: controller.getFile(),
                  onDecision: (value) {
                    value ? controller.continueWithCapture(onMediaSelected) : controller.clearFromPreview();
                  }),
              barrierDismissible: false);
        }
      }
    });

    // Build View
    return Stack(
      children: [
        GestureDetector(
          onDoubleTap: () {
            // Update Double Zoomed
            controller.doubleZoomed(!controller.doubleZoomed.value);

            // Set Zoom Level
            if (controller.doubleZoomed.value) {
              controller.zoomLevel(0.25);
            } else {
              controller.zoomLevel(0.0);
            }
          },
          onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
            // Calculate Scale
            var factor = 1.0 / scaleDetails.scale;
            var adjustedScale = 1 - factor;

            // Set Zoom Level
            if (scaleDetails.pointerCount > 1) {
              controller.zoomLevel(adjustedScale);
            }
          },
          onHorizontalDragUpdate: (details) {},
          child: CameraAwesome(
            testMode: false,
            sensor: controller.sensor,
            zoom: controller.zoomNotifier,
            photoSize: controller.photoSize,
            switchFlashMode: controller.switchFlash,
            captureMode: controller.captureMode,
            brightness: controller.brightness,
          ),
        ),
        // Button Tools View
        _CameraToolsView(),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 14, top: Get.statusBarHeight / 2),
          child: ActionButton(
              onPressed: () {
                Get.back();
              },
              icon: SonrIcons.Close.gradient(value: SonrGradients.PhoenixStart)),
        ),
        Obx(() {
          if (controller.videoInProgress.value) {
            return Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.AccentNavy.withOpacity(0.75)),
              child: _buildDurationText(controller.videoDuration.value),
            );
          } else {
            return Container();
          }
        })
      ],
    );
  }

  Widget _buildDurationText(int milliseconds) {
    int seconds = milliseconds ~/ 1000;
    return RichText(
        textAlign: TextAlign.center,
        overflow: TextOverflow.fade,
        text: TextSpan(children: [
          TextSpan(
              text: seconds.toString(), style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w300, fontSize: 16, color: SonrColor.Black)),
          TextSpan(text: "  s", style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w600, fontSize: 16, color: SonrColor.Black)),
        ]));
  }
}

class _CameraToolsView extends GetView<CameraController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: Neumorphic.floating(),
        padding: EdgeInsets.only(top: 20, bottom: 40),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          // Switch Camera
          Obx(() {
            var iconData = controller.isFlipped.value ? Icons.camera_rear_rounded : Icons.camera_front_rounded;
            return GestureDetector(
                child: AnimatedSlideSwitcher.slideUp(
                    child: Container(
                        key: ValueKey<IconData>(iconData),
                        child: iconData.gradient(
                          value: SonrGradients.LoveKiss,
                          size: 36,
                        ))),
                onTap: () async {
                  await HapticFeedback.heavyImpact();
                  controller.toggleCameraSensor();
                });
          }),

          // Neumorphic Camera Button Stack
          _CaptureButton(),

          // Media Gallery Picker
          GestureDetector(
              child: SonrIcons.Photos.gradient(
                value: SonrGradients.OctoberSilence,
                size: 36,
              ),
              onTap: () async {
                await HapticFeedback.heavyImpact();
                // Check for Permssions
                var result = await FileService.selectMedia();

                // Selected Item
                if (result.item1) {
                  Transfer.transferWithFile(result.item2);
                }
              }),
        ]),
      ),
    );
  }
}

class _CaptureButton extends GetView<CameraController> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 150,
        height: 150,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: EdgeInsets.all(14),
            decoration: Neumorphic.floating(shape: BoxShape.circle),
            child: Container(
              decoration: Neumorphic.floating(shape: BoxShape.circle),
              margin: EdgeInsets.all(14),
              child: GestureDetector(
                onTap: () {
                  controller.capturePhoto();
                },
                onLongPressStart: (LongPressStartDetails tapUpDetails) {
                  if (GetPlatform.isIOS) {
                    controller.startCaptureVideo();
                  }
                },
                onLongPressEnd: (LongPressEndDetails tapUpDetails) {
                  if (GetPlatform.isIOS) {
                    controller.stopCaptureVideo();
                  }
                },
                child: Obx(
                  () => Container(
                    child: Center(
                        child: SonrIcons.Camera.gradient(
                      value: UserService.isDarkMode ? SonrGradients.PremiumWhite : SonrGradients.PremiumDark,
                      size: 40,
                    )),
                    decoration: Neumorphic.floating(
                        shape: BoxShape.circle,
                        border: controller.videoInProgress.value
                            ? Border.all(color: SonrColor.Critical, width: 4)
                            : Border.all(color: SonrColor.Black, width: 0)),
                  ),
                ),
              ),
              // Interior Compass
            ),
          ),
        ),
      ),
    ]);
  }
}

// ** Camera View Controller ** //
class CameraController extends GetxController {
  // Properties
  final doubleZoomed = false.obs;
  final isFlipped = false.obs;
  final videoDuration = 0.obs;
  final videoInProgress = false.obs;
  final zoomLevel = 0.0.obs;
  final hasCaptured = false.obs;

  // References
  var _isVideo = false;
  var _photoCapturePath = "";
  var _videoCapturePath = "";

  // Notifiers
  ValueNotifier<double> brightness = ValueNotifier(1);
  ValueNotifier<CaptureModes> captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<Size> photoSize = ValueNotifier(Size(Get.width, Get.height));
  ValueNotifier<Sensors> sensor = ValueNotifier(Sensors.BACK);
  ValueNotifier<CameraFlashes> switchFlash = ValueNotifier(CameraFlashes.NONE);
  ValueNotifier<double> zoomNotifier = ValueNotifier(0);

  // Controllers
  PictureController pictureController = PictureController();
  VideoController videoController = VideoController();

  // Video Duration Handling
  Stopwatch _stopwatch = Stopwatch();
  Timer _timer;

  // ** Constructer ** //
  CameraController() {
    zoomLevel.listen((value) {
      zoomNotifier.value = 1.0 / value;
    });
  }

  clearFromPreview() async {
    hasCaptured(false);
    _photoCapturePath = "";
    _videoCapturePath = "";
    _isVideo = false;
    Get.back();
  }

  continueWithCapture(Function(SonrFile file) selected) {
    Get.back();
    selected(getFile());
    _photoCapturePath = "";
    _videoCapturePath = "";
    _isVideo = false;
    hasCaptured(false);
  }

  // ^ Captures Photo ^ //
  capturePhoto() async {
    // Set Path
    var temp = await getApplicationDocumentsDirectory();
    var photoDir = await Directory('${temp.path}/photos').create(recursive: true);
    _photoCapturePath = '${photoDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    _isVideo = false;

    // Capture Photo
    await pictureController.takePicture(_photoCapturePath);
    hasCaptured(true);
  }

  // ^ Returns Captured Media File ^ //
  SonrFile getFile() {
    return SonrFileUtils.newSingle(path: _isVideo ? _videoCapturePath : _photoCapturePath, duration: videoDuration.value);
  }

  // ^ Captures Video ^ //
  startCaptureVideo() async {
    // Set Path
    var temp = await getApplicationDocumentsDirectory();
    var videoDir = await Directory('${temp.path}/videos').create(recursive: true);
    _videoCapturePath = '${videoDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
    _isVideo = true;

    // Capture Photo
    captureMode.value = CaptureModes.VIDEO;
    await videoController.recordVideo(_videoCapturePath);
    videoInProgress(true);

    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      videoDuration(_stopwatch.elapsedMilliseconds);
    });
  }

  // ^ Stops Video Capture ^ //
  stopCaptureVideo() async {
    // Save Video
    await videoController.stopRecordingVideo();

    // Reset Duration Management
    _stopwatch.reset();
    _timer.cancel();

    // Update State
    captureMode.value = CaptureModes.PHOTO;
    hasCaptured(true);
  }

  // ^ Flip Camera ^ //
  toggleCameraSensor() async {
    // Toggle
    isFlipped(!isFlipped.value);

    if (isFlipped.value) {
      sensor.value = Sensors.FRONT;
    } else {
      sensor.value = Sensors.BACK;
    }
  }
}
