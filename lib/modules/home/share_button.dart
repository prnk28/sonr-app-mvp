import 'dart:async';

import 'package:get/get.dart';
import 'package:sonr_app/modules/media/media_picker.dart';
import 'package:sonr_app/theme/theme.dart';

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<ShareButtonController>(
        autoRemove: false,
        init: ShareButtonController(),
        builder: (controller) {
          // Build Container
          return Align(
            alignment: controller.state.value.alignment,
            child: AnimatedContainer(
                curve: Curves.easeInBack,
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsetsDirectional.only(start: 30),
                width: controller.state.value.width,
                height: controller.state.value.height,
                child: Center(
                  child: GestureDetector(
                    onLongPress: controller.toggleRemote,
                    child: NeumorphicButton(
                      child: controller.state.value.getView(controller),
                      onPressed: controller.toggle,
                      style: SonrStyle.shareButton,
                    ),
                  ),
                )),
          );
        });
  }
}

// ** Close Share Button View ** //
class _DefaultView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      SonrIcon.send,
      SonrText(
        "Share",
        isGradient: true,
        isCentered: true,
        weight: FontWeight.w700,
        size: 32,
        key: key,
        gradient: FlutterGradientNames.glassWater.linear(),
      )
    ]);
  }
}

// ** Expanded Share Button View ** //
class _ExpandedView extends StatelessWidget {
  final ShareButtonController controller;

  const _ExpandedView(this.controller, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PlayAnimation<double>(
        tween: (0.0).tweenTo(1.0),
        duration: 150.milliseconds,
        delay: 150.milliseconds,
        builder: (context, child, value) {
          return Container(
            width: Get.width / 2 + 165,
            height: 130,
            child: AnimatedOpacity(
                opacity: value,
                duration: 150.milliseconds,
                child: NeumorphicTheme(
                    theme: NeumorphicThemeData(
                      baseColor: Color.fromRGBO(239, 238, 238, 1.0),
                      lightSource: LightSource.top,
                      depth: 8,
                      intensity: 0.4,
                    ),
                    child: _ShareButtonRow(controller))),
          );
        });
  }
}

// ** Pending Remote File View ** //
class _PendingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 120, height: 120, child: CircularProgressIndicator());
  }
}

// ** Enter Remote File Code View ** //
class _RemoteView extends StatelessWidget {
  final ShareButtonController controller;

  const _RemoteView(this.controller, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Focus Nodes
    final FocusNode first = FocusNode();
    final FocusNode second = FocusNode();
    final FocusNode third = FocusNode();

    // Build View
    return PlayAnimation<double>(
        tween: (0.0).tweenTo(1.0),
        duration: 150.milliseconds,
        delay: 150.milliseconds,
        builder: (context, child, value) {
          return Container(
            height: 130,
            width: Get.width / 2 + 200,
            child: AnimatedOpacity(
                opacity: value,
                duration: 150.milliseconds,
                child: NeumorphicTheme(
                    theme: NeumorphicThemeData(
                      baseColor: Color.fromRGBO(239, 238, 238, 1.0),
                      lightSource: LightSource.top,
                      depth: 8,
                      intensity: 0.4,
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      SonrText.title("Enter Code", color: SonrColor.White),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        Container(
                            width: 100,
                            child: SonrTextField(
                              autoFocus: true,
                              focusNode: first,
                              hint: "One",
                              value: '',
                              onChanged: (val) => controller.firstWord(val),
                              textInputAction: TextInputAction.next,
                            )),
                        Container(
                            width: 100,
                            child: SonrTextField(
                              focusNode: second,
                              hint: "Two",
                              value: '',
                              onChanged: (val) => controller.secondWord(val),
                              textInputAction: TextInputAction.next,
                            )),
                        Container(
                            width: 100,
                            child: SonrTextField(
                              focusNode: third,
                              hint: "Three",
                              value: '',
                              textInputAction: TextInputAction.done,
                              onChanged: (val) => controller.thirdWord(val),
                              onEditingComplete: () => controller.joinRemote(),
                            )),
                      ]),
                    ]))),
          );
        });
  }
}

