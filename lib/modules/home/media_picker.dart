import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:media_picker_builder/data/album.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:media_picker_builder/media_picker_builder.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** MediaPicker Dialog View ** //
class MediaPicker extends GetView<MediaPickerController> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
      margin: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 80),
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

class _MediaGrid extends GetView<MediaPickerController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 4),
          itemCount: controller.currentAlbum.value.files.length,
          itemBuilder: (context, index) {
            return _MediaPickerItem(controller.currentAlbum.value.files[index]);
          });
    });
  }
}

// ** MediaPicker Item Widget ** //
class _MediaPickerItem extends GetView<MediaPickerController> {
  final MediaFile mediaFile;
  _MediaPickerItem(this.mediaFile);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onPressed: () => controller.selectedFile(mediaFile),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.file(
              File(mediaFile.thumbnailPath),
              fit: BoxFit.cover,
            ),
          ),
          if (mediaFile.type == MediaType.VIDEO)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 5, bottom: 5),
                child: Icon(
                  Icons.videocam,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ** MediaPicker GetXController ** //
class MediaPickerController extends GetxController {
  final albums = List<Album>().obs;
  final loaded = false.obs;
  final currentAlbum = Rx<Album>();
  final selectedFile = Rx<MediaFile>();

  @override
  onInit() {
    // Get Media Albums
    MediaPickerBuilder.getAlbums(
      withImages: true,
      withVideos: true,
      loadIOSPaths: true,
    ).then((value) {
      // Assign Values
      albums.assignAll(value);
      currentAlbum(albums.first);
      loaded(true);
    });
    super.onInit();
  }

  // ^ Process Selected File ^ //
  confirmSelectedFile() async {
    File mediaFile = File(selectedFile.value.path);
    Get.find<SonrService>().process(Payload.FILE, file: mediaFile);
  }
}
