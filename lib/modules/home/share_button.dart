import 'dart:async';

import 'package:get/get.dart';
import 'package:sonr_app/modules/media/media_picker.dart';
import 'package:sonr_app/theme/theme.dart';

// @ Widget Constants
const double K_ITEM_SPACING = 12;
const double K_EXPANDED_HEIGHT = 130;
const double K_EXPANDED_WIDTH = 165;
const double K_DEFAULT_HEIGHT = 70;
const double K_DEFAULT_WIDTH = 30;
const Duration K_ANIMATION_DURATION = const Duration(milliseconds: 200);

class ShareButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<ShareButtonController>(
        init: ShareButtonController(),
        builder: (controller) {
          final expandedView = _ExpandedView(controller);
          final defaultView = _DefaultView();
          return Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
                curve: Curves.easeInBack,
                padding: EdgeInsetsDirectional.only(start: 30),
                width: controller.isExpanded.value ? Get.width / 2 + K_EXPANDED_WIDTH : Get.width / 2 + K_DEFAULT_WIDTH,
                height: controller.isExpanded.value ? K_EXPANDED_HEIGHT : K_DEFAULT_HEIGHT,
                duration: K_ANIMATION_DURATION,
                child: Center(
                  child: GestureDetector(
                    onLongPress: () async {
                      String name = await SonrService.createGroup();
                      print("New Group Name $name");
                      Get.dialog(_GroupView(name), barrierDismissible: false);
                    },
                    child: NeumorphicButton(
                      child: controller.isExpanded.value ? expandedView : defaultView,
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

// ** Dialog Group View ** //
class _GroupView extends StatelessWidget {
  final String name;

  const _GroupView(this.name, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetX<GroupViewController>(
        init: GroupViewController(name),
        builder: (controller) {
          return GlassContainer(
              width: Get.width - 24,
              height: Get.height - 64,
              child: Column(children: [
                SonrText.title(name),
                ListView.builder(
                    itemCount: controller.members.length,
                    itemBuilder: (context, index) {
                      var peer = controller.members.values.toList()[index];
                      return ListTile(onTap: () {}, title: peer.fullName, subtitle: Text(peer.platform.toString()));
                    })
              ]));
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
          Padding(padding: EdgeInsets.all(K_ITEM_SPACING)),
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
          Padding(padding: EdgeInsets.all(K_ITEM_SPACING)),
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
              shape: NeumorphicShape.convex,
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

class ShareButtonController extends GetxController {
  // Properties
  final isExpanded = false.obs;
  final counter = 0.obs;

  // References
  Timer _timer;

  // ^ Close Share Button ^ //
  void close() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      HapticFeedback.mediumImpact();
      isExpanded(false);
      counter(0);
    }
  }

  // ^ Expand Share Button ^ //
  void expand() {
    HapticFeedback.heavyImpact();
    isExpanded(true);

    // Create Timeout
    _timer = Timer.periodic(500.milliseconds, (_) {
      // Add to Counter
      counter(counter.value += 500);

      // Check if Timeout Reached
      if (counter.value == 4000) {
        if (isExpanded.value) {
          close();
        }
      }
    });
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggle() {
    if (!isExpanded.value) {
      expand();
    } else {
      close();
    }
  }
}

class GroupViewController extends GetxController {
  final String _groupName;
  final members = RxMap<String, Peer>();

  GroupViewController(this._groupName) {
    SonrService.groups.listen((vals) {
      if (vals.containsKey(_groupName)) {
        var group = vals[_groupName];
        members(group.members);
        members.refresh();
      }
    });
  }
}
