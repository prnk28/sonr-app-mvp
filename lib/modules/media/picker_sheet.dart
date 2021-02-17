import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'media_controller.dart';

// ** MediaPicker Dialog View ** //
class MediaSheet extends GetView<MediaController> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
      borderRadius: BorderRadius.circular(40),
      backendColor: Colors.transparent,
      child: Neumorphic(
          style: NeumorphicStyle(color: SonrColor.base),
          child: Column(children: [
            // Header Buttons
            _MediaDropdownDialogBar(onCancel: () => Get.back(), onAccept: () => controller.confirmSelectedFile()),
            Obx(() {
              controller.fetchMedia();
              if (controller.loaded.value) {
                return _MediaGrid();
              } else {
                return NeumorphicProgressIndeterminate();
              }
            }),
          ])),
    );
  }
}

// ** Create Media Album Dropdown Bar ** //
class _MediaDropdownDialogBar extends GetView<MediaController> {
  // Properties
  final Function onCancel;
  final Function onAccept;

  // Constructer
  const _MediaDropdownDialogBar({Key key, @required this.onCancel, @required this.onAccept}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight + 16 * 2,
      child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // @ Top Left Close/Cancel Button
            SonrButton.circle(onPressed: onCancel, icon: SonrIcon.close),

            // @ Drop Down
            Neumorphic(
                style: NeumorphicStyle(
                  depth: 8,
                  shape: NeumorphicShape.flat,
                  color: SonrColor.base,
                ),
                margin: EdgeInsets.only(left: 14, right: 14),
                child: Container(
                    width: Get.width - 250,
                    margin: EdgeInsets.only(left: 12, right: 12),

                    // @ ValueBuilder for DropDown
                    child: ValueBuilder<MediaCollection>(
                      onUpdate: (value) {
                        controller.updateMediaCollection(value);
                      },
                      builder: (item, updateFn) {
                        return DropDown<MediaCollection>(
                          showUnderline: false,
                          isExpanded: true,
                          initialValue: controller.mediaCollection.value,
                          items: controller.allCollections.value,
                          customWidgets: List<Widget>.generate(controller.allCollections.value.length, (index) => _buildOptionWidget(index)),
                          onChanged: updateFn,
                        );
                      },
                    ))),

            // @ Top Right Confirm Button
            SonrButton.circle(onPressed: onAccept, icon: SonrIcon.accept),
          ]),
    );
  }

  // @ Builds option at index
  _buildOptionWidget(int index) {
    var item = controller.allCollections.value.elementAt(index);
    return Row(children: [
      Padding(padding: EdgeInsets.all(4)),
      SonrText.normal(
        item.name,
        color: Colors.black,
      )
    ]);
  }
}

// ** Create Media Grid ** //
class _MediaGrid extends GetView<MediaController> {
  _MediaGrid();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: Get.width - 10,
        height: 368,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: controller.allMedias.length,
            itemBuilder: (context, index) {
              return _MediaPickerItem(controller.allMedias[index]);
            }),
      );
    });
  }
}

// ** MediaPicker Item Widget ** //
class _MediaPickerItem extends StatefulWidget {
  final Media mediaFile;
  _MediaPickerItem(this.mediaFile);

  @override
  _MediaPickerItemState createState() => _MediaPickerItemState();
}

// ** MediaPicker Item Widget State ** //
class _MediaPickerItemState extends State<_MediaPickerItem> {
  // Pressed Property
  bool isPressed = false;
  StreamSubscription<Media> selectedStream;

  // Listen to Selected File
  @override
  void initState() {
    selectedStream = Get.find<MediaController>().selectedFile.listen((val) {
      if (widget.mediaFile == val) {
        if (!isPressed) {
          if (mounted) {
            setState(() {
              isPressed = true;
            });
          }
        }
      } else {
        if (isPressed) {
          if (mounted) {
            setState(() {
              isPressed = false;
            });
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    selectedStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize Styles
    final defaultStyle = NeumorphicStyle(intensity: 0.85, color: SonrColor.baseWhite);
    final pressedStyle = NeumorphicStyle(depth: -12, intensity: 0.85, shadowDarkColorEmboss: Colors.grey[700]);

    // Build Button
    return NeumorphicButton(
      padding: EdgeInsets.zero,
      style: isPressed ? pressedStyle : defaultStyle,
      onPressed: () {
        Get.find<MediaController>().selectedFile(widget.mediaFile);
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          FutureBuilder(
              future: widget.mediaFile.getThumbnail(width: 200, height: 200),
              builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                if (snapshot.hasData) {
                  return DecoratedBox(
                      child: Image.memory(
                        Uint8List.fromList(snapshot.data),
                        fit: BoxFit.cover,
                      ),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)));
                } else if (snapshot.hasError) {
                  return Icon(Icons.error, color: Colors.red, size: 24);
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          widget.mediaFile.mediaType == MediaType.video ? SonrIcon.video : const SizedBox(),
          _buildSelectedBadge()
        ],
      ),
    );
  }

  _buildSelectedBadge() {
    if (isPressed) {
      return Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(right: 4, bottom: 4),
          child: SonrIcon.gradient(SonrIcon.success.data, FlutterGradientNames.hiddenJaguar, size: 40));
    } else {
      return Container();
    }
  }
}