// ** Share Button Row ** //
class _ShareButtonRow extends StatelessWidget {
  final ShareButtonController controller;
  const _ShareButtonRow(this.controller);
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.up,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              child: _ShareButtonItem(
                onPressed: () {
                  // Toggle Share Expand
                  controller.close();

                  // Check Permissions
                  if (Get.find<DeviceService>().cameraPermitted.val) {
                    Get.to(CameraView.withPreview(onMediaSelected: (MediaFile file) {
                      SonrService.queueMedia(file);
                      Get.toNamed("/transfer");
                    }), transition: Transition.downToUp);
                  } else {
                    Get.find<DeviceService>().requestCamera().then((value) {
                      // Go to Camera View
                      if (value) {
                        Get.to(CameraView.withPreview(onMediaSelected: (MediaFile file) {
                          SonrService.queueMedia(file);
                          Get.toNamed("/transfer");
                        }), transition: Transition.downToUp);
                      } else {
                        // Present Error
                        SonrSnack.error("Sonr cannot open Camera without Permissions");
                      }
                    });
                  }
                },
                type: ArtboardType.Camera,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(12)),
          Expanded(
            child: Container(
              child: _ShareButtonItem(
                onPressed: () {
                  controller.close();
                  // Check Permissions
                  if (Get.find<DeviceService>().galleryPermitted.val) {
                    MediaService.refreshGallery();
                    Get.bottomSheet(MediaPickerSheet(onMediaSelected: (file) {
                      SonrService.queueMedia(file);
                      Get.toNamed("/transfer");
                    }), isDismissible: false);
                  } else {
                    Get.find<DeviceService>().requestGallery().then((value) {
                      // Present Sheet
                      if (value) {
                        MediaService.refreshGallery();
                        Get.bottomSheet(MediaPickerSheet(onMediaSelected: (file) {
                          SonrService.queueMedia(file);
                          Get.toNamed("/transfer");
                        }), isDismissible: false);
                      } else {
                        // Present Error
                        SonrSnack.error("Sonr cannot open Media Picker without Gallery Permissions");
                      }
                    });
                  }
                },
                type: ArtboardType.Gallery,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(12)),
          Expanded(
            child: Container(
              child: _ShareButtonItem(
                onPressed: () {
                  SonrService.queueContact();

                  // Close Share Button
                  controller.close();

                  // Go to Transfer
                  Get.toNamed("/transfer");
                },
                type: ArtboardType.Contact,
              ),
            ),
          )
        ]);
  }
}

// ** Share Button Item View ** //
class _ShareButtonItem extends StatelessWidget {
  // Properties
  final ArtboardType type;
  final Function onPressed;

  // Method to Return Type
  String get _typeText => type.toString().split('.').last;

  const _ShareButtonItem({Key key, this.type, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: NeumorphicButton(
          style: NeumorphicStyle(
              surfaceIntensity: 0.3,
              shape: NeumorphicShape.flat,
              shadowDarkColor: SonrColor.fromHex("333333"),
              depth: 12,
              color: SonrColor.fromHex("EFEEEE"),
              boxShape: NeumorphicBoxShape.circle()),
          child: RiveContainer(
            type: type,
            width: Get.width,
            height: Get.height,
          ),
          onPressed: onPressed,
        ),
      ),
      Padding(padding: EdgeInsets.only(top: 4)),
      SonrText(_typeText, weight: FontWeight.w500, size: 14, key: key, color: Colors.white),
    ]);
  }
}

enum ShareButtonState { Default, Expanded, Remote, Pending }

extension ShareButtonStateUtil on ShareButtonState {
  Alignment get alignment {
    switch (this) {
      case ShareButtonState.Expanded:
        return Alignment.bottomCenter;
      case ShareButtonState.Remote:
        return Alignment.center;
        break;
      case ShareButtonState.Pending:
        return Alignment.bottomCenter;
      default:
        return Alignment.bottomCenter;
    }
  }

  double get width {
    switch (this) {
      case ShareButtonState.Expanded:
        return Get.width / 2 + 165;
      case ShareButtonState.Remote:
        return Get.width / 2 + 200;
        break;
      case ShareButtonState.Pending:
        return Get.width / 3;
      default:
        return Get.width / 2 + 30;
    }
  }

  double get height {
    switch (this) {
      case ShareButtonState.Expanded:
        return 130;
      case ShareButtonState.Remote:
        return 165;
        break;
      case ShareButtonState.Pending:
        return Get.width / 3;
      default:
        return 70;
    }
  }

  Widget getView(ShareButtonController controller) {
    switch (this) {
      case ShareButtonState.Expanded:
        return _ExpandedView(controller);
      case ShareButtonState.Remote:
        return _RemoteView(controller);
      case ShareButtonState.Pending:
        return _PendingView();
      default:
        return _DefaultView();
    }
  }
}

class ShareButtonController extends GetxController {
  // Properties
  final counter = 0.obs;
  final state = ShareButtonState.Default.obs;

  // Words
  final firstWord = "".obs;
  final secondWord = "".obs;
  final thirdWord = "".obs;

  // References
  Timer _timer;

  // ^ Close Share Button ^ //
  void close() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      HapticFeedback.mediumImpact();
      state(ShareButtonState.Default);
      counter(0);
    }
  }

  // ^ Expand Share Button ^ //
  void expand(double timeout, ShareButtonState previousState) {
    HapticFeedback.heavyImpact();

    // Create Timeout
    _timer = Timer.periodic(500.milliseconds, (_) {
      // Add to Counter
      counter(counter.value += 500);

      // Check if Timeout Reached
      if (counter.value == timeout) {
        if (state.value == previousState) {
          close();
        }
      }
    });
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggle() {
    if (state.value == ShareButtonState.Default) {
      state(ShareButtonState.Expanded);
      expand(4000, state.value);
    } else {
      close();
    }
  }

  // ^ Toggles Remote Share View ^ //
  void toggleRemote() {
    if (state.value == ShareButtonState.Default) {
      state(ShareButtonState.Remote);
      expand(20000, state.value);
    } else {
      state(ShareButtonState.Default);
    }
  }

  // ^ Join Remote Point ^ //
  joinRemote() {
    // Clean words into new string
    var group = "${firstWord.value}-${secondWord.value}-${thirdWord.value}";
    print(group);
    SonrService.joinRemote(group);
    state(ShareButtonState.Pending);
  }
}
