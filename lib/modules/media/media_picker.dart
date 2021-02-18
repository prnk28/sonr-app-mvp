import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:sonr_core/sonr_core.dart';

// ** MediaPicker Sheet View ** //
class MediaPickerSheet extends GetView<MediaPickerController> {
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
class _MediaDropdownDialogBar extends GetView<MediaPickerController> {
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
      SonrText.medium(
        item.name,
        color: Colors.black,
      )
    ]);
  }
}

// ** Create Media Grid ** //
class _MediaGrid extends GetView<MediaPickerController> {
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
              return _MediaPickerItem(controller.allMedias[index], index);
            }),
      );
    });
  }
}

// ** MediaPicker Item Widget ** //
class _MediaPickerItem extends StatefulWidget {
  final Media mediaFile;
  final int index;
  _MediaPickerItem(this.mediaFile, this.index);

  @override
  _MediaPickerItemState createState() => _MediaPickerItemState();
}

// ** MediaPicker Item Widget State ** //
class _MediaPickerItemState extends State<_MediaPickerItem> {
  // Pressed Property
  bool isPressed = false;
  StreamSubscription<int> selectedStream;
  Uint8List thumbnail;

  // Listen to Selected File
  @override
  void initState() {
    selectedStream = Get.find<MediaPickerController>().selectedMediaIndex.listen((val) {
      if (widget.index != val && isPressed) {
        setState(() {
          isPressed = false;
        });
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
        setState(() {
          isPressed = !isPressed;

          if (isPressed) {
            Get.find<MediaPickerController>().selectedMediaIndex(widget.index);
            Get.find<MediaPickerController>().setMediaPickerItem(widget.mediaFile, thumbnail);
          } else {
            Get.find<MediaPickerController>().selectedMediaIndex(-1);
            Get.find<MediaPickerController>().setMediaPickerItem(null, null);
          }
        });
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          FutureBuilder(
              future: widget.mediaFile.getThumbnail(width: 200, height: 200),
              builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                if (snapshot.hasData) {
                  // Set Thumbnail
                  thumbnail = Uint8List.fromList(snapshot.data);

                  // Create Box
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

// ** Media Picker Controller ** //
class MediaPickerController extends GetxController {
  // Properties
  final allCollections = Rx<List<MediaCollection>>();
  final mediaCollection = Rx<MediaCollection>();
  final allMedias = <Media>[].obs;
  final selectedMediaIndex = (-1).obs;
  final hasGallery = false.obs;
  final loaded = false.obs;

  // References
  Media _selectedMedia;
  Uint8List _selectedThumbnail;

  // ^ Retreive Albums ^ //
  fetchMedia() async {
    // Get Collections
    List<MediaCollection> collections = await MediaGallery.listMediaCollections(
      mediaTypes: [MediaType.image, MediaType.video],
    );

    allCollections(collections);

    // List Collections
    collections.forEach((element) {
      // Set Has Gallery
      if (element.count > 0) {
        hasGallery(true);
      }

      // Check for Master Collection
      if (element.isAllCollection) {
        // Assign Values
        mediaCollection(element);
      }
    });

    if (mediaCollection.value.count > 0) {
      // Get Images
      final MediaPage imagePage = await mediaCollection.value.getMedias(
        mediaType: MediaType.image,
        take: 500,
      );

      // Get Videos
      final MediaPage videoPage = await mediaCollection.value.getMedias(
        mediaType: MediaType.video,
        take: 500,
      );

      // Combine Media
      final List<Media> combined = [
        ...imagePage.items,
        ...videoPage.items,
      ]..sort((x, y) => y.creationDate.compareTo(x.creationDate));

      // Set All Media
      allMedias.assignAll(combined);
    }
    loaded(true);
  }

  // ^ Method Updates the Current Media Collection ^ //
  updateMediaCollection(MediaCollection collection) async {
    // Reset Loaded
    loaded(false);
    mediaCollection(collection);

    // Get Images
    final MediaPage imagePage = await mediaCollection.value.getMedias(
      mediaType: MediaType.image,
      take: 500,
    );

    // Get Videos
    final MediaPage videoPage = await mediaCollection.value.getMedias(
      mediaType: MediaType.video,
      take: 500,
    );

    // Combine Media
    final List<Media> combined = [
      ...imagePage.items,
      ...videoPage.items,
    ]..sort((x, y) => y.creationDate.compareTo(x.creationDate));

    // Set All Media
    allMedias.assignAll(combined);
    loaded(true);
  }

  // ^ Set Media from Picker
  setMediaPickerItem(Media media, Uint8List thumb) {
    _selectedMedia = media;
    _selectedThumbnail = thumb;
  }

  // ^ Process Selected File ^ //
  confirmSelectedFile() async {
    // Validate File
    if (_selectedMedia != null) {
      // Retreive File and Process
      File mediaFile = await _selectedMedia.getFile();
      Get.find<SonrService>().setPayload(Payload.MEDIA, path: mediaFile.path, thumbnailData: _selectedThumbnail);

      // Go to Transfer
      Get.offNamed("/transfer");
    }
  }
}
