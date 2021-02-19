import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:sonr_core/sonr_core.dart';

// ** MediaPicker Sheet View ** //
class PickerSheet extends GetView<MediaPickerController> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
      borderRadius: BorderRadius.circular(40),
      backendColor: Colors.transparent,
      child: Neumorphic(
          style: NeumorphicStyle(color: SonrColor.base),
          child: Column(children: [
            // @ Header Buttons
            Container(
                height: kToolbarHeight + 16 * 2,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //  Top Left Close/Cancel Button
                      SonrButton.circle(onPressed: () => Get.back(), icon: SonrIcon.close),

                      // Drop Down
                      Obx(() => SonrDropdown.albums(controller.allCollections.value, width: Get.width - 200, onChanged: (index) {
                            controller.refreshMedia(controller.allCollections.value[index]);
                          })),

                      // Top Right Confirm Button
                      SonrButton.circle(onPressed: () => controller.confirm(), icon: SonrIcon.accept),
                    ])),

            // @ Grid View
            Obx(() {
              if (controller.loaded.value) {
                return Container(
                  width: Get.width - 10,
                  height: 368,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
                      itemCount: controller.allMedias.length,
                      itemBuilder: (context, index) {
                        return _SonrMediaButton(controller.allMedias[index], index);
                      }),
                );
              } else {
                return NeumorphicProgressIndeterminate();
              }
            }),
          ])),
    );
  }
}

// ** Widget that Creates Button from Media and Index ** //
class _SonrMediaButton extends StatelessWidget {
  final Rx<Uint8List> thumbnail = Uint8List(0).obs;
  final Media media;
  final int index;

  // References
  final defaultStyle = NeumorphicStyle(intensity: 0.85, color: SonrColor.baseWhite);
  final pressedStyle = NeumorphicStyle(depth: -12, intensity: 0.85, shadowDarkColorEmboss: Colors.grey[700]);

  _SonrMediaButton(this.media, this.index, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    _getThumbnail();
    return ObxValue(
        (RxBool isPressed) => NeumorphicButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                isPressed(!isPressed.value);
                MediaPickerController.select(index, media, thumbnail.value);
              },
              style: isPressed.value ? pressedStyle : defaultStyle,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  Obx(() {
                    if (thumbnail.value.length > 0) {
                      return DecoratedBox(
                          child: Image.memory(Uint8List.fromList(thumbnail.value), fit: BoxFit.cover),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)));
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
                  media.mediaType == MediaType.video
                      ? SonrIcon.gradient(SonrIcon.getMediaTypeData(media.mediaType), FlutterGradientNames.glassWater, size: 28)
                      : const SizedBox(),
                  isPressed.value
                      ? Container(
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(right: 4, bottom: 4),
                          child: SonrIcon.gradient(SonrIcon.success.data, FlutterGradientNames.hiddenJaguar, size: 40))
                      : Container()
                ],
              ),
            ),
        (MediaPickerController.selectedIndex.value == index).obs);
  }

  _getThumbnail() async {
    var thumbBytes = await MediaPickerController.retreiveThumbnail(media);
    thumbnail(thumbBytes);
  }
}

// ** Media Picker Controller ** //
class MediaPickerController extends GetxController {
  // Properties
  final allCollections = Rx<List<MediaCollection>>();
  final allMedias = <Media>[].obs;
  final collection = Rx<MediaCollection>();
  final currentIndex = (-1).obs;
  final hasGallery = false.obs;
  final loaded = false.obs;

  static RxInt get selectedIndex => Get.find<MediaPickerController>().currentIndex;

  // References
  Media _selectedMedia;
  Uint8List _selectedThumbnail;

  // ^ Initial Method ^ //
  void onInit() {
    retreiveAlbums();
    super.onInit();
  }

  // ^ Retreive Albums ^ //
  static Future<Uint8List> retreiveThumbnail(Media media, {int width = 200, int height = 200, bool highQuality = false}) async {
    return await media.getThumbnail(width: width, height: height, highQuality: highQuality);
  }

  // ^ Retreive Albums ^ //
  retreiveAlbums() async {
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
        collection(element);
      }
    });

    if (collection.value.count > 0) {
      // Get Images
      final MediaPage imagePage = await collection.value.getMedias(
        mediaType: MediaType.image,
        take: 500,
      );

      // Get Videos
      final MediaPage videoPage = await collection.value.getMedias(
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
  refreshMedia(MediaCollection updatedCollection) async {
    // Reset Loaded
    loaded(false);
    collection(updatedCollection);

    // Get Images
    final MediaPage imagePage = await collection.value.getMedias(
      mediaType: MediaType.image,
      take: 500,
    );

    // Get Videos
    final MediaPage videoPage = await collection.value.getMedias(
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
  static select(int index, Media media, Uint8List thumb) {
    Get.find<MediaPickerController>()._selectedMedia = media;
    Get.find<MediaPickerController>()._selectedThumbnail = thumb;
    Get.find<MediaPickerController>().currentIndex(index);
  }

  // ^ Process Selected File ^ //
  confirm() async {
    // Validate File
    if (_selectedMedia != null) {
      // Retreive File and Process
      File mediaFile = await _selectedMedia.getFile();

      // Check for Thumbnail
      if (_selectedThumbnail != null) {
        Get.find<SonrService>().setPayload(Payload.MEDIA, path: mediaFile.path, thumbnailData: _selectedThumbnail);
      } else {
        Get.find<SonrService>().setPayload(Payload.MEDIA, path: mediaFile.path);
      }

      // Go to Transfer
      Get.offNamed("/transfer");
    }
  }
}
