import 'dart:io';

import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

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
          child: AnimatedContainer(
              duration: 1.seconds,
              child: Column(children: [
                // Header Buttons
                SonrDialogBar(
                    title: SonrText.header("Select.."),
                    onCancel: () => Get.back(),
                    onAccept: () => controller.confirmSelectedFile()),

                // Grid Viw
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scroll) {
                    controller.handleScrollEvent(scroll);
                    return;
                  },
                  child: GridView.builder(
                      itemCount: controller.media.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return _MediaPickerItem(controller.media[index]);
                      }),
                ),
              ])),
        ));
  }
}

// ** MediaPicker Item Widget ** //
class _MediaPickerItem extends GetView<MediaPickerController> {
  final AssetEntity asset;
  _MediaPickerItem(this.asset);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: asset.thumbDataWithSize(200, 200),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return NeumorphicButton(
            onPressed: () => controller.selectedFile(asset),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Image.memory(
                    snapshot.data,
                    fit: BoxFit.cover,
                  ),
                ),
                if (asset.type == AssetType.video)
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
        return Container();
      },
    );
  }
}

// ** MediaPicker GetXController ** //
class MediaPickerController extends GetxController {
  // Properties
  List<AssetPathEntity> albums = List<AssetPathEntity>();
  List<AssetEntity> media = List<AssetEntity>();

  // References
  final selectedFile = Rx<AssetEntity>();
  int currentPage = 0;
  int lastPage;

  // ^ Initialize Controller ^ //
  void onInit() {
    fetchNewMedia();
    super.onInit();
  }

  // ^ Method handles Scroll Event ^ //
  handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        fetchNewMedia();
      }
    }
  }

  // ^ Fetch new Media ^ //
  fetchNewMedia() async {
    // Set Page
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();

    // Fetch Media
    if (result) {
      albums = await PhotoManager.getAssetPathList(onlyAll: true);
      media = await albums[0].getAssetListPaged(currentPage, 60);
      currentPage++;
    }
  }

  // ^ Process Selected File ^ //
  confirmSelectedFile() async {
    File assetFile = await selectedFile.value.file;
    Get.find<SonrService>().process(Payload.FILE, file: assetFile);
  }
}
