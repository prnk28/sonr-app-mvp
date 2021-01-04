import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';
import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'home_controller.dart';

// ** MediaPicker Dialog View ** //
class MediaPicker extends GetView<MediaPickerController> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
      margin: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 40),
      borderRadius: BorderRadius.circular(40),
      backendColor: Colors.transparent,
      child: Neumorphic(
          style: NeumorphicStyle(color: K_BASE_COLOR),
          child: Column(children: [
            // Header Buttons
            SonrDialogBar(
                title: SonrText.header("Select.."),
                onCancel: () => Get.back(),
                onAccept: () => controller.confirmSelectedFile()),
            Obx(() {
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

// ** Create Media Grid ** //
class _MediaGrid extends GetView<MediaPickerController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: 330,
        height: 565,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
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
    selectedStream =
        Get.find<MediaPickerController>().selectedFile.listen((val) {
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
    final defaultStyle = NeumorphicStyle(color: K_BASE_COLOR);
    final pressedStyle = NeumorphicStyle(
        color: K_BASE_COLOR,
        disableDepth: true,
        intensity: 0,
        border: NeumorphicBorder(
            isEnabled: true, width: 4, color: Colors.greenAccent));

    // Build Button
    return NeumorphicButton(
      style: isPressed ? pressedStyle : defaultStyle,
      onPressed: () {
        Get.find<MediaPickerController>().selectedFile(widget.mediaFile);
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          FutureBuilder(
              future: widget.mediaFile.getThumbnail(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(
                    Uint8List.fromList(snapshot.data),
                    fit: BoxFit.cover,
                  );
                } else if (snapshot.hasError) {
                  return Icon(Icons.error, color: Colors.red, size: 24);
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          widget.mediaFile.mediaType == MediaType.video
              ? Icon(Icons.play_circle_filled, color: Colors.white, size: 24)
              : const SizedBox()
        ],
      ),
    );
  }
}

// ** MediaPicker GetXController ** //
class MediaPickerController extends GetxController {
  final mediaCollection = Rx<MediaCollection>();
  final allMedias = List<Media>().obs;
  final selectedFile = Rx<Media>();
  final hasGallery = false.obs;
  final loaded = false.obs;

  @override
  onInit() async {
    fetch();
    super.onInit();
  }

  // ^ Retreive Albums ^ //
  fetch() async {
    // Get Collections
    List<MediaCollection> collections = await MediaGallery.listMediaCollections(
      mediaTypes: [MediaType.image, MediaType.video],
    );

    // List Collections
    collections.forEach((element) {
      // Log Collection
      print("Collection ${element.name}, with ${element.count} items");

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

  // ^ Process Selected File ^ //
  confirmSelectedFile() async {
    // Retreive File and Process
    File mediaFile = await selectedFile.value.getFile();
    Get.find<SonrService>().process(Payload.FILE, file: mediaFile);

    // Close Share Button
    Get.find<HomeController>().toggleExpand();

    // Go to Transfer
    Get.offNamed("/transfer");
  }
}
